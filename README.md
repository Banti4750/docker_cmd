# Docker Commands 🐳

A beginner-friendly repository for learning and practicing essential Docker commands with examples.

This repository is designed for students, developers, and DevOps beginners who want to learn Docker from scratch and understand how containers work in real-world development.

---

## What is Docker?

Docker is a containerization platform that allows developers to package applications with all dependencies and run them consistently across different environments.

---

## Topics Covered

- Docker Installation
- Docker Images
- Docker Containers
- Docker Volumes
- Docker Networks
- Docker Logs
- Docker Exec Commands
- Dockerfile Basics
- Docker Compose Basics

---

## Basic Docker Commands

### Check Docker Version

```bash
docker --version
```

Shows installed Docker version.

---

### Pull an Image

```bash
docker pull nginx
```

Downloads an image from Docker Hub.

---

### List Images

```bash
docker images
```

Shows all downloaded images.

---

### Run a Container

```bash
docker run nginx
```

Creates and starts a container.

To run in background:

```bash
docker run -d nginx
```

---

### List Running Containers

```bash
docker ps
```

Shows active containers.

To see all containers:

```bash
docker ps -a
```

---

### Stop a Container

```bash
docker stop <container_id>
```

Stops a running container.

---

### Remove a Container

```bash
docker rm <container_id>
```

Deletes a container.

---

### Remove an Image

```bash
docker rmi <image_id>
```

Deletes an image.

---

### View Container Logs

```bash
docker logs <container_id>
```

Shows container logs.

---

### Execute Commands Inside Container

```bash
docker exec -it <container_id> bash
```

Access container terminal.

---

### Build Image from Dockerfile

```bash
docker build -t myapp .
```

Builds a custom Docker image.

---

### Run Container with Port Mapping

```bash
docker run -p 3000:3000 myapp
```

Maps container port to local machine.

---

## Why This Repository?

✔ Beginner Friendly  
✔ Real-world Commands  
✔ Easy Examples  
✔ Helpful for DevOps Interviews  
✔ Useful for Backend Developers  

---

## Who Should Use This?

- Students learning DevOps
- Backend Developers
- Software Engineers
- Cloud Enthusiasts

---

## Contributions

Contributions are welcome. Feel free to fork the repo and create a pull request.

---

## Author

Created by [Banti](https://github.com/banti4750)