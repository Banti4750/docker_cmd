# Docker Internal Architecture

## Complete Flow

```
+----------------+        REST API         +------------------+
|                | ----------------------> |                  |
|  Docker Client |    (Unix Socket)        |  Docker Daemon   |
|   (docker)     | <---------------------- |   (dockerd)      |
|                |                         |                  |
+----------------+                         +--------+---------+
                                                    |
                                                    | gRPC Protocol
                                                    |
                                           +--------v---------+
                                           |                   |
                                           |   containerd      |
                                           |                   |
                                           +--------+----------+
                                                    |
                                                    | Creates per-container
                                                    |
                                           +--------v----------+
                                           |                    |
                                           |  containerd-shim   |
                                           |                    |
                                           +--------+-----------+
                                                    |
                                                    | Executes
                                                    |
                                           +--------v---------+
                                           |                   |
                                           |      runc         |
                                           |                   |
                                           +--------+----------+
                                                    |
                                                    | Creates & Starts
                                                    |
                                           +--------v----------+
                                           |                    |
                                           |    Container       |
                                           | (Linux Process)    |
                                           |                    |
                                           +--------------------+
```

---

## 1. Docker Client (`docker`)

| Detail        | Value                        |
|---------------|------------------------------|
| **Binary**    | `/usr/bin/docker`            |
| **Role**      | CLI tool - user's entry point |

### Tasks:
- Accepts user commands like `docker run`, `docker build`, `docker ps`
- Converts commands into **REST API calls**
- Sends API requests to Docker Daemon via **Unix socket** (`/var/run/docker.sock`)
- Displays output/results back to the user
- Has NO role in actually running containers - it is just a client

```bash
# Example: when you type
docker run nginx

# Client sends a REST API call to daemon:
# POST /v1.41/containers/create
# POST /v1.41/containers/{id}/start
```

---

## 2. Docker Daemon (`dockerd`)

| Detail        | Value                          |
|---------------|--------------------------------|
| **Binary**    | `/usr/bin/dockerd`             |
| **Role**      | Central management engine      |

### Tasks:
- Listens on Unix socket `/var/run/docker.sock` for API requests from client
- Manages high-level Docker objects:
  - **Images** (pull, build, push)
  - **Networks** (bridge, overlay, host)
  - **Volumes** (create, mount)
  - **Authentication** (registry login)
- Does **NOT** run containers directly anymore (decoupled since Docker 1.11)
- Talks to **containerd** using **gRPC protocol** to handle container lifecycle
- Handles orchestration, logging, and API serving

```
dockerd  ---gRPC--->  containerd
```

> **Why gRPC?** gRPC is a high-performance, binary protocol built on HTTP/2.
> It allows fast, reliable, and structured communication between dockerd and containerd.
> This decoupling means containerd can run independently without dockerd.

---

## 3. containerd

| Detail        | Value                              |
|---------------|------------------------------------|
| **Binary**    | `/usr/bin/containerd`              |
| **Role**      | Container runtime manager (high-level runtime) |

### Tasks:
- Receives instructions from dockerd via **gRPC** (listens on `/run/containerd/containerd.sock`)
- Manages the **full container lifecycle**:
  - Image pull & storage
  - Container creation
  - Container start/stop/delete
  - Snapshot management (filesystem layers)
- Creates a **containerd-shim** for each container
- Does NOT directly create containers - delegates to **runc**
- Can work **independently** without Docker (used by Kubernetes directly via CRI)

```
containerd is a CNCF graduated project - it is NOT tied to Docker only
```

---

## 4. containerd-shim

| Detail        | Value                                  |
|---------------|----------------------------------------|
| **Binary**    | `/usr/bin/containerd-shim-runc-v2`     |
| **Role**      | Intermediate process between containerd and container |

### Tasks:
- Acts as the **parent process** of every running container
- **One shim per container** - each container gets its own shim process
- Allows **containerd to restart** without killing running containers (daemonless containers)
- Allows **dockerd to restart** without killing running containers
- Reports container's exit status back to containerd
- Manages **STDIO** (stdin, stdout, stderr) for the container
- Keeps the container running even if containerd or dockerd crashes

```
Why shim exists?
- Without shim: dockerd crash = all containers die
- With shim:    dockerd crash = containers keep running (zero downtime upgrades)
```

---

## 5. runc

| Detail        | Value                          |
|---------------|--------------------------------|
| **Binary**    | `/usr/bin/runc`                |
| **Role**      | Low-level container runtime (OCI runtime) |

### Tasks:
- **Actually creates and starts the container** (this is where the real work happens)
- Implements the **OCI (Open Container Initiative) runtime specification**
- Interfaces with the **Linux kernel** to set up:
  - **Namespaces** (pid, net, mnt, uts, ipc, user) - isolation
  - **Cgroups** (cpu, memory, io limits) - resource control
  - **chroot / pivot_root** - filesystem isolation
  - **Seccomp** - system call filtering
  - **AppArmor/SELinux** - security profiles
- runc is a **short-lived process** - it starts the container and then **exits**
- After runc exits, the **shim becomes the parent** of the container process

```
runc creates the container --> exits --> shim takes over as parent
```

---

## 6. Container (Linux Process)

| Detail        | Value                          |
|---------------|--------------------------------|
| **Binary**    | Whatever the container runs (e.g., `/usr/sbin/nginx`) |
| **Role**      | The actual isolated process     |

### What it is:
- Just a **regular Linux process** with isolation applied
- Runs inside its own set of **namespaces**
- Has resource limits via **cgroups**
- Has its own **root filesystem** (from the image layers)
- Parent process is the **containerd-shim**

---

## Summary: Binary Locations on Linux

| Component          | Binary Path                            |
|--------------------|----------------------------------------|
| Docker Client      | `/usr/bin/docker`                      |
| Docker Daemon      | `/usr/bin/dockerd`                     |
| containerd         | `/usr/bin/containerd`                  |
| containerd-shim    | `/usr/bin/containerd-shim-runc-v2`     |
| runc               | `/usr/bin/runc`                        |

---

## Summary: Communication Protocols

```
Docker Client  --REST API (Unix Socket)--> Docker Daemon
Docker Daemon  --gRPC Protocol-----------> containerd
containerd     --fork/exec--------------> containerd-shim
shim           --fork/exec--------------> runc
runc           --Linux syscalls----------> Container (kernel namespaces + cgroups)
```

---

## Quick One-Line Summary

```
docker (CLI) --> dockerd (API+mgmt) --gRPC--> containerd (lifecycle)
  --> shim (parent process) --> runc (creates container) --> Container (isolated process)
```
