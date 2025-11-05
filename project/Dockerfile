# Build stage - use full Node image for better compatibility
FROM node:18 AS builder

WORKDIR /app

# Copy package files first (for better layer caching)
COPY package.json package-lock.json ./

# Clean install dependencies
RUN rm -rf node_modules && npm install --legacy-peer-deps

# Copy all source files (node_modules excluded via .dockerignore)
COPY . .

# Set build-time environment variable
ARG VITE_API_URL=https://project123-production-13d6.up.railway.app
ENV VITE_API_URL=$VITE_API_URL

# Build the application
RUN npm run build

# Production stage - use slim image to reduce size
FROM node:18-slim

WORKDIR /app

# Copy built files from builder
COPY --from=builder /app/dist ./dist
COPY static-server.js ./

# Expose port (Railway will override with PORT env var)
EXPOSE 3000

# Start the Node.js static server
CMD ["node", "static-server.js"]
