# Muse 2 Dashboard - Docker Setup

## 🚀 Menjalankan Dashboard dengan Docker

### Prasyarat
- Docker dan Docker Compose sudah terinstall
- File data Muse 2 (CSV) atau siap untuk recording

### Opsi 1: Docker Compose (Recommended)

**Build dan run dengan satu command:**

```bash
docker-compose up --build
```

Dashboard akan berjalan di: **http://localhost:9009**

Untuk menjalankan di background:
```bash
docker-compose up -d --build
```

**Stop container:**
```bash
docker-compose down
```

**Lihat logs:**
```bash
docker-compose logs -f muse-dashboard
```

### Opsi 2: Manual Docker Build

```bash
# Build image
docker build -t muse2-dashboard .

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
```

## 🌐 Akses Dashboard

Buka browser dan akses:
```
http://localhost:9009
```

## 📊 Fitur Dashboard

1. **Raw EEG Signal**
   - Tampil real-time EEG data dari semua 4 channel
   - Pilih channel mana yang ingin dilihat
   - Auto-refresh setiap 5 detik

2. **Frequency Spectrum**
   - FFT analysis untuk melihat dominant frequencies
   - Range 0-50 Hz (standar EEG)

3. **Statistics**
   - Mean, Standard Deviation, Min, Max, Median
   - Per-channel statistics

4. **Band Power Analysis**
   - Delta (0.5-4 Hz) - Sleep, unconsciousness
   - Theta (4-8 Hz) - Drowsiness, meditation
   - Alpha (8-12 Hz) - Relaxation
   - Beta (12-30 Hz) - Concentration
   - Gamma (30-50 Hz) - Cognitive processing

5. **File Management**
   - List semua CSV files
   - Download data langsung dari dashboard

## 🔧 Workflow

### 1. Setup Data Collection (di Host)

```bash
# Install dependencies
pip install -r requirements.txt

# Pair Muse 2 device via Bluetooth

# Mulai recording data
python muse_connect.py
# Tekan Ctrl+C untuk stop (minimal 30 detik)
```

Ini akan membuat file CSV di folder `muse_data/`

### 2. Run Dashboard dengan Docker

```bash
# Terminal 1 - Jalankan dashboard
docker-compose up

# Terminal 2 - Mulai recording data baru (optional)
python muse_connect.py
```

### 3. Akses Dashboard

Buka browser: **http://localhost:9009**

Data akan di-refresh otomatis setiap 5 detik

## 📁 Volume Mounting

Dashboard di-mount dengan volume agar:
- ✅ Data persist di folder `muse_data/`
- ✅ Data tidak hilang saat container di-stop
- ✅ Bisa add data tanpa restart container

## 🐛 Troubleshooting

### Port 9009 sudah dipakai
```bash
# Gunakan port lain di docker-compose.yml
# Ubah: "9009:9009" menjadi "9010:9009"

# Atau kill process yang menggunakan port
sudo lsof -i :9009
sudo kill -9 <PID>
```

### Permission denied saat mount volume
```bash
# Beri permission ke folder
sudo chmod -R 777 muse_data/

# Atau run dengan sudo
sudo docker-compose up
```

### Container tidak start
```bash
# Check logs
docker-compose logs muse-dashboard

# Rebuild
docker-compose down
docker-compose up --build
```

### Data tidak muncul di dashboard
1. Pastikan ada file CSV di folder `muse_data/`
2. File format harus benar (buat via `muse_connect.py`)
3. Restart container: `docker-compose restart`

## 🔍 Akses dari Device Lain

Jika ingin akses dashboard dari device lain di network:

1. Cari IP host:
```bash
hostname -I
# Contoh: 192.168.1.100
```

2. Akses dari device lain:
```
http://192.168.1.100:9009
```

**Note:** Pastikan firewall allow port 9009

## 📊 API Endpoints

Dashboard menggunakan REST API:

- `GET /` - Dashboard homepage
- `GET /api/data` - Raw EEG data
- `GET /api/statistics` - Statistics per channel
- `GET /api/frequency-spectrum?channel=AF7_uV` - FFT data
- `GET /api/band-power?channel=AF7_uV` - Band power analysis
- `GET /api/file-list` - List CSV files
- `GET /api/download/<filename>` - Download CSV file

Bisa di-access langsung via cURL atau API client

## 🚀 Production Setup

Untuk production, tambahkan:

1. **Reverse Proxy** (Nginx)
2. **SSL/HTTPS**
3. **Authentication**
4. **Database** untuk historical data
5. **Persistent volumes** di cloud storage

Hubungi untuk setup advanced!

## 📝 Notes

- Dashboard auto-refresh setiap 5 detik
- Data disimpan di `muse_data/` folder (persistent)
- Flask berjalan di development mode (change di production)
- Supported channels: AF7, AF8, TP9, TP10 (+ Aux)
- Sampling rate: 256 Hz (Muse 2)

---

**Enjoy! 🧠📊**
