# Muse EEG Dashboard - Android Project

Complete Android Studio project untuk Muse EEG Dashboard aplikasi di Android devices.

## Project Structure

```
MuseEEGAndroid/
├── app/
│   ├── src/main/
│   │   ├── java/com/example/museeegdashboard/
│   │   │   ├── MainActivity.kt
│   │   │   └── DashboardActivity.kt
│   │   ├── layout/
│   │   │   ├── activity_main.xml
│   │   │   └── activity_dashboard.xml
│   │   ├── values/
│   │   │   ├── strings.xml
│   │   │   └── styles.xml
│   │   └── AndroidManifest.xml
│   └── build.gradle
├── build.gradle
└── settings.gradle
```

## Build Instructions

### Metode 1: Menggunakan Android Studio (Recommended)

1. **Install Android Studio**
   - Download dari https://developer.android.com/studio
   - Install dengan default settings

2. **Open Project**
   - File → Open
   - Navigasi ke folder `MuseEEGAndroid`
   - Pilih folder dan klik OK
   - Tunggu Gradle sync selesai

3. **Build APK**
   - Build → Build Bundle(s) / APK(s) → Build APK(s)
   - Tunggu proses build selesai (5-10 menit)

4. **Locate APK**
   - APK akan terletak di:  
     `app/build/outputs/apk/debug/app-debug.apk`

5. **Install ke Device**
   - Hubungkan Android device via USB
   - Aktifkan "USB Debugging" di Settings → Developer Options
   - Di Android Studio: Run → Run 'app'
   - Atau transfer APK ke device dan tap untuk install

### Metode 2: Menggunakan Gradle Command Line

```bash
cd MuseEEGAndroid

# Cek gradle
./gradlew --version

# Build APK
./gradlew assembleDebug

# APK output
app/build/outputs/apk/debug/app-debug.apk

# Install ke device
./gradlew installDebug
```

### Metode 3: Setup Prerequisites (Linux)

Jika belum punya Android SDK:

```bash
# Install Android SDK
sudo apt-get install android-sdk

# Setup PATH
export ANDROID_SDK_ROOT=/usr/lib/android-sdk
export PATH=$PATH:$ANDROID_SDK_ROOT/cmdline-tools/latest/bin

# Build
./gradlew assembleDebug
```

## Requirements

- **Android Studio**: >= 2023.1
- **Gradle**: >= 8.0
- **Java/Kotlin**: >= 11
- **Android SDK**: API Level 34 (Android 14)
- **Minimum Device**: Android 7.0 (API 24)

## Features

✅ **Bluetooth Connection**: Hubungkan ke Muse 2 headset  
✅ **Server Configuration**: Atur alamat Flask server  
✅ **WebView Dashboard**: Tampilkan dashboard via WebView  
✅ **Real-time EEG Data**: Stream data langsung ke device  
✅ **Multi-architecture**: Support arm64, armv7, x86, x86_64  

## Permissions

```xml
INTERNET - Akses Flask server
BLUETOOTH - Koneksi Muse 2
BLUETOOTH_ADMIN - Scan & connect devices
BLUETOOTH_SCAN - Scan Bluetooth devices
BLUETOOTH_CONNECT - Connect ke Muse 2
ACCESS_FINE_LOCATION - Bluetooth discovery
ACCESS_COARSE_LOCATION - Bluetooth discovery
```

## Troubleshooting

### "Error: Could not find or load main class"
- Pastikan Java 11+ terinstall
- Run: `java -version`

### "Build Failed: Task 'assembleDebug' failed"
- Sync Gradle: `./gradlew sync`
- Clear cache: `./gradlew clean build`

### "No connected devices"
- Aktifkan USB Debugging di device
- Pastikan driver USB terinstall
- Run: `adb devices` (pastikan device tercantum)

### "Application not installing"
- Uninstall versi lama: `adb uninstall com.example.museeegdashboard`
- Reinstall APK
- Atau pilih "Replace Existing App" di Android Studio

## Configuration

Edit `DashboardActivity.kt` untuk mengubah server URL:

```kotlin
val dashboardUrl = "http://$serverIp/download"  // Atur sesuai kebutuhan
```

## Next Steps Setelah Build

1. ✅ Transfer APK ke Android device
2. ✅ Install dan buka aplikasi
3. ✅ Masukkan alamat server Flask (contoh: `192.168.1.100:9009`)
4. ✅ Tap "Hubungkan ke Dashboard"
5. ✅ Aktifkan Bluetooth
6. ✅ Scan & connect ke Muse 2 device
7. ✅ Lihat real-time EEG data di dashboard

## Build Output

Ukuran APK yang dihasilkan:
- **Debug APK**: ~25-35 MB
- **Release APK** (setelah optimize): ~15-20 MB

## Support

Untuk masalah atau pertanyaan:
- Check Android Studio Logcat untuk error messages
- Verify Flask server running di port 9009
- Ensure Muse 2 device dalam range Bluetooth
- Check network connectivity antara device dan server

---
Generated: April 2026
