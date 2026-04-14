#!/bin/bash

# Docker deployment script untuk Muse 2 EEG Dashboard

set -e

echo "=================================="
echo "🐳 Muse 2 EEG Dashboard - Docker Deploy"
echo "=================================="
echo ""

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo -e "${RED}❌ Docker is not installed${NC}"
    echo "Install Docker from: https://docs.docker.com/get-docker/"
    exit 1
fi

echo -e "${BLUE}[1/5]${NC} Checking Docker..."
docker --version
echo ""

# Kill existing Flask processes
echo -e "${BLUE}[2/5]${NC} Cleaning up old processes..."
killall -9 python 2>/dev/null || true
sleep 2
echo -e "${GREEN}✅ Old processes cleaned${NC}"
echo ""

# Stop and remove existing container if any
echo -e "${BLUE}[3/5]${NC} Checking existing containers..."
if docker ps -a | grep -q muse2-dashboard; then
    echo "Stopping existing container..."
    docker stop muse2-dashboard 2>/dev/null || true
    echo "Removing existing container..."
    docker rm muse2-dashboard 2>/dev/null || true
fi
echo -e "${GREEN}✅ Container cleanup done${NC}"
echo ""

# Build Docker image
echo -e "${BLUE}[4/5]${NC} Building Docker image..."
echo "This may take 2-5 minutes..."
docker build -t muse-eeg-dashboard:latest . \
    -f Dockerfile \
    --progress=plain

echo -e "${GREEN}✅ Docker image built${NC}"
echo ""

# Run Docker container
echo -e "${BLUE}[5/5]${NC} Starting Docker container..."
echo "Running on port 9009..."
docker run -d \
    --name muse2-dashboard \
    -p 9009:9009 \
    -v "$(pwd)/muse_data:/app/muse_data" \
    -v "$(pwd)/apk_downloads:/app/apk_downloads" \
    -v "$(pwd)/templates:/app/templates" \
    -e FLASK_APP=app.py \
    -e FLASK_ENV=production \
    -e PYTHONUNBUFFERED=1 \
    --restart unless-stopped \
    muse-eeg-dashboard:latest

echo ""
sleep 3

if docker ps | grep -q muse2-dashboard; then
    echo -e "${GREEN}✅ Container is running!${NC}"
else
    echo -e "${RED}❌ Container failed to start${NC}"
    echo ""
    echo "Check logs:"
    docker logs muse2-dashboard
    exit 1
fi

echo ""
echo "=================================="
echo -e "${GREEN}✅ Deployment Complete!${NC}"
echo "=================================="
echo ""
echo "🌐 Access dashboard:"
echo "   http://localhost:9009"
echo ""
echo "📱 Download APK:"
echo "   http://localhost:9009/download"
echo ""
echo "📊 Android Dashboard:"
echo "   http://localhost:9009/dashboard-android"
echo ""
echo "🛠️  Useful commands:"
echo "   docker ps                              # List containers"
echo "   docker logs muse2-dashboard            # View logs"
echo "   docker logs -f muse2-dashboard         # Follow logs"
echo "   docker stop muse2-dashboard            # Stop container"
echo "   docker start muse2-dashboard           # Start container"
echo "   docker exec muse2-dashboard bash       # Enter container"
echo ""
echo "=================================="
