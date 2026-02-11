FROM ubuntu:22.04 AS builder
RUN apt-get update && apt-get install -y gcc
WORKDIR /build
COPY hello.c .
RUN gcc -static -o hello hello.c

FROM scratch
COPY --from=builder /build/hello .
CMD ["./hello"]