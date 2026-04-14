# Muse 2 EEG Android Dashboard

Platform Android untuk koneksi Muse 2 dengan streaming real-time ke Flask Dashboard.

## 📱 Fitur

- ✅ Koneksi Bluetooth ke Muse 2
- ✅ Streaming data EEG real-time ke Flask Server
- ✅ WebView untuk akses Dashboard Flask
- ✅ Status monitoring (Battery, Signal Quality)
- ✅ Automatic reconnection
- ✅ Data buffering dan compression

## 🛠️ Prerequisites

### Tools
- Android Studio 8.0+
- JDK 11+
- Android SDK 24+ (min API level)

### Dependencies
- Muse SDK (libmuse-android.jar)
- AndroidX libraries
- OkHttp 4.11+
- Gson 2.10+

## 📥 Setup Instructions

### 1. Buka Project di Android Studio

```bash
cd android/MuseEEGDashboard
```

Kemudian buka di Android Studio.

### 2. Download Muse SDK

1. Unduh libmuse dari: https://sites.google.com/a/interaxon.ca/muse-developer-site/
2. Extract dan copy `libmuse-android.jar` ke:
   ```
   app/libs/libmuse-android.jar
   ```

### 3. Configure Server URL

Edit `MainActivity.kt`:
```kotlin
val serverUrl = "http://YOUR_SERVER_IP:9009"
```

Atau gunakan SharedPreferences dalam UI.

### 4. Build APK

```android
Build > Build Bundle(s) / APK(s) > Build APK(s)
```

## 🚀 Cara Menggunakan

### Di Android Device:

1. **Install APK** di Android device
2. **Siapkan Muse 2**:
   - Nyalakan Muse 2
   - Pair via Bluetooth settings
3. **Launch App**:
   - Buka aplikasi
   - Enter Flask Server URL (contoh: `http://192.168.1.100:9009`)
   - Tap "Connect to Muse 2"
4. **Monitor**:
   - Status akan berubah menjadi "✅ Connected"
   - Data mulai di-stream ke Flask
5. **View Dashboard**:
   - Tap "Open Dashboard" untuk lihat realtim di WebView

## 🔌 API Endpoints

### Dari Android ke Flask

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/api/android/register` | POST | Register device |
| `/api/android/config` | GET | Get config |
| `/api/eeg` | POST | Send EEG data |
| `/api/android/status` | POST | Send status update |

### Response Format

**EEG Data:**
```json
{
  "timestamp": 1681234567890,
  "eeg_data": [10.5, 20.3, 15.8, 25.1, 5.2],
  "device_name": "Muse-Android",
  "channels": ["AF7", "AF8", "TP9", "TP10", "AUX"]
}
```

**Status:**
```json
{
  "connection": "connected",
  "battery": 85,
  "signal_quality": 95
}
```

## 🔍 Troubleshooting

### ❌ Muse 2 tidak terdeteksi

- [ ] Cek Bluetooth aktif
- [ ] Cek Muse 2 menyala
- [ ] Cek permissions di Android Settings
- [ ] Jarak Muse 2 ke device < 10 meter

### ❌ Server connection failed

- [ ] Cek network connection
- [ ] Cek server URL benar
- [ ] Cek Flask server running: `python app.py`
- [ ] Cek firewall tidak blok port 9009

### ❌ Permissions denied

- [ ] Go to: Android Settings > Apps > MuseEEGDashboard > Permissions
- [ ] Grant: Bluetooth, Location, Internet

## 📊 Architecture

```
┌─────────────────────────────────────────────────────────┐
│                  Android Muse App                       │
├──────────────────┬──────────────────┬──────────────────┤
│  MainActivity    │  MuseDataService │  DashboardActivity │
└──────────────────┴──────────────────┴──────────────────┘
           │                │                │
           └────────────────┼────────────────┘
                           │
                    Bluetooth / HTTP
                           │
┌─────────────────────────────────────────────────────────┐
│              Flask Dashboard Server                      │
├──────────────────┬──────────────────┬──────────────────┤
│ /api/android/*   │ WebSocket Events │ Dashboard HTML   │
└──────────────────┴──────────────────┴──────────────────┘
```

## 📝 Project Structure

```
android/MuseEEGDashboard/
├── app/
│   ├── src/main/
│   │   ├── java/com/example/museeegdashboard/
│   │   │   ├── MainActivity.kt (Setup & Config)
│   │   │   ├── DashboardActivity.kt (WebView)
│   │   │   └── service/
│   │   │       └── MuseDataService.kt (Muse Connection)
│   │   ├── res/
│   │   │   ├── layout/
│   │   │   │   ├── activity_main.xml
│   │   │   │   └── activity_dashboard.xml
│   │   │   └── values/
│   │   │       ├── strings.xml
│   │   │       └── themes.xml
│   │   └── AndroidManifest.xml
│   ├── build.gradle
│   └── libs/
│       └── libmuse-android.jar
├── build.gradle
└── settings.gradle
```

## 🔐 Security Notes

- URL server disimpan di SharedPreferences (bukan encrypted)
- Untuk production, gunakan HTTPS dan encryption
- Validasi server certificate
- Implement authentication token

## 📦 Dependencies

```gradle
- androidx.appcompat:appcompat:1.6.1
- androidx.constraintlayout:constraintlayout:2.1.4
- com.squareup.okhttp3:okhttp:4.11.0
- com.google.code.gson:gson:2.10.1
- com.github.PhilJay:MPAndroidChart:v3.1.0
```

## 📞 Support

Untuk issues atau questions, check:
1. Android Logcat untuk error messages
2. Flask server logs
3. Android device Bluetooth settings

## 📄 License

MIT License
