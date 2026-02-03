FROM ubuntu:22.04
RUN apt update && apt install -y default-jdk
WORKDIR /home/app
COPY Hello.java .
RUN javac Hello.java
CMD ["java","Hello"]