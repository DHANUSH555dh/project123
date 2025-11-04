# Multi-stage Dockerfile for Vite React frontend

# 1) Build stage
FROM node:18-alpine AS builder
WORKDIR /app

COPY package*.json ./
RUN npm install

# Copy source and build
COPY . .

# Build with API URL from build args (for Docker environment)
ARG VITE_API_URL=http://backend:5001
ENV VITE_API_URL=${VITE_API_URL}

RUN npm run build

# 2) Serve stage using nginx
FROM nginx:stable-alpine

# Copy nginx config for React SPA routing
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy built React app from builder
COPY --from=builder /app/dist /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
