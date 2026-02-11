
FROM eclipse-temurin:17-jdk AS builder
WORKDIR /app
COPY hello.java .
RUN javac hello.java


FROM eclipse-temurin:17-jre-alpine
WORKDIR /app

COPY --from=builder /app/hello.class .
CMD ["java", "hello"]