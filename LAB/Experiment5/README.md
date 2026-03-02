# Experiment 5: Docker - Volumes, Environment Variables, Monitoring and Networks

## Part 1: Docker Volumes 
1. Creating a container that writes data using `docker run -it --name ish-cont ubuntu /bin/bash`

- using the echo command "Hello world" was written in message.txt file by resolving the directory not found error

- And later displayed using `cat` command 

![](./1.png)


- Now after exitting when we restart (remove and try to start the containe) the container using `docker start ish-cont` and then try to display data using `docker exec ish-cont cat /data/message.txt` the output was **Data DIDN'T persist** and an error was encountered
![](./2.png)

2. Volume types

- 2.1 Anonymous Volume (has auto generated name)

- using command `docker run -d -v /app/data --name web1 nginx` to create a anonymous volume for temporary data storage 

- And then using `docker volume ls` command anonymous value with a random hash can be displayed
![](./3.png)

- Verifying the mount point using `docker inspect web1 | grep -A 5 Mounts`
![](./4.png)

- 2.2 Named volumes 

- using command `docker volume create ivol` a volume named **ivol** is created.

- Using `docker run -d -v ivol:/app/data --name web2 nginx` the named volume can be used
![](./5.png)
- And can be verified using `docker volume ls` command and inspected using `docker volume inspect ivol`
![](./6.png)
![](./7.png)

3. Bindmounts
- Creating a directory on host using `mkdir ~/myapp-data` 

- Then mounting this host directory ro the container using `docker run -d -v ~/myapp-data:/app/data --name web3 nginx`
![](./8.png)

- now to add file on host `echo "From Host" > ~/myapp-data/host-file.txt` and checking in the container using `docker exec web3 cat /app/data/host-file.txt`
![](./9.png)

## 3 Practical Volume examples

- 3.1 Database with persistant storage

- To create a container with named volume using `docker run -d \
  --name mysql-db \
  -v mysql-data:/var/lib/mysql \
  -e MYSQL_ROOT_PASSWORD=secret \
  mysql:8.0` since the sql image wasnt found locally it was pulled



![](./10.png)

- To check if data persisted i stopped and removed using `docker stop` and `docker rm` commands and later created a new container *new-mysql* and clearly data was preserved
![](./11.png)

- 3.2 Web App with configuration files

- In a newly made directory using `mkdir ~/nginx-config` , a new nginx.conf file was made using `echo 'server {
    listen 80;
    server_name localhost;
    location / {
        return 200 "Hello from mounted config!";
    }
}' > ~/nginx-config/nginx.conf`

![](./12.png)
- and then nginx was with config bind mount and tested with`curl` command
![](./13.png)
4. Volume management commands

- 4.1 To list all volumes `docker volumes ls` was used

![](./14.png)

- 4.2 To create a volume `docker volume create xyz` was used (here named)

- 4.3 To inspect volumes `docker volume inspect xyz-volume` was used

- 4.4 To remove unused volumes ` docker volume prune` was used
![](./15.png)

- 4.5 To remove specific volume `docker volume rm xyz` is used
![](./16.png)

## Part 2: Environment Variables 

1. Setting Environment variables using
- 1.1 
![](./17.png)
![](./18.png)
![](./19.png)
![](./20.png)
![](./21.png)
![](./22.png)
![](./23.png)
![](./24.png)
![](./25.png)



