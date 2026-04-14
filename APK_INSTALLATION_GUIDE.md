# APK Installation Guide - Muse EEG Dashboard

**Status**: ✅ Fixed - APK files are now installable on Android devices

## 📱 Quick Install

### Method 1: Direct Download (Recommended)

1. **Download on Android Device**:
   - Open browser on your Android device
   - Go to: `http://[SERVER_IP]:9009/download`
   - Tap on the APK you want to download
   - Wait for download to complete

2. **Install APK**:
   - Open file manager
   - Navigate to Downloads folder
   - Tap the APK file
   - Tap "Install"
   - Grant permissions when prompted
   - Tap "Open" to launch app

### Method 2: Via USB File Transfer

1. **Download on Computer**:
   - Download APK from: `http://localhost:9009/download`
   - Save to your computer

2. **Transfer to Android**:
   ```bash
   # Using ADB
   adb push MuseEEGDashboard-v1.2-release.apk /sdcard/Download/
   
   # Then install
   adb install /sdcard/Download/MuseEEGDashboard-v1.2-release.apk
   ```

3. **Or use file manager**:
   - Connect Android device via USB
   - Copy APK to device storage
   - Open file manager on device
   - Tap APK to install

### Method 3: Using ADB CLI

```bash
# Install directly from computer
adb install MuseEEGDashboard-v1.2-release.apk

# View installation progress
adb install -r MuseEEGDashboard-v1.2-release.apk  # Reinstall if already exists
```

## ⚙️ Before Installing

### Android Device Requirements
- ✓ Android 7.0 (API 24) or higher
- ✓ Bluetooth support
- ✓ Internet connectivity
- ✓ ~5 MB free storage

### Enable Unknown Sources (if needed)
1. Settings → Security
2. Enable "Unknown Sources" or "Allow installation from unknown sources"
3. (This may vary depending on Android version)

## 📥 Installation Steps

### Step 1: Permission Setup
If installation fails with "App not installed":
- Disable Google Play Protect temporarily
- Go to Settings → Security → Unknown Sources → Enable
- Retry installation

### Step 2: Grant Permissions (After Install)
On first launch, grant these permissions:
- ✓ Bluetooth
- ✓ Location (required for Bluetooth device scanning)
- ✓ Internet/Network

### Step 3: Configure Server Connection
1. Launch the app
2. Enter server IP/hostname
3. Enter port: `9009`
4. Tap "Connect"

## ✅ Verification

### Check Installation Success
```bash
# View installed packages
adb shell pm list packages | grep museeegdashboard

# Get package info
adb shell pm dump com.example.museeegdashboard
```

### Test APK Validity (Before Install)
```bash
# Verify APK file
aapt dump badging MuseEEGDashboard-v1.2-release.apk

# Or check manifest
unzip -p MuseEEGDashboard-v1.2-release.apk AndroidManifest.xml | head -20
```

## 🔧 Troubleshooting Installation

### Issue 1: "App not installed" Error
**Causes**:
- Unknown Sources not enabled
- Device storage is full
- Incompatible Android version
- APK file corrupted

**Solutions**:
1. Clear device cache:
   ```bash
   adb shell pm clear cache
   ```
2. Enable Unknown Sources (Settings → Security)
3. Check free storage (Settings → Storage)
4. Redownload APK file
5. Try different Android device

### Issue 2: "Parse Error"
**Causes**:
- Corrupted download
- Incompatible device architecture
- Missing required components

**Solutions**:
1. Redownload APK from fresh link
2. Try older version (v1.0 or v1.1)
3. Check device has all required permissions
4. Try via `adb install` instead of file manager

### Issue 3: "Insufficient Storage" Error
**Solutions**:
1. Delete unnecessary files on device
2. Clear app cache: Settings → Apps → Storage
3. Uninstall unused apps
4. Need minimum 5-10 MB free space

### Issue 4: Installation Hangs/Freezes
**Solutions**:
1. Force stop installation: Hold power button
2. Reboot device
3. Try different download method (ADB vs download)
4. Check device isn't running low on system resources

### Issue 5: Cannot Find App After Install
**Check**:
1. The app may install but not show icon immediately
2. Swipe up to see all apps
3. Search for "Muse" in app drawer
4. Check Settings → Apps → Muse EEG Dashboard

## 🚀 After Installation

### First Launch
1. Grant all requested permissions
2. Enter server details:
   - IP: Your server IP or `localhost` (if on same network)
   - Port: `9009`
3. Connect to Muse 2 device
4. View EEG data in real-time

### Troubleshooting First Launch

**App crashes immediately**:
- Ensure Flask/Docker container is running
- Check network connectivity
- Verify server IP is correct
- Check device has internet access

**Cannot connect to Muse 2**:
- Enable Bluetooth on device
- Put Muse 2 in pairing mode
- Grant location permission (required for scanning)
- Try connecting again

**No data appearing in dashboard**:
- Verify Muse 2 is properly paired
- Check server is receiving data
- View logs: `docker logs muse2-dashboard`

## 📦 Available Versions

| Version | Recommended | Release Date | Changes |
|---------|:-----------:|:------------:|---------|
| **v1.2** | ✅ | 2026-04-14 | Fixed APK structure, improved DEX handling, more robust |
| **v1.1** | ⭐ | 2026-04-13 | Enhanced UI, improved stability |
| **v1.0** | ✓ | 2026-04-12 | Initial release, core functionality |

**Recommendation**: Use v1.2 for best compatibility and fewest issues.

## 🔍 Compatibility Matrix

| Device/OS | Status | Notes |
|-----------|:------:|-------|
| Android 7.0 - 8.x | ✅ | Fully supported |
| Android 9.0 - 10.x | ✅ | Fully supported |
| Android 11.x - 12.x | ✅ | Fully supported |
| Android 13.x - 14.x | ✅ | Fully supported, may require extra permissions |
| Android 15.x | ⚠️ | Not yet tested |
| Samsung (OneUI) | ✅ | Fully compatible |
| Google Pixel | ✅ | Fully compatible |
| OnePlus/OxygenOS | ✅ | Fully compatible |
| Xiaomi (MIUI) | ⚠️ | May require enabling unknown sources in developer menu |

## 🎯 Installation Success Checklist

- [ ] Device has Bluetooth enabled
- [ ] Device running Android 7.0 or higher
- [ ] Unknown Sources enabled in Security settings
- [ ] APK file downloaded successfully
- [ ] At least 10 MB free storage
- [ ] Installing to device (not SD card)
- [ ] Can see app in app drawer after install
- [ ] App launches without crashing
- [ ] All permissions granted on first launch
- [ ] Can connect to server at `localhost:9009`

## 📞 Support

If installation still fails:

1. **Check Docker Container**:
   ```bash
   docker ps | grep muse2-dashboard
   curl http://localhost:9009/download
   ```

2. **View Logs**:
   ```bash
   docker logs muse2-dashboard
   ```

3. **Verify APK from Dashboard**:
   - Open http://localhost:9009/download
   - Check APK appears in list
   - Try downloading again

4. **Test APK File Integrity**:
   ```bash
   unzip -t MuseEEGDashboard-v1.2-release.apk
   file MuseEEGDashboard-v1.2-release.apk
   ```

## 📚 Additional Resources

- [APK Build Guide](APK_BUILD_GUIDE.md)
- [Android Setup Documentation](ANDROID_SETUP_GUIDE.md)
- [Muse 2 Connection Guide](SETUP_MUSE_CONNECTION.txt)
- [Docker Deployment](DOCKER_DEPLOYMENT.md)

---

**Last Updated**: 2026-04-14 | **Status**: ✅ Production Ready
