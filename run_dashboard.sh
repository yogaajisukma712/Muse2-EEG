#!/bin/bash
# MUSE 2 DASHBOARD - INSTALLER & LAUNCHER
# Jalankan script ini untuk setup otomatis

set -e

clear

cat << 'EOF'

╔══════════════════════════════════════════════════════════════════╗
║                                                                  ║
║         🧠 MUSE 2 EEG DASHBOARD - AUTOMATIC SETUP              ║
║                                                                  ║
║              Dashboard akan berjalan di PORT 9009               ║
║                                                                  ║
╚══════════════════════════════════════════════════════════════════╝

EOF

echo "⏳ Checking requirements..."
echo ""

# Check Docker
if command -v docker &> /dev/null; then
    DOCKER_VERSION=$(docker --version)
    echo "✅ Docker: $DOCKER_VERSION"
else
    echo "❌ Docker not found! Install from: https://docs.docker.com/get-docker/"
    exit 1
fi

# Check if Docker daemon is running
if ! docker ps &> /dev/null; then
    echo "❌ Docker is not running!"
    echo "   Start Docker Desktop or Docker Engine"
    exit 1
fi

echo "✅ Docker daemon running"
echo ""

# Check if muse2-dashboard image exists
if docker images | grep -q "muse2-dashboard"; then
    echo "✅ Docker image found: muse2-dashboard"
else
    echo "⚠️  Docker image not found. Will build on first run."
fi

echo ""
echo "═══════════════════════════════════════════════════════════════"
echo ""

# Create data directory
echo "📁 Setting up folders..."
mkdir -p muse_data
echo "✅ Created 'muse_data' folder"
echo ""

# Show options
echo "═══════════════════════════════════════════════════════════════"
echo ""
echo "🎯 What would you like to do?"
echo ""
echo "1) Run Dashboard with Docker Compose"
echo "2) Run Dashboard with Docker (manual)"
echo "3) Run Dashboard with Local Python"
echo "4) Just show commands (don't run)"
echo ""
read -p "Choose option (1-4): " choice

echo ""
echo "═══════════════════════════════════════════════════════════════"
echo ""

case $choice in
    1)
        echo "🚀 Starting Dashboard with Docker Compose..."
        echo "📌 Dashboard will run on http://localhost:9009"
        echo "📌 Press Ctrl+C to stop"
        echo ""
        docker compose up || docker-compose up
        ;;
    2)
        echo "🚀 Starting Dashboard with Docker..."
        echo "📌 Dashboard will run on http://localhost:9009"
        echo "📌 Press Ctrl+C to stop"
        echo ""
        docker run -p 9009:9009 \
            -v "$(pwd)/muse_data:/app/muse_data" \
            --rm \
            muse2-dashboard
        ;;
    3)
        echo "🚀 Starting Dashboard with Local Python..."
        echo "📌 Dashboard will run on http://localhost:9009"
        echo "📌 Press Ctrl+C to stop"
        echo ""
        pip install -r requirements-docker.txt 2>/dev/null || pip3 install -r requirements-docker.txt
        python3 app.py
        ;;
    4)
        echo "📋 COMMAND OPTIONS:"
        echo ""
        echo "1️⃣  Docker Compose (Recommended):"
        echo "   docker compose up"
        echo "   or"
        echo "   docker-compose up"
        echo ""
        echo "2️⃣  Docker Manual:"
        echo '   docker run -p 9009:9009 -v $(pwd)/muse_data:/app/muse_data muse2-dashboard'
        echo ""
        echo "3️⃣  Local Python:"
        echo "   pip install -r requirements-docker.txt"
        echo "   python3 app.py"
        echo ""
        echo "📊 Then open http://localhost:9009"
        ;;
    *)
        echo "❌ Invalid option"
        exit 1
        ;;
esac

echo ""
echo "═══════════════════════════════════════════════════════════════"
echo "✅ Done!"
echo ""
