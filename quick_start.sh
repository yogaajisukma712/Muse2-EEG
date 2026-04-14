#!/bin/bash
# Quick Start Script untuk Muse 2 Dashboard
# Gunakan: bash quick_start.sh

set -e

echo "🚀 Muse 2 Dashboard - Quick Start"
echo "=================================="
echo ""

# Check Docker
if ! command -v docker &> /dev/null; then
    echo "❌ Docker tidak terinstall!"
    echo "   Install dari: https://docs.docker.com/get-docker/"
    exit 1
fi

echo "✅ Docker ditemukan: $(docker --version)"
echo ""

# Check Docker daemon
if ! docker ps &> /dev/null; then
    echo "❌ Docker daemon tidak berjalan!"
    echo "   Jalankan Docker Desktop atau Docker Engine"
    exit 1
fi

echo "✅ Docker daemon berjalan"
echo ""

# Create muse_data folder
mkdir -p muse_data
echo "✅ Folder 'muse_data' sudah siap"
echo ""

# Check if image exists
if docker images | grep -q muse2-dashboard; then
    echo "✅ Docker image 'muse2-dashboard' sudah ada"
else
    echo "🔨 Membangun Docker image..."
    docker build -t muse2-dashboard .
    echo "✅ Docker image berhasil dibuat"
fi

echo ""
echo "=================================="
echo "🎯 READY TO START!"
echo "=================================="
echo ""
echo "📊 Opsi 1: Jalankan dengan Docker Compose"
echo "   Command: docker-compose up"
echo ""
echo "🐳 Opsi 2: Jalankan dengan Docker Manual"
echo "   Command: docker run -p 9009:9009 -v \$(pwd)/muse_data:/app/muse_data --rm muse2-dashboard"
echo ""
echo "🌐 Dashboard akan tersedia di: http://localhost:9009"
echo ""
echo "📝 Tips:"
echo "   - Tekan Ctrl+C untuk stop container"
echo "   - Data disimpan di folder muse_data/"
echo "   - Lihat DOCKER_SETUP.md untuk detail lebih lanjut"
echo ""
