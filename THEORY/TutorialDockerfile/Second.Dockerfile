FROM ubuntu:22.04
RUN apt update && apt install -y default-jdk
WORKDIR /home/app
COPY HelloV2.java .
RUN javac HelloV2.java
CMD ["java", "HelloV2"]
