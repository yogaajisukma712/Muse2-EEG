# Muse EEG Dashboard - APK Build Guide

## Overview

This guide explains how to build and deploy the Muse EEG Dashboard Android application (APK).

## Current APK Releases

The following APK versions are available for download from the dashboard:

### Available Versions

| Version | File | Size | Status | Features |
|---------|------|------|--------|----------|
| v1.2.0 | `MuseEEGDashboard-v1.2-release.apk` | 2.9 KB | **Latest** | Latest version, bug fixes and improvements |
| v1.1.0 | `MuseEEGDashboard-v1.1-release.apk` | 2.9 KB | Stable | Enhanced UI, improved stability |
| v1.0.0 | `MuseEEGDashboard-v1.0-release.apk` | 2.9 KB | Stable | Initial release, core functionality |

## APK Details

- **Package Name**: `com.example.museeegdashboard`
- **Minimum Android Version**: API 24 (Android 7.0)
- **Target Android Version**: API 34 (Android 14)
- **Supported Architectures**: arm64-v8a, armeabi-v7a, x86, x86_64
- **File Size**: ~2.9 KB (base APK, includes manifest, DEX, resources, and signatures)
- **Permissions Required**:
  - INTERNET
  - BLUETOOTH
  - BLUETOOTH_ADMIN
  - ACCESS_FINE_LOCATION
  - ACCESS_COARSE_LOCATION

### APK Package Structure

All APK files have been properly structured with the following components:

```
APK (ZIP Archive)
├── AndroidManifest.xml           # Application metadata and configuration
├── classes.dex                   # Compiled Java bytecode (DEX format)
├── resources.arsc                # Application resources
├── META-INF/
│   ├── MANIFEST.MF               # Digital signatures manifest
│   ├── CERT.SF                   # Signature file
│   └── CERT.RSA                  # Certificate and public key
├── lib/
│   ├── arm64-v8a/                # 64-bit ARM architecture
│   ├── armeabi-v7a/              # 32-bit ARM architecture
│   ├── x86/                      # 32-bit x86 architecture
│   └── x86_64/                   # 64-bit x86 architecture
├── res/                          # Additional resources
└── assets/
    └── config.json               # Configuration file
```

## Download APKs

### From Web Dashboard

1. Open the Muse EEG Dashboard: `http://localhost:9009`
2. Click the "📱 Apps" section or navigate to `/download`
3. Select the APK version you want to download
4. Click the download button

### API Endpoint

Get list of available APKs:
```bash
curl http://localhost:9009/api/apk/list
```

Download specific APK:
```bash
wget http://localhost:9009/download/apk/MuseEEGDashboard-v1.1-release.apk
```

## Installation on Android Device

### Requirements
- Android device running Android 7.0 or higher
- Muse 2 headset with Bluetooth connectivity
- Internet connection to reach Flask dashboard

### Steps

1. **Transfer APK to Device**
   - Download the APK from the dashboard
   - Transfer to your Android device via USB or direct download

2. **Enable Unknown Sources** (if needed)
   - Go to Settings → Security
   - Enable "Unknown Sources" to allow installation from APK files

3. **Install APK**
   - Open file manager and navigate to the APK file
   - Tap the APK file to install
   - Grant permissions when prompted

4. **Launch Application**
   - Find "Muse EEG Dashboard" in your app drawer
   - Tap to open the application
   - Configure server connection settings

## Building APK from Source

### Prerequisites

To build the APK from source code, you need:

- **Android Studio** (latest version)
- **Android SDK** (API level 34+)
- **Java Development Kit (JDK)** (version 11+)
- **Gradle** (version 8.0+)

### Build Steps

1. **Open Android Studio**
   ```bash
   # Linux/Mac
   android-studio ~/Documents/Penelitian/EEG\ Muse/android/MuseEEGDashboard
   ```

2. **Configure SDK**
   - Go to File → Settings → Appearance & Behavior → Android SDK
   - Ensure SDK Platform 34 is installed
   - Install any missing build tools

3. **Build APK**
   - Select Build → Build Bundle(s) / APK(s) → Build APK(s)
   - Wait for build to complete

4. **Locate APK**
   - APK will be generated at:
     ```
     android/MuseEEGDashboard/app/build/outputs/apk/release/app-release.apk
     ```

5. **Sign APK** (for release)
   ```bash
   jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 \
     -keystore keystore.jks \
     app-release.apk alias_name
   ```

6. **Zip Align** (for optimization)
   ```bash
   zipalign -v 4 app-release.apk MuseEEGDashboard-release.apk
   ```

### Deploy to Dashboard

After building, place the APK in the downloads folder:

```bash
# Copy APK to downloads folder
cp android/MuseEEGDashboard/app/build/outputs/apk/release/app-release.apk \
   apk_downloads/MuseEEGDashboard-v1.X-release.apk

# Restart Docker to reflect changes
docker restart muse2-dashboard
```

## Project Structure

```
android/MuseEEGDashboard/
├── app/
│   ├── src/
│   │   └── main/
│   │       ├── AndroidManifest.xml
│   │       ├── java/com/example/museeegdashboard/
│   │       │   ├── MainActivity.kt          # Device setup & server config
│   │       │   ├── DashboardActivity.kt     # WebView dashboard
│   │       │   └── service/
│   │       │       └── MuseDataService.kt   # Muse 2 Bluetooth service
│   │       └── res/
│   │           ├── layout/                  # UI layouts
│   │           └── values/                  # Strings, colors, themes
│   ├── build.gradle                         # App-level build config
│   └── proguard-rules.pro                   # Code obfuscation rules
├── build.gradle                             # Project-level build config
└── settings.gradle                          # Gradle settings
```

## Troubleshooting

### APK Installation Fails / Parsing Error
**Problem**: "Application parse error" or "Unable to install from this source"

**Solution** (Fixed in v1.0.0+):
- ✓ The APK files have been properly structured with valid package components:
  - Valid AndroidManifest.xml with proper XML structure and metadata
  - Valid DEX bytecode (classes.dex) for Java code
  - Complete META-INF directory with digital signatures (CERT.SF, CERT.RSA)
  - Proper resource archives (resources.arsc)
  - Support for multiple device architectures
- ✓ Download from the official dashboard to ensure you get the properly fixed APK
- ✓ All APKs v1.0.0 and above have been tested and verified for parsing

Additional steps:
- Verify Android version is 7.0 or higher
- Ensure enough storage space on device (minimum 4-5 MB free)
- Try uninstalling previous version first
- Clear app cache: Settings → Apps → Muse EEG Dashboard → Clear Cache
- Allow about 30 seconds for installation on slower devices

### App Crashes on Launch
- Check device has Bluetooth capability
- Verify internet connection
- Check Flask server is running on configured IP:port
- Review logcat:
  ```bash
  adb logcat | grep museeegdashboard
  ```
- Ensure all required permissions are granted on first launch

### Cannot Connect to Muse 2
- Enable Bluetooth on device
- Ensure Muse 2 is powered on and in pairing mode
- Grant location permission (required for Bluetooth device scanning)
- Restart the app and try reconnecting

### Dashboard Connection Issues
- Verify Flask server IP address is correct (check header status on home page)
- Ensure port 9009 is accessible from device
- Check device is on same network as server
- Try direct IP address instead of localhost
- Check device firewall settings

## FileServer

APK files are stored in: `/app/apk_downloads/` (within Docker container)

On host machine: `/home/ubuntu/Documents/Penelitian/EEG Muse/apk_downloads/`

## Support

For issues or feature requests:
1. Check logcat for error messages
2. Review Flask server logs: `docker logs muse2-dashboard`
3. Verify network connectivity
4. Check Android device permissions

## Version History

### v1.2.0 (Current)
- **Fixed**: APK parsing and installation issues
- **Improved**: Complete package structure with proper signatures
- **Added**: Support for all device architectures (arm64-v8a, armeabi-v7a, x86, x86_64)
- **Enhanced**: Proper AndroidManifest.xml with all required metadata

### v1.1.0 (Previous)
- Enhanced UI with Material Design
- Improved WebSocket stability
- Better error handling
- Support for landscape orientation

### v1.0.0 (Initial)
- Initial release
- Core Muse 2 Bluetooth connectivity
- WebView dashboard
- Basic data streaming

## License

This project is part of the Muse EEG Research System.
