# 🧠 Muse 2 Dashboard - Panduan Setup Lengkap

**Status:** ✅ SIAP DIJALANKAN

## 📦 File-file yang Dibuat

```
/home/ubuntu/Documents/Penelitian/EEG Muse/
├── app.py                    # Flask application (website)
├── muse_connect.py           # Script untuk koneksi & ambil data Muse 2
├── analyze_data.py           # Script untuk analisis data
├── Dockerfile                # Docker configuration
├── docker-compose.yml        # Docker Compose setup (recommended)
├── requirements.txt          # Python dependencies (lokal)
├── requirements-docker.txt   # Python dependencies (Docker)
├── quick_start.sh            # Quick start script
│
├── templates/
│   ├── base.html            # Base template
│   └── index.html           # Dashboard UI
│
├── README.md                 # Dokumentasi dasar
└── DOCKER_SETUP.md          # Panduan Docker
```

## 🚀 Cara Menggunakan - 3 Pilihan

### Pilihan 1: Docker Compose (RECOMMENDED) ⭐

**Terminal 1 - Jalankan Dashboard:**
```bash
cd "/home/ubuntu/Documents/Penelitian/EEG Muse"
docker-compose up
```

**Terminal 2 - Mulai Recording Data (optional):**
```bash
cd "/home/ubuntu/Documents/Penelitian/EEG Muse"
python3 muse_connect.py
```

**Akses:** http://localhost:9009

**Stop:** Tekan Ctrl+C di Terminal 1

---

### Pilihan 2: Docker Manual

```bash
cd "/home/ubuntu/Documents/Penelitian/EEG Muse"

# Run container
docker run -p 9009:9009 \
  -v $(pwd)/muse_data:/app/muse_data \
  --name muse-dash \
  muse2-dashboard

# Atau di background
docker run -d -p 9009:9009 \
  -v $(pwd)/muse_data:/app/muse_data \
  --name muse-dash \
  muse2-dashboard

# Check logs
docker logs -f muse-dash

# Stop
docker stop muse-dash
```

**Akses:** http://localhost:9009

---

### Pilihan 3: Run Lokal (tanpa Docker)

**Terminal 1 - Install & Run Dashboard:**
```bash
cd "/home/ubuntu/Documents/Penelitian/EEG Muse"
pip install -r requirements-docker.txt
python3 app.py
```

**Terminal 2 - Mulai Recording:**
```bash
cd "/home/ubuntu/Documents/Penelitian/EEG Muse"
python3 muse_connect.py
```

**Akses:** http://localhost:9009

---

## 📊 Dashboard Features

Setelah membuka http://localhost:9009, Anda akan melihat:

### 1️⃣ Raw EEG Signal
- Tampilan real-time dari EEG channels
- Pilih channel: AF7, AF8, TP9, TP10
- Auto-refresh setiap 5 detik
- Interactive chart dengan Chart.js

### 2️⃣ Frequency Spectrum
- FFT Analysis
- Range 0-50 Hz
- Identifikasi dominant frequencies

### 3️⃣ Statistics
- Mean, Std Dev, Min, Max, Median
- Per-channel statistics
- Tab untuk switch antar channel

### 4️⃣ Band Power Analysis
- Delta (0.5-4 Hz) 💤
- Theta (4-8 Hz) 🧘
- Alpha (8-12 Hz) 😴
- Beta (12-30 Hz) 🎯
- Gamma (30-50 Hz) 🧠

### 5️⃣ File Management
- List semua CSV files
- Download langsung dari dashboard
- Metadata: size, modified time

---

## 🔧 Workflow Lengkap

### Step 1: Setup Muse 2 Hardware
```bash
# Pair device via Bluetooth settings
# Pastikan Muse 2 sudah on
# Pair di Bluetooth settings
```

### Step 2: Jalankan Dashboard
```bash
docker-compose up
# Atau sesuai pilihan di atas
```

### Step 3: Mulai Recording Data
```bash
# Buka terminal baru
python3 muse_connect.py
# Tekan Ctrl+C setelah selesai
```

### Step 4: Analisis di Dashboard
- Buka http://localhost:9009
- Pilih channel yang ingin dilihat
- Klik refresh untuk update data terbaru
- Download CSV jika perlu

### Step 5 (Optional): Advanced Analysis
```bash
python3 analyze_data.py
# Generate plots:
# - muse_raw_data.png
# - frequency_spectrum_AF7_uV.png
```

---

## 📋 Checklist

Sebelum mulai, pastikan:

- [ ] Muse 2 headband sudah disiapkan
- [ ] Bluetooth enable di komputer
- [ ] Docker installed & running
- [ ] Folder sudah di `/home/ubuntu/Documents/Penelitian/EEG Muse`
- [ ] Port 9009 tidak sedang digunakan

**Cek port 9009:**
```bash
lsof -i :9009
# Jika ada, gunakan port lain di docker-compose.yml
```

---

## 🌐 Network Access

### Akses dari Device Lain di Network

**Find Host IP:**
```bash
hostname -I
# Contoh output: 192.168.1.100
```

**Akses dari device lain:**
```
http://192.168.1.100:9009
```

**Jika tidak bisa:**
- Cek firewall setting
- Port forward jika diperlukan
- Pastikan container running: `docker-compose ps`

---

## 🐛 Troubleshooting

### Container tidak start
```bash
docker-compose logs muse-dashboard
docker-compose down
docker-compose up --build
```

### Port sudah dipakai
Edit `docker-compose.yml`:
```yaml
ports:
  - "9010:9009"  # Ganti 9009 ke 9010
```

### Data tidak muncul di dashboard
1. Pastikan ada CSV di folder `muse_data/`
2. Jalankan `muse_connect.py` untuk ambil data baru
3. Refresh page (F5)
4. Restart container

### Permission denied
```bash
sudo chmod -R 777 muse_data/
sudo docker-compose up
```

### Docker image terlalu besar
```bash
docker image prune -a  # Hapus unused images
docker system prune -a # Clean up system
```

---

## 📊 Data Format

CSV yang dihasilkan:

```csv
Timestamp,Time_sec,AF7_uV,AF8_uV,TP9_uV,TP10_uV,Aux_uV
2024-04-13T10:30:45.123456,0.00,-12.5678,15.4321,-8.9012,11.2345,-5.6789
2024-04-13T10:30:45.124456,0.01,-12.5678,15.4321,-8.9012,11.2345,-5.6789
```

**Column:**
- `Timestamp`: ISO format time
- `Time_sec`: Relative time (seconds)
- `AF7_uV` - `TP10_uV`: 4 EEG channels (µV)
- `Aux_uV`: Auxiliary channel (µV)

---

## 🔌 Muse 2 Channel Mapping

| Channel | Location | Position |
|---------|----------|----------|
| **AF7** | Frontal Left | Di atas telinga kiri |
| **AF8** | Frontal Right | Di atas telinga kanan |
| **TP9** | Temporal Left | Belakang telinga kiri |
| **TP10** | Temporal Right | Belakang telinga kanan |

---

## 📚 Frequency Bands

| Band | Range | Typical State |
|------|-------|---------------|
| **Delta** | 0.5-4 Hz | Sleep, unconsciousness |
| **Theta** | 4-8 Hz | Drowsiness, meditation |
| **Alpha** | 8-12 Hz | Relaxation, closed eyes |
| **Beta** | 12-30 Hz | Concentration, alert |
| **Gamma** | 30-50 Hz | High cognitive processing |

---

## 🎯 Next Steps

1. **Data Collection**
   ```bash
   python3 muse_connect.py
   ```

2. **View Dashboard**
   ```
   http://localhost:9009
   ```

3. **Advanced Analysis**
   ```bash
   python3 analyze_data.py
   ```

4. **Export Data**
   - Download via dashboard
   - Atau copy dari `muse_data/` folder

---

## ⚙️ Architecture

```
┌─────────────────────┐
│  Muse 2 Headband    │
│   (Bluetooth)       │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│  muse_connect.py    │
│  (Record & Save)    │
└──────────┬──────────┘
           │
           ▼
      ┌────────────┐
      │  CSV Data  │
      │(muse_data/)│
      └─────┬──────┘
            │
            ▼
┌──────────────────────┐
│ Flask App (app.py)   │
├──────────────────────┤
│ API Endpoints        │
│ - /api/data          │
│ - /api/statistics    │
│ - /api/frequency     │
│ - /api/band-power    │
│ - /api/file-list     │
└──────────┬───────────┘
           │
           ▼
┌──────────────────────┐
│   Docker Container   │
│    Port 9009         │
└──────────┬───────────┘
           │
           ▼
    ┌──────────────┐
    │  Web Browser │
    │  Dashboard   │
    └──────────────┘
```

---

## 📞 Support

Untuk issue atau pertanyaan:

1. Check `DOCKER_SETUP.md` untuk detail Docker
2. Check `README.md` untuk Muse setup
3. Lihat logs: `docker-compose logs`
4. Restart: `docker-compose restart`

---

## ✅ Summary

**Docker Image Status:** ✅ BUILT
```
Image: muse2-dashboard:latest
Size: 325MB
Tag: latest
```

**Ready to run:**
```bash
docker-compose up
```

**Enjoy! 🧠📊**

---

*Last updated: April 13, 2026*
