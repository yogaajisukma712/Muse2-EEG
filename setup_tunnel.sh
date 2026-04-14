#!/bin/bash

set -e

echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║   🚀 SETUP CLOUDFLARED TUNNEL UNTUK MUSE 2 DASHBOARD        ║"
echo "╚═══════════════════════════════════════════════════════════════╝"
echo ""

# Stop existing cloudflared
echo "⏹️  Stopping old Cloudflared container..."
docker stop cloudflared 2>/dev/null || true
docker rm cloudflared 2>/dev/null || true

echo "✅ Done"
echo ""

# Option 1: Test dengan temporary URL (QUICK)
echo "═══════════════════════════════════════════════════════════════"
echo "🎯 OPTION 1: QUICK TEST (Temporary URL - valid 8 hours)"
echo "═══════════════════════════════════════════════════════════════"
echo ""
echo "Run this command in a new terminal:"
echo ""
echo "  cloudflared tunnel --url http://localhost:9009"
echo ""
echo "Output akan berisi URL seperti:"
echo "  https://xxxxx.trycloudflare.com"
echo ""
echo "Gunakan URL itu untuk akses dashboard!"
echo ""

# Option 2: Setup permanent tunnel
echo "═══════════════════════════════════════════════════════════════"
echo "🎯 OPTION 2: PERMANENT TUNNEL"
echo "═══════════════════════════════════════════════════════════════"
echo ""

# Check if already authenticated
if [ ! -d ~/.cloudflared ]; then
    echo "⚠️  Belum login ke Cloudflare"
    echo ""
    echo "Run: cloudflared login"
    echo "Kemudian pilih domain dari list, lalu comeback ke sini"
    echo ""
    exit 1
fi

# Create tunnel directory if not exists
mkdir -p ~/.cloudflared

echo "✅ Cloudflared authenticated"
echo ""

# Check if tunnel exists
if cloudflared tunnel list | grep -q "muse-eeg-dashboard"; then
    echo "✅ Tunnel 'muse-eeg-dashboard' exists"
    TUNNEL_NAME="muse-eeg-dashboard"
else
    echo "📝 Creating tunnel 'muse-eeg-dashboard'..."
    TUNNEL_NAME="muse-eeg-dashboard"
    cloudflared tunnel create $TUNNEL_NAME
    echo "✅ Tunnel created"
fi

echo ""

# Get tunnel ID
TUNNEL_ID=$(cloudflared tunnel list | grep $TUNNEL_NAME | awk '{print $1}')

echo "Tunnel ID: $TUNNEL_ID"
echo ""

# Create/update config file
CONFIG_FILE="$HOME/.cloudflared/config.yml"

echo "📝 Creating config file: $CONFIG_FILE"

cat > "$CONFIG_FILE" << 'EOF'
tunnel: muse-eeg-dashboard
credentials-file: /root/.cloudflared/[TUNNEL-ID].json

ingress:
  - service: http://localhost:9009

loglevel: info
EOF

# Replace tunnel ID
sed -i "s/\[TUNNEL-ID\]/$TUNNEL_ID/g" "$CONFIG_FILE"

echo "✅ Config created"
echo ""

# Show config
echo "📄 Config file content:"
echo "──────────────────────────────────────────────────────────"
cat "$CONFIG_FILE"
echo "──────────────────────────────────────────────────────────"
echo ""

# Start tunnel
echo "🚀 Starting tunnel..."
echo ""
echo "Run this in a new terminal:"
echo ""
echo "  cloudflared tunnel run muse-eeg-dashboard"
echo ""
echo "Then check tunnel URL with:"
echo ""
echo "  cloudflared tunnel info muse-eeg-dashboard"
echo ""

echo "═══════════════════════════════════════════════════════════════"
echo ""
echo "✅ Setup complete!"
echo ""
echo "Next: Run 'cloudflared tunnel run muse-eeg-dashboard'"
