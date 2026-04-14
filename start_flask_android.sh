#!/bin/bash

# Quick start Flask server with Android support

cd "$(dirname "$0")"

echo "🚀 Starting Muse 2 EEG Flask Server..."
echo "📱 With Android streaming support"
echo ""

# Activate virtual environment
if [ ! -d ".venv" ]; then
    echo "❌ Virtual environment not found!"
    echo "   Run: ./android_setup.sh"
    exit 1
fi

source .venv/bin/activate

# Check if requirements are installed
echo "Checking dependencies..."
python -c "import flask_socketio" 2>/dev/null || {
    echo "Installing missing dependencies..."
    pip install -r requirements.txt
}

echo ""
echo "✅ Starting server..."
echo ""
echo "🌐 Dashboard available at:"
echo "   http://localhost:9009"
echo ""
echo "📱 Android Dashboard at:"
echo "   http://localhost:9009/dashboard-android"
echo ""
echo "📊 API Endpoints:"
echo "   POST /api/android/register - Register Android device"
echo "   GET  /api/android/config - Get configuration"
echo "   POST /api/eeg - Stream EEG data"
echo ""
echo "Press Ctrl+C to stop server"
echo ""

python app.py
