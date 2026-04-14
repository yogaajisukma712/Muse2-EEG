# 🎧 Muse 2 Android + Flask Integration - Implementation Summary

**Status**: ✅ COMPLETE  
**Date**: April 13, 2024  
**Version**: 1.0.0

---

## ✅ Completed Tasks

### 1. **Flask Backend Updates**
- ✅ Added Flask-SocketIO support for real-time WebSocket streaming
- ✅ Implemented Android-specific API endpoints
- ✅ Created WebSocket namespace `/dashboard` for client communication
- ✅ Added multi-threading support for concurrent connections
- ✅ Implemented data locking for thread-safe operations

**Files Modified:**
- [app.py](app.py) - Added WebSocket handlers and Android API endpoints
- [requirements.txt](requirements.txt) - Added flask-socketio, python-socketio, python-engineio

### 2. **Android Application**
- ✅ Created complete Android project structure (`MuseEEGDashboard`)
- ✅ Implemented Muse 2 Bluetooth connection service
- ✅ Created HTTP client for data streaming to Flask
- ✅ Built WebView for dashboard display
- ✅ Added proper permission handling (Bluetooth, Internet, Location)

**Android Files Created:**
```
android/MuseEEGDashboard/
├── app/build.gradle - Project dependencies
├── app/src/main/
│   ├── AndroidManifest.xml - Permissions & manifest
│   ├── java/com/example/museeegdashboard/
│   │   ├── MainActivity.kt - Setup & connection management
│   │   ├── DashboardActivity.kt - WebView for dashboard
│   │   └── service/MuseDataService.kt - Muse 2 connection & streaming
│   └── res/
│       ├── layout/
│       │   ├── activity_main.xml - Main UI
│       │   └── activity_dashboard.xml - Dashboard UI
│       └── values/
│           ├── strings.xml - String resources
│           └── themes.xml - App theme
└── settings.gradle - Project settings
```

### 3. **Frontend Dashboard**
- ✅ Created Android-optimized real-time dashboard
- ✅ Implemented WebSocket client for live data updates
- ✅ Added real-time channel value display
- ✅ Implemented automatic statistics calculation
- ✅ Added connection status indicators

**File Created:**
- [templates/dashboard_android.html](templates/dashboard_android.html) - Real-time dashboard

### 4. **Documentation & Setup Scripts**
- ✅ Created comprehensive setup guide
- ✅ Created Android-specific README
- ✅ Created automated setup script
- ✅ Created Flask server startup script

**Documentation Files:**
- [ANDROID_SETUP_GUIDE.md](ANDROID_SETUP_GUIDE.md) - Complete integration guide
- [android/README_ANDROID.md](android/README_ANDROID.md) - Android app documentation
- [android_setup.sh](android_setup.sh) - Automated setup script
- [start_flask_android.sh](start_flask_android.sh) - Flask server launcher

---

## 🔌 Architecture Overview

```
┌─────────────────────────────────────────────────────────────┐
│                    Muse 2 Device                            │
│              (Bluetooth Headset)                            │
└──────────────────────────┬──────────────────────────────────┘
                           │ Bluetooth BLE
                           ▼
┌─────────────────────────────────────────────────────────────┐
│              Android Mobile Device                          │
│         (MuseEEGDashboard App)                             │
│  ┌──────────────────────────────────────────────────────┐  │
│  │ MainActivity (Setup & Config)                       │  │
│  │ MuseDataService (Bluetooth Connection)            │  │
│  │ - Listen to Muse 2                                │  │
│  │ - Capture EEG packets                             │  │
│  │ - Format data (JSON)                              │  │
│  └──────────────────────────────────────────────────────┘  │
│                        │                                     │
│                   HTTP POST                                  │
│            (JSON, 100ms intervals)                           │
└──────────────────┬───────────────────────────────────────────┘
                   │
                   ▼
┌─────────────────────────────────────────────────────────────┐
│              Flask Python Server                            │
│              (Port 9009)                                   │
│  ┌──────────────────────────────────────────────────────┐  │
│  │ /api/android/register - Device registration        │  │
│  │ /api/android/config - Device configuration         │  │
│  │ /api/eeg - Receive EEG data                        │  │
│  │ /api/android/status - Status updates              │  │
│  └──────────────────────────────────────────────────────┘  │
│  ┌──────────────────────────────────────────────────────┐  │
│  │ WebSocket /dashboard namespace                     │  │
│  │ - Broadcast real-time EEG data                     │  │
│  │ - Send status updates                              │  │
│  │ - Handle multiple concurrent clients               │  │
│  └──────────────────────────────────────────────────────┘  │
└──────────────────┬────────────────────────┬─────────────────┘
                   │                        │
        WebSocket Broadcast          HTTP GET/POST
                   │                        │
        ┌──────────▼─────────┐     ┌───────▼────────────┐
        │  Web Browser       │     │  Android WebView   │
        │  (Dashboard)       │     │  (Dashboard)       │
        │  Real-time Charts  │     │  Real-time Display │
        └────────────────────┘     └────────────────────┘
```

---

## 📡 Data Flow

### Streaming Cycle
```
1. Android detects Muse 2 via Bluetooth
   ↓
2. MuseDataService connects to Muse 2
   ↓
3. EEG data packets received (256 Hz sampling)
   ↓
4. Data formatted to JSON:
   {
     "timestamp": 1681234567890,
     "eeg_data": [10.5, 20.3, 15.8, 25.1, 5.2],
     "device_name": "Muse-Android",
     "channels": ["AF7", "AF8", "TP9", "TP10", "AUX"]
   }
   ↓
5. HTTP POST to Flask: /api/eeg
   ↓
6. Flask receives and broadcasts via WebSocket
   ↓
7. Web dashboard receives real-time update
   ↓
8. Display updates (charts, values, statistics)
```

### API Endpoints

| Endpoint | Method | Source | Purpose |
|----------|--------|--------|---------|
| `/api/android/register` | POST | Android | Register device |
| `/api/android/config` | GET | Android | Get server config |
| `/api/eeg` | POST | Android | Stream EEG data |
| `/api/android/status` | POST | Android | Send status (battery, signal) |
| `/` | GET | Browser | Main dashboard |
| `/dashboard-android` | GET | Android WebView | Android-optimized dashboard |
| `/api/data` | GET | Browser | Get stored EEG data |
| `/api/statistics` | GET | Browser | Get data statistics |

### WebSocket Events

**Namespace**: `/dashboard`

**Client → Server:**
- `connect` - Client connects
- `disconnect` - Client disconnects
- `eeg_data` - Send EEG data (Android)
- `status_update` - Send status update (Android)

**Server → Client:**
- `eeg_update` - Broadcast EEG data
- `status` - Broadcast status update
- `error` - Send error messages

---

## 🚀 Quick Start Guide

### Step 1: Setup Python Environment
```bash
cd /home/ubuntu/Documents/Penelitian/EEG\ Muse
source .venv/bin/activate
pip install -r requirements.txt
```

### Step 2: Verify Flask
```bash
python -m py_compile app.py
echo "✅ Flask app ready"
```

### Step 3: Start Flask Server
```bash
python app.py
```
Output should show:
```
 * Running on http://0.0.0.0:9009
 * WebSocket support enabled
```

### Step 4: Setup Android Project
1. Open `android/MuseEEGDashboard` in Android Studio
2. Download Muse SDK from:
   https://sites.google.com/a/interaxon.ca/muse-developer-site/
3. Copy `libmuse-android.jar` to:
   `android/MuseEEGDashboard/app/libs/`
4. Build APK:
   ```
   Build > Build Bundle(s) / APK(s) > Build APK(s)
   ```

### Step 5: Install & Run on Android Device
1. Get server IP:
   ```bash
   hostname -I | awk '{print $1}'
   ```
2. In Android app:
   - Enter server URL: `http://[SERVER_IP]:9009`
   - Tap "Connect to Muse 2"
   - Tap "Open Dashboard"

---

## 📊 Testing

### Test 1: Flask Server
```bash
# Check if server is running
curl http://localhost:9009/

# Get Android config
curl http://localhost:9009/api/android/config

# Expected:
# {
#   "sampling_rate": 256,
#   "channels": ["AF7", "AF8", "TP9", "TP10", "AUX"],
#   "streaming_interval": 100,
#   "server_version": "1.0.0"
# }
```

### Test 2: WebSocket Connection
```javascript
// In browser console
socket = io('http://localhost:9009/dashboard')
socket.on('connect', () => console.log('Connected!'))
```

### Test 3: Simulate Android Data
```bash
curl -X POST http://localhost:9009/api/eeg \
  -H "Content-Type: application/json" \
  -d '{
    "timestamp": '$(date +%s000)',
    "eeg_data": [10.5, 20.3, 15.8, 25.1, 5.2],
    "device_name": "Test-Android",
    "channels": ["AF7", "AF8", "TP9", "TP10", "AUX"]
  }'
```

---

## 🔧 Configuration

### Flask Configuration (app.py)
```python
app.config['DATA_FOLDER'] = 'muse_data'  # Data storage
app.config['SECRET_KEY'] = 'muse-eeg-secret-2024'  # WebSocket secret
socketio = SocketIO(app, cors_allowed_origins="*")  # Allow all origins
```

### Android Configuration (MainActivity.kt)
```kotlin
val serverUrl = "http://YOUR_SERVER_IP:9009"  // Configurable
val deviceName = "Muse-Android"  // Device identifier
```

### Dashboard Configuration (dashboard_android.html)
```javascript
const socket = io('/dashboard', {
    reconnectionDelayMax: 10000,
    reconnection: true,
    reconnectionDelay: 1000
})
```

---

## 🐛 Troubleshooting

### Issue: "Muse 2 not detected"
**Solution:**
- [ ] Muse 2 is powered on
- [ ] Bluetooth is enabled on Android
- [ ] Device is paired in Bluetooth settings
- [ ] Android location permission is granted

### Issue: "Connection refused"
**Solution:**
- [ ] Flask server is running
- [ ] Server URL is correct in Android app
- [ ] Firewall allows port 9009
- [ ] Device and server are on same network

### Issue: "WebSocket connection failed"
**Solution:**
- [ ] Check browser console (F12) for errors
- [ ] Verify Socket.IO script is loaded
- [ ] Check Flask server logs
- [ ] Restart Flask server

### Issue: "No data appearing on dashboard"
**Solution:**
- [ ] Check Android app is connected (status shows "Connected")
- [ ] Muse 2 is properly connected to Android
- [ ] Check API endpoint: `/api/eeg` is receiving POST requests
- [ ] Check Flask server logs for incoming data

---

## 📦 Dependencies Added

**Python (Flask):**
```
flask==2.3.0
flask-socketio==5.3.0
python-socketio==5.7.0
python-engineio==4.5.1
```

**Android (Gradle):**
```gradle
implementation 'androidx.appcompat:appcompat:1.6.1'
implementation 'com.squareup.okhttp3:okhttp:4.11.0'
implementation 'com.google.code.gson:gson:2.10.1'
implementation 'org.java-websocket:Java-WebSocket:1.5.4'
implementation files('libs/libmuse-android.jar')
```

---

## 📚 File Structure

```
/home/ubuntu/Documents/Penelitian/EEG Muse/
├── app.py (✅ UPDATED)
│   ├── Added WebSocket support
│   ├── Added `/api/android/*` endpoints
│   ├── Added namespace `/dashboard`
│   └── Thread-safe data handling
│
├── requirements.txt (✅ UPDATED)
│   ├── Added flask-socketio
│   ├── Added python-socketio
│   └── Added python-engineio
│
├── templates/
│   ├── index.html (existing)
│   ├── base.html (existing)
│   └── dashboard_android.html (✅ NEW)
│       ├── Real-time WebSocket client
│       ├── Live channel display
│       ├── Statistics calculation
│       └── Connection monitoring
│
├── android/ (✅ NEW)
│   ├── README_ANDROID.md
│   ├── MuseEEGDashboard/
│   │   ├── build.gradle
│   │   ├── settings.gradle
│   │   ├── settings.gradle.kts
│   │   ├── app/
│   │   │   ├── build.gradle
│   │   │   ├── proguard-rules.pro
│   │   │   ├── src/main/
│   │   │   │   ├── AndroidManifest.xml
│   │   │   │   ├── java/com/example/museeegdashboard/
│   │   │   │   │   ├── MainActivity.kt
│   │   │   │   │   ├── DashboardActivity.kt
│   │   │   │   │   └── service/MuseDataService.kt
│   │   │   │   └── res/
│   │   │   │       ├── layout/
│   │   │   │       │   ├── activity_main.xml
│   │   │   │       │   └── activity_dashboard.xml
│   │   │   │       └── values/
│   │   │   │           ├── strings.xml
│   │   │   │           └── themes.xml
│   │   │   ├── libs/
│   │   │   │   └── libmuse-android.jar (manual)
│   │   │   └── ...
│   │   └── ...
│   └── ...
│
├── ANDROID_SETUP_GUIDE.md (✅ NEW) - Complete setup guide
├── android_setup.sh (✅ NEW) - Automated setup
├── start_flask_android.sh (✅ NEW) - Flask launcher
└── ... (other existing files)
```

---

## 🎯 Key Features

✅ **Real-time Streaming**: 256Hz EEG data from Muse 2  
✅ **Multi-client Support**: Multiple browser/app connections simultaneously  
✅ **Thread-safe**: Safe concurrent access to data  
✅ **WebSocket Communication**: Low-latency real-time updates  
✅ **Automatic Reconnection**: Reconnects on network interruptions  
✅ **Statistics**: Real-time mean, std, min, max calculations  
✅ **Status Monitoring**: Battery and signal quality indicators  
✅ **Responsive UI**: Works on all screen sizes  
✅ **CORS Enabled**: Accessible from any origin  
✅ **Easy Setup**: Automated setup scripts provided  

---

## 🔒 Security Notes

For **Production Deployment:**
- [ ] Use HTTPS instead of HTTP
- [ ] Implement SSL/TLS certificates
- [ ] Add authentication/authorization
- [ ] Validate and sanitize all inputs
- [ ] Implement rate limiting
- [ ] Secure WebSocket with wss://
- [ ] Encrypt sensitive data in storage
- [ ] Implement CORS restrictions
- [ ] Add logging and monitoring

---

## 📝 Next Steps

1. **Deploy Flask to Production Server**
   - Use Gunicorn + Nginx
   - Setup SSL certificates
   - Configure firewall

2. **Enhance Android App**
   - Add offline data logging
   - Implement cloud backup
   - Add data export features
   - Optimize battery usage

3. **Improve Dashboard**
   - Add more visualization options
   - Implement FFT/frequency analysis
   - Add alert/notification system
   - Create data export to CSV/PDF

4. **Testing & QA**
   - Implement unit tests
   - Test on multiple Android versions
   - Test network resilience
   - Performance testing

---

## 📞 Support & Resources

- **Muse Developer**: https://sites.google.com/a/interaxon.ca/muse-developer-site/
- **Flask-SocketIO**: https://python-socketio.readthedocs.io/
- **Android Documentation**: https://developer.android.com/
- **Socket.IO Client**: https://socket.io/docs/v3/client-api/

---

**Status**: ✅ READY FOR TESTING  
**Last Updated**: April 13, 2024  
**Version**: 1.0.0
