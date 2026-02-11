FROM ubuntu:22.04
RUN apt-get update && apt-get install -y gcc
WORKDIR /app
COPY hello.c .
RUN gcc -o hello hello.c
CMD ["./hello"]
