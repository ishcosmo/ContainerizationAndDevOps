## **Experiment 2:** Deploying NGINX using different base images and comparing image layers

### ***Objective:***
1. Deploy NGINX using
- Official nginx image
- Ubuntu-based image
- Alpine-based image
2. Understand Docker images layers and size and differences
3. Compare performance, security and use-cases of each approach

### Implementation
### **Part 1: Deploying Nginx using official image**
1. Pull Image using the `docker pull nginx:latest`
- This pulls the latest Nginx image from the Docker hub

![](./pull1.png)

2. Running the container with port mapping using the command `docker run -d --name nginx-official -p 8080:80 nginx`

- It actually starts Nginx in the background mapped to port 8080

![](./run1.png)

3. Verifying using the `curl http://localhost:8080` command
 - NGINX welcome page is being displayed
 ![](./verify1.png)
 ![](./verify2.png)

4.  Using `docker images nginx` command the official NGINX image is displayed:

![](./images.png)
### **Part 2: Custom NGINX Using Ubuntu base image..**
1. Creating dockerfile in the current working directory 
```Dockerfile
FROM ubuntu:22.04

RUN apt-get update && \
    apt-get install -y nginx && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
```
2. Building image using `docker build -t nginx-ubuntu .`

![](./build1.png)

3. Running the container using `docker run -d --name nginx-ubuntu -p 8081:80 nginx-ubuntu` command

![](./run11.png)

- Assumption: index.html is stored in ***./nginx-html***

4. Gathering observations for this variant by the `docker images nginx-ubuntu` command
![](./observe1.png)

### **Part 3: Custom NGINX Using Alpine base image**
1. Creating dockerfile in the current working directory 
```Dockerfile
FROM alpine:latest
RUN apk add --no-cache nginx
RUN echo "server { \
    listen 80 default_server; \
    listen [::]:80 default_server; \
    root /var/www/html; \
    index index.html index.htm; \
    server_name _; \
    location / { \
        try_files \$uri \$uri/ =404; \
    } \
}" > /etc/nginx/http.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"] 
***NOTE:*** *The default config of NGINX on Alpine is set to display a 404 page.*

Build and run the nginx-alpine image (running on port 8082):
```Bash
docker build -t nginx-alpine -f ./alpine.Dockerfile .
docker run -d -v ./nginx-html/:/var/www/html -p 8082:80 --name nginx-alpine-test nginx-alpine:latest
```
![](./nginx-alpine-build.png)

The built Alpine NGINX image:

![](./nginx-alpine-image.png)
![](./nginx-alpine-im.png)

### **Part 4: Image Size and Layer Comparison**

Compare Sizes
```Bash
docker images | grep nginx
```
![](./im-comp.png)

| Image | Size |
| :-- | :-- |
| nginx | 240MB |
| nginx-ubuntu | 199MB |
| nginx-alpine | 16.1MB |

Comapare Layers
```Bash
docker history nginx
```
![](./nginx-history.png)

```Bash
docker history nginx-ubuntu
```
![](./nginx-ubuntu-history.png)

```Bash
docker history nginx-alpine
```
![](./nginx-alpine-history.png)

### Observations
 - Size of official NGINX image is the largest (240MB).
 - nginx-alpine is the smallest (16.1MB).
 - Official nginx image has the most layers.
 - nginx-alpine has the least layers.

### **Part 5: Functional Tasks Using NGINX**

Serving custom HTML page

./nginx-html/index.html
```HTML
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Student Information</title>
    <style>
        body {
            display: flex;
            justify-content: center;
            padding-top: 50px;
        }
        th, td {
            border: 1px solid #dddddd;
            text-align: left;
            padding: 12px;
        }
    </style>
</head>
<body>

<table>
    <thead>
        <tr>
            <th>Field</th>
            <th>Details</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td><strong>Name</strong></td>
            <td>Ishita</td>
        </tr>
        <tr>
            <td><strong>SAP ID</strong></td>
            <td>500119435</td>
        </tr>
    </tbody>
</table>

</body>
</html>
```

Running on official NGINX image:
```Bash
docker run -d \
  -p 8080:80 \
  -v ./nginx-html:/usr/share/nginx/html \
  nginx
```

![](./HTMLserved.png)