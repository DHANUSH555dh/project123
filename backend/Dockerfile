# Production Dockerfile for backend
FROM node:18-alpine

WORKDIR /app

# Install dependencies
COPY package*.json ./
RUN npm install --production

# Copy source code
COPY . .

ENV NODE_ENV=production
EXPOSE 5001

# Wait for MongoDB to be ready, then start server
CMD ["node", "server.js"]
