#!/bin/bash

# Muse 2 EEG Android + Flask Quick Start
# Automated setup for both Flask server and Android project

set -e

echo "================================"
echo "🎧 Muse 2 EEG Android Setup"
echo "================================"
echo ""

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Step 1: Flask Server Setup
echo -e "${BLUE}[1/5]${NC} Setting up Flask Server..."
cd "$(dirname "$0")"

# Create virtual environment if not exists
if [ ! -d ".venv" ]; then
    echo "Creating Python virtual environment..."
    python3 -m venv .venv
fi

# Activate virtual environment
source .venv/bin/activate

# Install dependencies
echo "Installing Python dependencies..."
pip install --upgrade pip > /dev/null 2>&1
pip install -r requirements.txt > /dev/null 2>&1
echo -e "${GREEN}✅ Flask dependencies installed${NC}"

# Step 2: Check Flask syntax
echo -e "${BLUE}[2/5]${NC} Validating Flask app..."
python -m py_compile app.py
echo -e "${GREEN}✅ Flask app.py is valid${NC}"

# Step 3: Create necessary directories
echo -e "${BLUE}[3/5]${NC} Creating data directories..."
mkdir -p muse_data
mkdir -p android/MuseEEGDashboard/app/libs
echo -e "${GREEN}✅ Directories created${NC}"

# Step 4: Check Android project
echo -e "${BLUE}[4/5]${NC} Checking Android project structure..."
if [ -d "android/MuseEEGDashboard" ]; then
    echo -e "${GREEN}✅ Android project structure found${NC}"
else
    echo -e "${YELLOW}⚠️ Android project not found. Create it manually in Android Studio${NC}"
fi

# Step 5: Display next steps
echo ""
echo -e "${BLUE}[5/5]${NC} Setup Summary"
echo "================================"
echo -e "${GREEN}✅ Flask server ready!${NC}"
echo ""
echo "📋 Next Steps:"
echo ""
echo "1️⃣  Start Flask Server:"
echo "   cd $(pwd)"
echo "   source .venv/bin/activate"
echo "   python app.py"
echo ""
echo "2️⃣  Setup Android Project:"
echo "   - Open android/MuseEEGDashboard in Android Studio"
echo "   - Download Muse SDK: https://sites.google.com/a/interaxon.ca/muse-developer-site/"
echo "   - Copy libmuse-android.jar to android/MuseEEGDashboard/app/libs/"
echo "   - Build and run APK"
echo ""
echo "3️⃣  Configure Server URL:"
echo "   - In app: Settings > Server URL"
echo "   - Enter: http://YOUR_SERVER_IP:9009"
echo ""
echo "📚 Documentation:"
echo "   - ANDROID_SETUP_GUIDE.md - Complete setup guide"
echo "   - android/README_ANDROID.md - Android app documentation"
echo ""
echo "================================"
echo "For more details, see ANDROID_SETUP_GUIDE.md"
