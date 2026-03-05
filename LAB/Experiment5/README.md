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

1. **Setting Environment variables using**
- 1.1 Using -e flag
```Docker
# Single variable
docker run -d \
  --name app1 \
  -e DATABASE_URL="postgres://user:pass@db:5432/mydb" \
  -e DEBUG="true" \
  -p 3000:3000 \
  nginx
 ```
![](./17.png)
```Dockerfile
# Multiple variables
docker run -d \
  -e VAR1=value1 \
  -e VAR2=value2 \
  -e VAR3=value3 \
  nginx
```

![](./18.png)

- 1.2  Using –env-file
```bash
# Create .env file
echo "DATABASE_HOST=localhost" > .env
echo "DATABASE_PORT=5432" >> .env
echo "API_KEY=secret123" >> .env

# Use env file
docker run -d \
  --env-file .env \
  --name app2 \
  nginx

# Use multiple env files
docker run -d \
  --env-file .env \
  --env-file .env.secrets \
  nginx
```
![](./19.png)
![](./20.png)

- 1.3 Dockerfile
```Dockerfile
FROM ubuntu
# Set default environment variables
ENV NODE_ENV=production
ENV PORT=3000
ENV APP_VERSION=1.0.0
```

![](./21.png)

2. **Environment Variables in Applications**

- Making a python app **app.py** with the followinf contents
```python
# app.py
import os
from flask import Flask

app = Flask(__name__)

# Read environment variables
db_host = os.environ.get('DATABASE_HOST', 'localhost')
debug_mode = os.environ.get('DEBUG', 'false').lower() == 'true'
api_key = os.environ.get('API_KEY')

@app.route('/config')
def config():
    return {
        'db_host': db_host,
        'debug': debug_mode,
        'has_api_key': bool(api_key)
    }

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 5000))
    app.run(host='0.0.0.0', port=port, debug=debug_mode)
```

- Dockerfile contents
```Dockerfile
FROM python:3.9-slim

# Set environment variables at build time
ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1

WORKDIR /app

COPY requirements.txt .
RUN pip install -r requirements.txt

COPY app.py .

# Default runtime environment variables
ENV PORT=5000
ENV DEBUG=false

EXPOSE 5000

CMD ["python", "app.py"]
```
3. testing environment variables
```Docker
# Run with custom env vars
docker run -d \
  --name flask-app \
  -p 5000:5000 \
  -e DATABASE_HOST="prod-db.example.com" \
  -e DEBUG="true" \
  -e PORT="8080" \
  ish-flask-app

# Check environment in running container
docker exec flask-app env
docker exec flask-app printenv DATABASE_HOST

# Test the endpoint
curl http://localhost:5000/config
```

![](./22.png)
![](./23.png)
![](./24.png)

## Part 3: Docker Monitoring

- 3.1 Basic commands
```docker
# Live stats for all containers
docker stats
```
![](./25.png)

```docker
# Live stats for specific containers
docker stats container1 container2

```
- Here my container 1 and 2 are app1 and app2
![](./26.png)


```docker
# Specific format output
docker stats --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}"
```
![](./27.png)
```
# No-stream (single snapshot)
docker stats --no-stream

# All containers (including stopped)
docker stats --all
```



![](./28.png)
![](./29.png)

- 3.2 Process Monitoring
```docker
# View processes in container

docker top container-name# View with full command line

docker top container-name -ef# Compare with host processes

ps aux | grep docker
```
![](./30.png)
![](./31.png)



- 3.3: docker logs - Application Logs
```docker
# View logs

docker logs container-name# Follow logs (like tail -f)

C# Last N lines

docker logs --tail 100 container-name# Logs with timestamps

docker logs -t container-name# Logs since specific time

docker logs --since 2024-01-15 container-name# Combine options

docker logs -f --tail 50 -t container-name
```
![](./32.png)



- 3.4: Container Inspection
```docker
# Detailed container info

docker inspect container-name
# Specific information

docker inspect --format='{{.State.Status}}' container-name

docker inspect --format='{{.Config.Env}}' container-name

docker inspect --format='{{.NetworkSettings.IPAddress}}' container-name
# Resource limits

docker inspect --format='{{.HostConfig.Memory}}' container-name

docker inspect --format='{{.HostConfig.NanoCpus}}' container-name
```
![](./33.png)



- 3.5: Events Monitoring
```Docker
# Monitor Docker events in real-time

docker events
# Filter events

docker events --filter 'type=container'

docker events --filter 'event=start'

docker events --filter 'event=die'
# Since specific time

docker events --since '2024-01-15'# Format output

docker events --format '{{.Type}} {{.Action}} {{.Actor.Attributes.name}} '

```
![](./34.png)

- 3.6  Practical Monitoring Script
```
#!/bin/bash
# monitor.sh - Simple Docker monitoring
echo "=== Docker Monitoring Dashboard ==="
echo "Time: $(date)"echo
echo "1. Running Containers:"

docker ps --format "table \t\t"echo



echo "2. Resource Usage:"

docker stats --no-stream --format "table \t\t\t\t"echo



echo "3. Recent Events:"

docker events --since '5m' --until '0s' --format ' ' | tail -5echo



echo "4. System Info:"

docker system df
```
![](./35.png)
![](./36.png)


## Part 4: Docker Networks

- 4.1: Understanding Docker Network Types
```docker
# Default networks

docker network ls
```
![](./37.png)


- 4.2: Network Types Explained

1. Bridge Network (Default)
```docker 
# Containers on bridge network can communicate
# Each container gets own IP, isolated from host
# Create custom bridge network

docker network create my-network
```
![](./38.png)

```docker
# Inspect network

docker network inspect my-network
```
![](./39.png)


```docker
# Run containers on custom network

docker run -d --name web1 --network my-network nginx

docker run -d --name web2 --network my-network nginx
```
![](./40.png)

```docker
# Containers can communicate using container names

docker exec web1 curl http://web2
```
![](./41.png)



2. Host Network
```docker
# Container uses host's network directly# No network isolation, shares host's IP

docker run -d --name host-app --network host nginx
# Access directly on host port 80

curl http://localhost
```
![](./42.png)


3. None Network
```docker
# No network access
docker run -d --name isolated-app --network none alpine sleep 3600

# Test - no network interfaces
docker exec isolated-app ifconfig
# Only loopback interface
```
![](./43.png)

4. Overlay Network (Swarm)
```docker
# For Docker Swarm - multi-host networking
docker network create --driver overlay my-overlay
```



- 4.3: Network Management Commands

```docker
# Create network
docker network create app-network
docker network create --driver bridge --subnet 172.20.0.0/16 --gateway 172.20.0.1 my-subnet

# Connect container to network
docker network connect app-network existing-container

# Disconnect container from network
docker network disconnect app-network container-name

# Remove network
docker network rm network-name

# Prune unused networks
docker network prune


```
![](./44.png)
![](./45.png)
![](./46.png)



- 4.4: Multi-Container Application Example

Web App + Database Communication
```docker
# Create network

docker network create app-network# Start database

docker run -d \

--name postgres-db \

--network app-network \

-e POSTGRES_PASSWORD=secret \

-v pgdata:/var/lib/postgresql/data \

postgres:15# Start web application

docker run -d \

--name web-app \

--network app-network \

-p 8080:3000 \

-e DATABASE_URL="postgres://postgres:secret@postgres-db:5432/mydb" \

-e DATABASE_HOST="postgres-db" \

node-app# Web app can connect to database using "postgres-db" hostname
```
![](./47.png)
![](./48.png)


- 4.5: Network Inspection & Debugging
```docker
# Inspect network

docker network inspect bridge# Check container IP

docker inspect --format='' container-name# DNS resolution test

docker exec container-name nslookup another-container# Network connectivity test

docker exec container-name ping -c 4 google.com

docker exec container-name curl -I http://another-container# View network ports

docker port container-name
```
![](./49.png)
![](./50.png)
![](./51.png)
![](./52.png)

- 4.6: Port Publishing vs Exposing
```docker
# PORT PUBLISHING (host:container)

docker run -d -p 80:8080 --name app1 nginx# Host port 80 → Container port 8080# Dynamic port publishing

docker run -d -p 8080 --name app2 nginx# Docker assigns random host port# Multiple ports

docker run -d -p 80:80 -p 443:443 --name app3 nginx# Specific host IP

docker run -d -p 127.0.0.1:8080:80 --name app4 nginx# EXPOSE in Dockerfile (metadata only)# Dockerfile: EXPOSE 80# Still need -p to publish
```
![](./53.png)
![](./54.png)
![](./55.png)

## Part 5: Complete Real-World Example

Application Architecture:

Flask Web App (port 5000)

PostgreSQL Database (port 5432)

Redis Cache (port 6379)

All connected via custom network

Implementation:

# 1. Create network

docker network create myapp-network# 2. Start database with volume

docker run -d \

--name postgres \

--network myapp-network \

-e POSTGRES_PASSWORD=mysecretpassword \

-e POSTGRES_DB=mydatabase \

-v postgres-data:/var/lib/postgresql/data \

postgres:15# 3. Start Redis

docker run -d \

--name redis \

--network myapp-network \

-v redis-data:/data \

redis:7-alpine# 4. Start Flask app with all configurations

docker run -d \

--name flask-app \

--network myapp-network \

-p 5000:5000 \

-v $(pwd)/app:/app \

-v app-logs:/var/log/app \

-e DATABASE_URL="postgresql://postgres:mysecretpassword@postgres:5432/mydatabase" \

-e REDIS_URL="redis://redis:6379" \

-e DEBUG="false" \

-e LOG_LEVEL="INFO" \

--env-file .env.production \

flask-app:latest





Monitoring Commands:

# Check all components

docker ps# Monitor resources

docker stats postgres redis flask-app# Check logs

docker logs -f flask-app# Network connectivity test

docker exec flask-app ping -c 2 postgres

docker exec flask-app ping -c 2 redis# View network details

docker network inspect myapp-network



Quick Reference Cheatsheet

Volumes:

docker volume create <name>

docker run -v <volume>:/path

docker run -v /host/path:/container/path

docker volume lsdocker volume rm <name>

Environment Variables:

docker run -e VAR=value

docker run --env-file .env# In Dockerfile: ENV VAR=value

Monitoring:

docker stats

docker logs -f <container>

docker top <container>

docker inspect <container>

docker events

Networks:

docker network create <name>

docker run --network <name>

docker network connect <network> <container>

docker network inspect <network>

Practice Exercises

Exercise 1: Database Backup

# Create a PostgreSQL container with volume# Backup data using docker cp or volume backup techniques# Restore to new container

Exercise 2: Multi-Service Setup

# Create: web app + database + cache# Use custom network for communication# Set environment variables for configuration# Monitor all services

Exercise 3: Log Analysis

# Run a container that generates logs# Use docker logs with various filters# Redirect logs to a file on host using bind mount

Exercise 4: Network Isolation

# Create two separate networks# Put containers in different networks# Test connectivity between networks# Connect a container to both networks

Cleanup

# Stop and remove all containers

docker stop $(docker ps -aq)

docker rm $(docker ps -aq)# Remove all volumes

docker volume prune -f# Remove all networks (except defaults)

docker network prune -f# Remove unused images

docker image prune -f

Key Takeaways

Volumes persist data beyond container lifecycle

Environment variables configure containers dynamically

Monitoring commands help debug and optimize containers

Networks enable secure container communication

Always use named volumes for production data

Custom networks provide better isolation and DNS

Monitor resource usage to prevent issues

Use .env files for sensitive configuration

This experiment covers essential Docker features for building, configuring, and managing production-ready containerized applications. guve me readme code for this
