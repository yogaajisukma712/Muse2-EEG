#!/bin/bash

echo "╔════════════════════════════════════════════════════════════════╗"
echo "║   🔍 MUSE 2 DASHBOARD + CLOUDFLARED - DIAGNOSTIC TEST         ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""

# Test 1: Dashboard status
echo "1️⃣  DASHBOARD STATUS:"
if curl -s http://localhost:9009 > /dev/null 2>&1; then
    echo "   ✅ Dashboard running on port 9009"
else
    echo "   ❌ Dashboard NOT responding on port 9009"
    echo "   Fix: Run 'docker compose up -d' from project folder"
fi

# Test 2: Cloudflared status
echo ""
echo "2️⃣  CLOUDFLARED STATUS:"
if docker ps | grep -q cloudflared; then
    echo "   ✅ Cloudflared container running"
else
    echo "   ❌ Cloudflared container NOT running"
    echo "   Fix: docker run -d cloudflare/cloudflared:latest tunnel ..."
fi

# Test 3: Cloudflared version
echo ""
echo "3️⃣  CLOUDFLARED VERSION:"
cloudflared --version 2>/dev/null || echo "   ⚠️  Cloudflared CLI not found"

# Test 4: Tunnel status
echo ""
echo "4️⃣  CLOUDFLARED TUNNEL:"
if ps aux | grep -q "cloudflared.*tunnel" | grep -v grep; then
    echo "   ✅ Tunnel process running"
else
    echo "   ⚠️  No tunnel process found"
fi

# Test 5: Dashboard endpoint test
echo ""
echo "5️⃣  DASHBOARD API TEST:"
RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:9009/api/data)
if [ "$RESPONSE" = "200" ]; then
    echo "   ✅ API responding (HTTP 200)"
else
    echo "   ⚠️  API response: HTTP $RESPONSE"
fi

# Test 6: Tunnel endpoints
echo ""
echo "6️⃣  TUNNEL ROUTES:"
cloudflared tunnel info muse-eeg-dashboard 2>/dev/null | grep -E "URL|status" || echo "   ⚠️  Tunnel not configured (run setup)"

echo ""
echo "════════════════════════════════════════════════════════════════"
echo ""

# Show next steps
if curl -s http://localhost:9009 > /dev/null 2>&1; then
    echo "✅ Dashboard is reachable on http://localhost:9009"
    echo ""
    echo "🔗 To access via Cloudflared tunnel:"
    echo "   1. Run: cloudflared tunnel run muse-eeg-dashboard"
    echo "      (or check CLOUDFLARED_SETUP.md for config)"
    echo ""
    echo "   2. If already running, check:"
    echo "      cloudflared tunnel info muse-eeg-dashboard"
else
    echo "❌ Dashboard not responsive"
    echo ""
    echo "Fix:"
    cd "/home/ubuntu/Documents/Penelitian/EEG Muse"
    echo "   docker compose up -d"
    echo "   sleep 2"
    echo "   curl http://localhost:9009"
fi
echo ""
