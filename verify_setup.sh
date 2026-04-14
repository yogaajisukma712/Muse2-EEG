#!/bin/bash

# 🎧 Muse 2 Android + Flask Integration - Quick Verification Script
# Checks if all components are properly set up

set -e

echo "╔════════════════════════════════════════════════════════════════╗"
echo "║   🎧 Muse 2 Android + Flask Integration Verification          ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""

cd "$(dirname "$0")"
CHECKMARK="✅"
ERROR_MARK="❌"
WARNING_MARK="⚠️"

# Color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Initialize counters
total=0
passed=0
failed=0

check_file() {
    local file=$1
    local desc=$2
    total=$((total + 1))
    
    if [ -f "$file" ]; then
        echo -e "${GREEN}${CHECKMARK}${NC} $desc"
        passed=$((passed + 1))
    else
        echo -e "${RED}${ERROR_MARK}${NC} $desc - NOT FOUND"
        failed=$((failed + 1))
    fi
}

check_dir() {
    local dir=$1
    local desc=$2
    total=$((total + 1))
    
    if [ -d "$dir" ]; then
        echo -e "${GREEN}${CHECKMARK}${NC} $desc"
        passed=$((passed + 1))
    else
        echo -e "${RED}${ERROR_MARK}${NC} $desc - NOT FOUND"
        failed=$((failed + 1))
    fi
}

check_command() {
    local cmd=$1
    local desc=$2
    total=$((total + 1))
    
    if command -v $cmd &> /dev/null; then
        echo -e "${GREEN}${CHECKMARK}${NC} $desc"
        passed=$((passed + 1))
    else
        echo -e "${YELLOW}${WARNING_MARK}${NC} $desc - NOT INSTALLED"
    fi
}

# 1. Python Environment
echo -e "${BLUE}📦 Python Environment${NC}"
check_dir ".venv" "Virtual environment"
check_file "requirements.txt" "Requirements file"

# 2. Flask Files
echo ""
echo -e "${BLUE}🐍 Flask Backend${NC}"
check_file "app.py" "Flask application"
check_file "templates/index.html" "Main dashboard template"
check_file "templates/dashboard_android.html" "Android dashboard template"

# 3. Android Project
echo ""
echo -e "${BLUE}📱 Android Project${NC}"
check_dir "android/MuseEEGDashboard" "Android project root"
check_file "android/MuseEEGDashboard/build.gradle" "Root build.gradle"
check_file "android/MuseEEGDashboard/app/build.gradle" "App build.gradle"
check_file "android/MuseEEGDashboard/app/src/main/AndroidManifest.xml" "AndroidManifest.xml"
check_file "android/MuseEEGDashboard/app/src/main/java/com/example/museeegdashboard/MainActivity.kt" "MainActivity.kt"
check_file "android/MuseEEGDashboard/app/src/main/java/com/example/museeegdashboard/DashboardActivity.kt" "DashboardActivity.kt"
check_file "android/MuseEEGDashboard/app/src/main/java/com/example/museeegdashboard/service/MuseDataService.kt" "MuseDataService.kt"
check_file "android/MuseEEGDashboard/app/src/main/res/layout/activity_main.xml" "activity_main.xml"
check_file "android/MuseEEGDashboard/app/src/main/res/layout/activity_dashboard.xml" "activity_dashboard.xml"

# 4. Documentation
echo ""
echo -e "${BLUE}📚 Documentation${NC}"
check_file "ANDROID_SETUP_GUIDE.md" "Android setup guide"
check_file "ANDROID_INTEGRATION_SUMMARY.md" "Integration summary"
check_file "android/README_ANDROID.md" "Android README"

# 5. Setup Scripts
echo ""
echo -e "${BLUE}🚀 Setup Scripts${NC}"
check_file "android_setup.sh" "Automated setup script"
check_file "start_flask_android.sh" "Flask launcher script"

# 6. System Tools
echo ""
echo -e "${BLUE}🛠️  System Tools${NC}"
check_command "python3" "Python 3"
check_command "npm" "Node.js/npm"
check_command "git" "Git"
check_command "adb" "Android Debug Bridge (ADB)"

# Results
echo ""
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║                     Verification Results                       ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""
echo -e "${GREEN}Passed:${NC} $passed/$total"
echo -e "${RED}Failed:${NC} $failed/$total"
echo ""

if [ $failed -eq 0 ]; then
    echo -e "${GREEN}✅ All checks passed! System is ready.${NC}"
    echo ""
    echo "🚀 Next steps:"
    echo "   1. Download Muse SDK: https://sites.google.com/a/interaxon.ca/muse-developer-site/"
    echo "   2. Copy libmuse-android.jar to: android/MuseEEGDashboard/app/libs/"
    echo "   3. Open Android project in Android Studio"
    echo "   4. Run: python app.py"
    echo "   5. Build and run Android APK on device"
    exit 0
else
    echo -e "${RED}❌ Some checks failed. Please review the errors above.${NC}"
    echo ""
    echo "Common issues:"
    echo "   - Missing virtual environment: Run 'python3 -m venv .venv'"
    echo "   - Missing Android files: Run './android_setup.sh'"
    echo "   - Missing templates: Check templates/ directory"
    exit 1
fi
