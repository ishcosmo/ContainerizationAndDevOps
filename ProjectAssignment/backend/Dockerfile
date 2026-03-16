# Stage 1: Build dependencies
FROM node:20-alpine AS build_env
WORKDIR /app
COPY package*.json ./
RUN npm install

# Stage 2: Final runtime
FROM node:20-alpine
WORKDIR /app
# Security: Use a non-root user
RUN addgroup -S devgroup && adduser -S devuser -G devgroup
COPY --from=build_env /app/node_modules ./node_modules
COPY . .
RUN chown -R devuser:devgroup /app
USER devuser
EXPOSE 3000
CMD ["node", "server.js"]