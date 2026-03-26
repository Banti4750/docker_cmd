# docker cammand

docker ps -> for check the running container

docker run -d -p 80:80 nginx -> for run the nginx container in detached mode and map the port 80 of the container to port 80 of the host machine

docker run -d -p 8080:80 nginx -> for run the nginx container in detached mode and map the port 80 of the container to port 8080 of the host machine

docker run -d -p 8080:80 --name mynginx nginx -> for run the nginx container in detached mode, map the port 80 of the container to port 8080 of the host machine and give the container a name "mynginx"

docker run -d -p 8080:80 --name mynginx -v /home/user/nginx/html:/usr/share/nginx/html nginx -> for run the nginx container in detached mode, map the port
80 of the container to port 8080 of the host machine, give the container a name "mynginx" and mount the host directory /home/user/nginx/html to the container directory /usr/share/nginx/html

docker run -d -p 8080:80 --name mynginx -v /home/user/nginx/html:/usr/share/nginx/html -e NGINX_HOST=example.com
-> for run the nginx container in detached mode, map the port 80 of the container to port 8080 of the host machine, give the container a name "mynginx", mount the host directory /home/user/nginx/html to the container directory /usr/share/nginx/html and set the environment variable NGINX_HOST to example.com


docker run -d -p 8080:80 --name mynginx -v /home/user/nginx/html:/usr/share/nginx/html -e NGINX_HOST=example.com
-> for run the nginx container in detached mode, map the port 80 of the container to port 8080 of the host machine, give the container a name "mynginx", mount the host directory /home/user/nginx/html to the container directory /usr/share/nginx/html and set the environment variable NGINX_HOST to example.com


docker run -d -p 8080:80 --name mynginx -v /home/user/nginx/html:/usr/share/nginx/html -e NGINX_HOST=example.com -e NGINX_PORT=80
-> for run the nginx container in detached mode, map the port 80 of the container to port 8080 of the host machine, give the container

docker images -> for check the available images in the local machine
docker pull nginx -> for pull the nginx image from the docker hub
docker rmi nginx -> for remove the nginx image from the local machine
docker rm mynginx -> for remove the container named "mynginx"
docker logs mynginx -> for check the logs of the container named "mynginx"
docker logs --since 10m mynginx -> for check the logs of the container named "mynginx" since the last 10 minutes
docker exec -it mynginx bash -> for access the container named "mynginx"
docker inspect mynginx -> for check the details of the container named "mynginx"
docker stats mynginx -> for check the resource usage of the container named "mynginx"
docker top mynginx -> for check the running processes in the container named "mynginx"
docker cp mynginx:/usr/share/nginx/html/index.html /home/user/nginx/html -> for copy the file index.html from the container named "mynginx" to the host directory /home/user/nginx/html
docker cp /home/user/nginx/html/index.html mynginx:/usr/share/nginx/html -> for copy the file index.html from the host directory /home/user/nginx/html to the container named "mynginx"

docker run -it ubuntu bash -> for run the ubuntu container in interactive mode and access the bash shell of the container

docker container exec -it mynginx bash -> for access the container named "mynginx" in interactive mode and access the bash shell of the container


# The primary difference is that docker stop initiates a graceful shutdown by sending a SIGTERM signal first, allowing the application time to clean up, whereas docker kill forces immediate termination by sending a SIGKILL signal with no grace period.

docker stop mynginx -> for stop the container named "mynginx"
docker kill mynginx -> for kill the container named "mynginx"

docker container prune  -f-> for remove all stopped containers, unused networks, dangling images and build cache