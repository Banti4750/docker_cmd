docker commit -m "commit msg" mynginx mynginx:v1 -> for create a new image named "mynginx:v1" from the container named "mynginx"

#delete all images
docker image prune -a -f -> for remove all images from the local machine

#delete all containers
docker container prune -f -> for remove all containers from the local machine

#delete all volumes
docker volume prune -f -> for remove all volumes from the local machine