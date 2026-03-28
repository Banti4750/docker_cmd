docker commit -m "commit msg" mynginx mynginx:v1 -> for create a new image named "mynginx:v1" from the container named "mynginx"

#delete all images
docker image prune -a -f -> for remove all images from the local machine

#delete all containers
docker container prune -f -> for remove all containers from the local machine

#delete all volumes
docker volume prune -f -> for remove all volumes from the local machine

docker system prune -a -f -> for remove all unused data (containers, images, volumes, networks) from the local machine

docker system df -> for display the disk usage of Docker images, containers, volumes, and build cache on the local machine

docker system df -v -> for display the detailed disk usage of Docker images, containers, volumes, and build cache on the local machine

docker login -u <username> -p <password> -> for login to Docker Hub with the specified username and password
docker logout -> for logout from Docker Hub
docker build -t <image_name>:<tag> . -> for build a Docker image from the current directory with the specified image name and tag
docker push <image_name>:<tag> -> for push the specified image to Docker Hub
docker pull <image_name>:<tag> -> for pull the specified image from Docker Hub
