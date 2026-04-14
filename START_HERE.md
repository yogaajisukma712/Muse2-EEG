# 🎯 MUSE 2 DASHBOARD - QUICK START GUIDE

## ✅ Status: SIAP DIJALANKAN

Docker image sudah dibangun dan siap digunakan!

---

## 🚀 3 Cara MUDAH untuk Menjalankan

### **Cara 1: Docker Compose (RECOMMENDED)** ⭐

Paling mudah dan recommended!

```bash
cd "/home/ubuntu/Documents/Penelitian/EEG Muse"
docker-compose up
```

Selesai! Dashboard siap di http://localhost:9009

**Stop:** Tekan Ctrl+C

---

### **Cara 2: Docker Manual**

```bash
cd "/home/ubuntu/Documents/Penelitian/EEG Muse"
docker run -p 9009:9009 -v $(pwd)/muse_data:/app/muse_data muse2-dashboard
```

---

### **Cara 3: Run Lokal (Python Langsung)**

```bash
cd "/home/ubuntu/Documents/Penelitian/EEG Muse"
pip install -r requirements-docker.txt
python3 app.py
```

---

## 📊 Setelah Dashboard Running

### 1. COLLECT DATA (Terminal Baru)

```bash
cd "/home/ubuntu/Documents/Penelitian/EEG Muse"
python3 muse_connect.py
```

Pastikan:
- Muse 2 device sudah nyala
- Bluetooth paired di komputer
- Recording minimal 30 detik

Tekan **Ctrl+C** untuk stop collect data

### 2. VIEW DASHBOARD

Buka browser:
```
http://localhost:9009
```

Anda akan melihat:
- 📊 Raw EEG signals dari 4 channels
- 📈 Frequency spectrum
- 🧠 Band power analysis (Delta, Theta, Alpha, Beta, Gamma)
- 📉 Statistics per channel
- 📁 File management & download

### 3. ANALYZE DATA (Optional)

```bash
cd "/home/ubuntu/Documents/Penelitian/EEG Muse"
python3 analyze_data.py
```

Akan generate:
- `muse_raw_data.png` - Raw signal plots
- `frequency_spectrum_*.png` - FFT analysis plots

---

## 🌐 Dashboard Features

| Fitur | Deskripsi |
|-------|-----------|
| **Raw Signal** | Real-time EEG dari semua channel |
| **Frequency** | FFT spectrum analysis (0-50 Hz) |
| **Statistics** | Mean, Std, Min, Max, Median |
| **Band Power** | Delta, Theta, Alpha, Beta, Gamma |
| **File Manager** | Download CSV files |
| **Auto-Refresh** | Update setiap 5 detik |

---

## 🔧 Port & Network

**Default Port:** 9009

**Akses dari:**
- Lokal: `http://localhost:9009`
- Network: `http://<your-ip>:9009`

**Cari IP Anda:**
```bash
hostname -I
```

---

## 📁 Data Location

Semua data disimpan di:
```
/home/ubuntu/Documents/Penelitian/EEG Muse/muse_data/
```

Format nama file:
```
muse_data_YYYYMMDD_HHMMSS.csv
```

Contoh:
```
muse_data_20240413_103045.csv
```

---

## 📋 Checklist Sebelum Mulai

- [ ] Muse 2 headband ready
- [ ] Bluetooth enabled
- [ ] Device paired
- [ ] Docker running
- [ ] Port 9009 available

**Check port:**
```bash
lsof -i :9009
```

---

## 🐛 Quick Troubleshooting

| Problem | Solution |
|---------|----------|
| Container not start | `docker-compose down && docker-compose up --build` |
| Port 9009 in use | Change port in `docker-compose.yml` |
| No data showing | Run `python3 muse_connect.py` first |
| Can't find Muse | Pair device in Bluetooth settings |
| Permission denied | `sudo chmod -R 777 muse_data/` |

---

## 📚 Documentation Files

| File | Deskripsi |
|------|-----------|
| **SETUP_SUMMARY.md** | Panduan setup lengkap |
| **DOCKER_SETUP.md** | Detail Docker configuration |
| **README.md** | General documentation |
| **quick_start.sh** | Automated setup script |

---

## 🎓 Muse 2 EEG Channels

```
AF7 ─────────── AF8
 ↑               ↑
 └───────┬───────┘
    Forehead

TP9             TP10
 ↑               ↑
 └──────┬────────┘
  Behind Ears
```

**Recording Position:**
- AF7/AF8: Prefrontal cortex (思考, 집중)
- TP9/TP10: Temporal lobes (감정, 메모리)

---

## 🚀 Next Steps

```bash
# 1. Start dashboard
docker-compose up

# 2. In new terminal - collect data
python3 muse_connect.py
# (Let it run for 1-2 minutes, then Ctrl+C)

# 3. Open browser
# http://localhost:9009

# 4. Enjoy! 🎉
```

---

## 💡 Pro Tips

1. **Auto-refresh disabled?**
   - Refresh page manually: F5
   - Or click 🔄 button on dashboard

2. **Want to change refresh rate?**
   - Edit `templates/index.html`
   - Find `REFRESH_INTERVAL = 5000`
   - Change to milliseconds (5000 = 5 seconds)

3. **Want different port?**
   - Edit `docker-compose.yml`
   - Change `9009:9009` to `9010:9009` (example)

4. **Running multiple instances?**
   ```bash
   docker-compose -f docker-compose-2.yml up  # Use different compose file
   ```

---

## 📞 Common Commands

```bash
# Start dashboard
docker-compose up

# Start in background
docker-compose up -d

# See logs
docker-compose logs -f

# Stop
docker-compose stop

# Remove container
docker-compose down

# Rebuild image
docker-compose up --build

# Check container status
docker-compose ps

# Remove everything
docker-compose down -v
```

---

## ✨ Features at a Glance

✅ Real-time EEG visualization
✅ 4 EEG channels (AF7, AF8, TP9, TP10)
✅ Frequency spectrum analysis
✅ Band power analysis (5 bands)
✅ Statistical analysis
✅ File management & download
✅ Pretty UI with dark theme
✅ Responsive design
✅ Auto-refresh capability
✅ Docker containerized

---

## 🎯 What to Do Now

**Option A: Just View Dashboard**
```bash
docker-compose up
# Then open http://localhost:9009
```

**Option B: Collect New Data**
```bash
# Terminal 1
docker-compose up

# Terminal 2
python3 muse_connect.py  # ~30 second minimum

# Then view http://localhost:9009
```

**Option C: Analyze Old Data**
```bash
python3 analyze_data.py
```

---

**Ready? Let's go! 🚀**

```bash
cd "/home/ubuntu/Documents/Penelitian/EEG Muse"
docker-compose up
```

Dashboard akan siap di: **http://localhost:9009**

---

*Muse 2 EEG Dashboard v1.0 - April 2024*
