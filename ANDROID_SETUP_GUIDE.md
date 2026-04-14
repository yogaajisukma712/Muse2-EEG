# Muse 2 Android + Flask Setup Guide

Panduan lengkap untuk setup sistem terintegrasi Muse 2 Android dengan Flask Dashboard.

## 🎯 Arsitektur Sistem

```
Muse 2 (Bluetooth)
    ↓
Android App (MuseEEGDashboard)
    ↓ (HTTP/WebSocket)
Flask Server (port 9009)
    ↓
Web Dashboard (Real-time visualization)
```

## 📋 Step-by-Step Setup

### TAHAP 1: Persiapan Flask Server

#### 1.1 Install Dependencies
```bash
cd /home/ubuntu/Documents/Penelitian/EEG\ Muse
source .venv/bin/activate
pip install -r requirements.txt
```

#### 1.2 Update requirements.txt
File sudah diupdate dengan:
- flask-socketio==5.3.0
- python-socketio==5.7.0
- python-engineio==4.5.1

#### 1.3 Jalankan Flask Server
```bash
python app.py
```

Output:
```
 * Running on http://0.0.0.0:9009
```

### TAHAP 2: Setup Android Project

#### 2.1 Requirements
- Android Studio 8.0+
- JDK 11+
- Android SDK 24+

#### 2.2 Open Project
```bash
cd android/MuseEEGDashboard
# Buka di Android Studio
```

#### 2.3 Download Muse SDK
1. Kunjungi: https://sites.google.com/a/interaxon.ca/muse-developer-site/
2. Download "Muse Android SDK"
3. Extract dan copy `libmuse-android.jar` ke `app/libs/`

#### 2.4 Configure
- Edit `MainActivity.kt`: ubah `serverUrl` ke IP server Anda
- Contoh: `http://192.168.1.100:9009`

#### 2.5 Build APK
```
Build > Build Bundle(s) / APK(s) > Build APK(s)
```

### TAHAP 3: Setup Android Device

#### 3.1 Enable Developer Mode
- Settings > About Phone
- Tap "Build Number" 7x
- Go back to Settings > Developer options > USB Debugging ON

#### 3.2 Grant Permissions
- Settings > Apps > MuseEEGDashboard > Permissions
- Enable: Bluetooth, Location, Internet

#### 3.3 Pair Muse 2
- Settings > Bluetooth
- Scan for devices
- Select "Muse-XXXX"
- Pair

### TAHAP 4: Jalankan Sistem

#### 4.1 Start Flask Server
```bash
python app.py
```

#### 4.2 Install APK di Android
```bash
adb install -r app/build/outputs/apk/debug/app-debug.apk
```

#### 4.3 Launch App
1. Buka "Muse EEG Dashboard" app
2. Enter server URL: `http://[SERVER_IP]:9009`
3. Tap "Connect to Muse 2"
4. Tap "Open Dashboard"

## 🔍 Testing

### Test Flask Connection
```bash
# Terminal 1: Flask server
python app.py

# Terminal 2: Test endpoint
curl http://localhost:9009/api/android/config
```

Output:
```json
{
  "sampling_rate": 256,
  "channels": ["AF7", "AF8", "TP9", "TP10", "AUX"],
  "streaming_interval": 100,
  "server_version": "1.0.0"
}
```

### Check Logs

**Flask Server:**
```bash
# Tail logs
tail -f *.log

# Atau jalankan dengan verbose
python app.py --debug
```

**Android Logcat:**
```bash
adb logcat | grep "MuseDataService"
```

## 🌐 Akses Dashboard

### Dari Desktop
```
http://localhost:9009
```

### Dari Android App
- Tap "Open Dashboard" button
- WebView akan load Flask dashboard

## 📊 Real-time Data Flow

```
Android App
    ├─ Detect Muse 2 (Bluetooth)
    ├─ Connect to Muse 2
    ├─ Register to Flask (/api/android/register)
    ├─ Stream EEG Data (POST /api/eeg)
    └─ Update Status
           │
           ↓
Flask Server
    ├─ Receive EEG data
    ├─ Broadcast via WebSocket
    └─ Save to CSV
           │
           ↓
Web Dashboard
    ├─ Receive real-time updates
    ├─ Visualize data
    ├─ Show statistics
    └─ Display frequency analysis
```

## ⚙️ Configuration

### Flask Settings (`app.py`)
- `DATA_FOLDER`: 'muse_data'
- WebSocket CORS: Allowed all origins
- Port: 9009

### Android Settings (`MainActivity.kt`)
- Default URL: `http://192.168.1.100:9009`
- Permissions: Bluetooth, Internet, Location
- Min API Level: 24

## 🔧 Troubleshooting

### Issue: "No Muse device found"
**Solution:**
- [ ] Cek Muse 2 menyala
- [ ] Cek Bluetooth enabled
- [ ] Pair device di Bluetooth settings
- [ ] Check Android Logcat untuk error

### Issue: "Connection refused"
**Solution:**
- [ ] Cek Flask server running
- [ ] Cek server URL benar
- [ ] Cek network connectivity
- [ ] Check firewall port 9009

### Issue: "Permissions denied"
**Solution:**
- [ ] Grant permissions di Android Settings
- [ ] Reinstall APK
- [ ] Clear app cache

### Issue: "Data not updating"
**Solution:**
- [ ] Check WebSocket connection
- [ ] Check browser console (F12)
- [ ] Check Flask server logs
- [ ] Restart Flask server

## 📦 File Structure Updated

```
/home/ubuntu/Documents/Penelitian/EEG Muse/
├── app.py (UPDATED: WebSocket support)
├── requirements.txt (UPDATED: Added flask-socketio)
├── android/
│   ├── README_ANDROID.md (NEW)
│   └── MuseEEGDashboard/
│       ├── build.gradle
│       ├── settings.gradle
│       └── app/
│           ├── build.gradle
│           ├── src/main/
│           │   ├── AndroidManifest.xml
│           │   ├── java/com/example/museeegdashboard/
│           │   │   ├── MainActivity.kt
│           │   │   ├── DashboardActivity.kt
│           │   │   └── service/MuseDataService.kt
│           │   └── res/
│           │       ├── layout/
│           │       │   ├── activity_main.xml
│           │       │   └── activity_dashboard.xml
│           │       └── values/
│           │           ├── strings.xml
│           │           └── themes.xml
│           └── libs/
│               └── libmuse-android.jar (MANUAL COPY)
```

## ✅ Verification Checklist

- [ ] Flask server berjalan di port 9009
- [ ] Android APK built successfully
- [ ] Muse 2 paired via Bluetooth
- [ ] App connects to server
- [ ] EEG data streaming
- [ ] Dashboard menampilkan data real-time
- [ ] Status indicators working

## 🚀 Next Steps

1. Deploy Flask ke production server
2. Implement HTTPS + SSL certificates
3. Add authentication/login
4. Optimize data compression
5. Add offline caching
6. Implement cloud backup

## 📞 Quick Reference

| Action | Command |
|--------|---------|
| Start Flask | `python app.py` |
| Build APK | `./gradlew build` |
| Install APK | `adb install -r app/build/outputs/apk/debug/app-debug.apk` |
| Check Logcat | `adb logcat` |
| Test API | `curl http://localhost:9009/api/android/config` |

---

**Last Updated**: 2024
**Version**: 1.0.0
