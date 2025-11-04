#!/bin/bash

# Color codes for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Cine-Tune List - Docker Quick Start${NC}\n"

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo -e "${RED}❌ Docker is not installed!${NC}"
    echo -e "${YELLOW}Please install Docker Desktop from: https://www.docker.com/products/docker-desktop${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Docker detected${NC}"

# Check if Docker daemon is running
if ! docker ps &> /dev/null; then
    echo -e "${RED}❌ Docker daemon is not running!${NC}"
    echo -e "${YELLOW}Please start Docker Desktop and try again${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Docker daemon is running${NC}\n"

# Get the directory of this script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo -e "${BLUE}Building and starting services...${NC}\n"

# Use docker compose (new syntax) or docker-compose (old syntax)
if command -v docker-compose &> /dev/null; then
    DOCKER_COMPOSE="docker-compose"
elif docker compose version &> /dev/null; then
    DOCKER_COMPOSE="docker compose"
else
    echo -e "${RED}❌ Docker Compose not found!${NC}"
    exit 1
fi

echo -e "${YELLOW}Using: $DOCKER_COMPOSE${NC}\n"

# Start services
$DOCKER_COMPOSE up --build

echo -e "\n${GREEN}🎉 Services started!${NC}"
echo -e "${BLUE}Frontend: http://localhost:3000${NC}"
echo -e "${BLUE}Backend: http://localhost:5001${NC}"
echo -e "${BLUE}MongoDB: mongodb://root:rootpassword@localhost:27017${NC}"
