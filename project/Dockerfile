# Multi-stage Dockerfile for Vite React frontend

# 1) Build stage
FROM node:18-alpine AS builder
WORKDIR /app

# Accept build argument for API URL
ARG VITE_API_URL
ENV VITE_API_URL=$VITE_API_URL

COPY package*.json ./
RUN npm install

# Copy source and build
COPY . .
RUN npm run build

# 2) Serve stage using nginx
FROM nginx:stable-alpine

# Copy built files
COPY --from=builder /app/dist /usr/share/nginx/html

# Copy custom nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80 for nginx
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
