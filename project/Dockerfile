# Multi-stage Dockerfile for Vite React frontend

# 1) Build stage
FROM node:18-alpine AS builder
WORKDIR /app

# Accept build argument for API URL
ARG VITE_API_URL
ENV VITE_API_URL=$VITE_API_URL

# Copy package files
COPY package*.json ./
RUN npm install

# Copy source files
COPY . .

# Build the application (Vite will use VITE_API_URL from ENV)
RUN npm run build

# 2) Serve stage using nginx
FROM nginx:stable-alpine

# Copy built files
COPY --from=builder /app/dist /usr/share/nginx/html

# Remove default nginx config
RUN rm /etc/nginx/conf.d/default.conf

# Create nginx config that listens on $PORT
RUN echo 'server { \n\
    listen $PORT; \n\
    server_name _; \n\
    root /usr/share/nginx/html; \n\
    index index.html; \n\
    location / { \n\
        try_files $uri $uri/ /index.html; \n\
    } \n\
}' > /etc/nginx/conf.d/default.conf.template

# Use envsubst to replace $PORT at runtime and start nginx
CMD /bin/sh -c "envsubst '\$PORT' < /etc/nginx/conf.d/default.conf.template > /etc/nginx/conf.d/default.conf && nginx -g 'daemon off;'"
