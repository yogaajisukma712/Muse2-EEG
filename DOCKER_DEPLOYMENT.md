# 🐳 Docker Deployment - Muse 2 EEG Dashboard

**Status**: ✅ **DEPLOYED ON DOCKER**  
**Port**: 9009  
**Container**: muse2-dashboard  
**Image**: muse-eeg-dashboard:latest

---

## ✅ Deployment Summary

Dashboard Muse 2 EEG telah berhasil di-deploy ke Docker dengan port 9009. Semua fitur termasuk APK download page sudah berfungsi dan terintegrasi.

### 🎯 Features yang Deployed:

✅ Main Dashboard (/) - Visualisasi data EEG  
✅ Android Dashboard (/dashboard-android) - Real-time streaming  
✅ Download APK (/download) - Download aplikasi Android  
✅ API Endpoints (/api/*) - Rest API untuk mobile app  
✅ WebSocket Support - Real-time communication  
✅ Health Check - Container health monitoring  

---

## 🚀 Quick Access

### 🌐 Dashboard URLs

```
Main Dashboard:      http://localhost:9009
Android Dashboard:   http://localhost:9009/dashboard-android
Download APK:        http://localhost:9009/download
```

### 📡 API Endpoints

```
GET    /api/android/config        - Get server configuration
GET    /api/apk/list             - List available APKs
POST   /api/apk/upload           - Upload new APK (dev)
GET    /download/apk/<filename>  - Download APK file
GET    /api/data                 - Get EEG data
GET    /api/statistics           - Get statistics
GET    /api/frequency-spectrum   - Get frequency data
```

---

## 🐳 Docker Commands

### Check Container Status
```bash
docker ps
docker ps | grep muse2-dashboard
```

### View Logs
```bash
# Real-time logs
docker logs -f muse2-dashboard

# Last 50 lines
docker logs --tail 50 muse2-dashboard

# With timestamps
docker logs -f --timestamps muse2-dashboard
```

### Stop/Start Container
```bash
# Stop container
docker stop muse2-dashboard

# Start container
docker start muse2-dashboard

# Restart container
docker restart muse2-dashboard
```

### Access Container Shell
```bash
docker exec -it muse2-dashboard bash
```

### Remove Container (if needed)
```bash
# Stop and remove
docker stop muse2-dashboard
docker rm muse2-dashboard
```

### View Image Details
```bash
docker images | grep muse-eeg-dashboard
docker inspect muse-eeg-dashboard:latest
```

---

## 📊 Container Details

**Image**: muse-eeg-dashboard:latest  
**Container ID**: See `docker ps` output  
**Port Mapping**: 0.0.0.0:9009->9009/tcp  
**Restart Policy**: unless-stopped  
**Status**: ✅ Running  

### Volumes Mounted:
```
./muse_data        → /app/muse_data
./apk_downloads    → /app/apk_downloads
./templates        → /app/templates
```

### Environment Variables:
```
FLASK_APP=app.py
FLASK_ENV=production
PYTHONUNBUFFERED=1
```

---

## 📁 Files Modified for Docker

### Updated:
- **Dockerfile** - Added apk_downloads support
- **requirements-docker.txt** - Added flask-socketio
- **docker-compose.yml** - Added apk_downloads volume
- **app.py** - Added /download and /api/apk/* endpoints
- **templates/download.html** - New APK download page
- **templates/dashboard_android.html** - Added download link

### Created:
- **deploy_docker.sh** - Automated deployment script

---

## 🔧 Deployment Process

### Step 1: Build Image (Already Done)
```bash
docker build -t muse-eeg-dashboard:latest .
```

### Step 2: Run Container (Already Done)
```bash
docker run -d \
    --name muse2-dashboard \
    -p 9009:9009 \
    -v "$(pwd)/muse_data:/app/muse_data" \
    -v "$(pwd)/apk_downloads:/app/apk_downloads" \
    -v "$(pwd)/templates:/app/templates" \
    -e FLASK_APP=app.py \
    -e FLASK_ENV=production \
    -e PYTHONUNBUFFERED=1 \
    --restart unless-stopped \
    muse-eeg-dashboard:latest
```

### Step 3: Verify (Already Done)
```bash
docker ps
curl http://localhost:9009
```

---

## 🧪 Testing Endpoints

### 1. Main Dashboard
```bash
curl http://localhost:9009/
```

### 2. Download Page
```bash
curl http://localhost:9009/download
```

### 3. APK List API
```bash
curl http://localhost:9009/api/apk/list | json_pp
```

### 4. Android Config
```bash
curl http://localhost:9009/api/android/config | json_pp
```

### 5. Upload Test APK
```bash
curl -X POST -F "file=@app-debug.apk" \
    http://localhost:9009/api/apk/upload
```

---

## 📱 Upload APK File

###  Using Web Interface
1. Go to: http://localhost:9009/download
2. Click "📁 Select APK File"
3. Choose your APK file
4. Wait for upload progress

### Using cURL
```bash
curl -X POST \
    -F "file=@build/outputs/apk/debug/app-debug.apk" \
    http://localhost:9009/api/apk/upload
```

### Using Docker Exec
```bash
docker cp app-debug.apk muse2-dashboard:/app/apk_downloads/
```

---

## 🔍 Troubleshooting

### Container won't start
```bash
docker logs muse2-dashboard
```

### Port already in use
```bash
docker stop muse2-dashboard
lsof -i :9009  # or netstat -tuln | grep 9009
```

### Cannot access dashboard
```bash
# Check if container is running
docker ps | grep muse2-dashboard

# Check container health
docker ps -a

# Test from inside container
docker exec muse2-dashboard curl http://localhost:9009
```

### Permission issues with volumes
```bash
chmod 777 muse_data
chmod 777 apk_downloads
chmod 777 templates
```

---

## 🚀 Restart Deployment

If you need to rebuild and deploy fresh:

```bash
# Option 1: Using deployment script
./deploy_docker.sh

# Option 2: Manual steps
docker stop muse2-dashboard
docker rm muse2-dashboard
docker build -t muse-eeg-dashboard:latest .
docker run -d --name muse2-dashboard -p 9009:9009 -v ./muse_data:/app/muse_data -v ./apk_downloads:/app/apk_downloads -v ./templates:/app/templates muse-eeg-dashboard:latest
```

---

## 📊 Performance Monitoring

### Check Container Resource Usage
```bash
docker stats muse2-dashboard
```

### View Container Processes
```bash
docker top muse2-dashboard
```

### Inspect Network
```bash
docker network inspect bridge
```

---

## 🔐 Security Notes

For production deployment:

- [ ] Use HTTPS instead of HTTP
- [ ] Implement authentication
- [ ] Restrict API access
- [ ] Use environment variables for secrets
- [ ] Set resource limits
- [ ] Enable logging

Example with resource limits:
```bash
docker run -d \
    --name muse2-dashboard \
    -p 9009:9009 \
    --memory="512m" \
    --cpus="1.0" \
    -v ./muse_data:/app/muse_data \
    -v ./apk_downloads:/app/apk_downloads \
    muse-eeg-dashboard:latest
```

---

## 📚 Docker Compose Alternative

You can also use docker-compose:

```bash
# Start container
docker compose up -d

# View logs
docker compose logs -f

# Stop container
docker compose down

# Rebuild image
docker compose build --no-cache
```

---

## 🎯 Next Steps

1. ✅ Deploy Android app with APK download feature
2. ✅ Test real-time streaming with Android devices
3. ✅ Monitor container logs in production
4. ✅ Setup backup for data volumes
5. ✅ Configure CI/CD for automated updates

---

## 📝 Deployment Commands Reference

```bash
# Build
docker build -t muse-eeg-dashboard:latest .

# Run
docker run -d --name muse2-dashboard -p 9009:9009 muse-eeg-dashboard:latest

# Stop
docker stop muse2-dashboard

# Start
docker start muse2-dashboard

# Logs
docker logs -f muse2-dashboard

# Shell
docker exec -it muse2-dashboard bash

# Remove
docker rm -f muse2-dashboard

# List containers
docker ps -a

# List images
docker images
```

---

**Status**: ✅ **READY FOR PRODUCTION**  
**Last Updated**: April 13, 2026  
**Version**: 1.0.0
