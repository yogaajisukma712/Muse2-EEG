# Muse 2 EEG Data Collection & Analysis

Kumpulan script Python untuk mengambil data dari headband EEG **Muse 2** dan melakukan analisis.

## 📋 Persyaratan

- Python 3.7+
- Muse 2 headband
- Bluetooth connection ke komputer
- Muse 2 sudah dipasangkan (paired) dengan komputer

## 🚀 Instalasi

1. **Install dependencies:**
```bash
pip install -r requirements.txt
```

2. **Setup Muse 2 di Bluetooth:**
   - Nyalakan Muse 2
   - Buka Bluetooth settings di komputer
   - Cari dan pair dengan Muse device
   - Pastikan Muse terkoneksi

## 📊 Cara Menggunakan

### 1. Mengambil Data (Collect Data)

```bash
python muse_connect.py
```

Script ini akan:
- ✅ Mencari Muse 2 device
- ✅ Terhubung ke device
- ✅ Mulai merekam data EEG
- ✅ Simpan ke file CSV otomatis

Data akan disimpan di folder `muse_data/` dengan nama:
```
muse_data_YYYYMMDD_HHMMSS.csv
```

**Hentikan recording dengan menekan Ctrl+C**

#### Opsi pengaturan durasi:
Buka `muse_connect.py` dan ubah baris:
```python
duration = None  # None = unlimited, atau ganti dengan angka dalam detik
# Contoh: duration = 60  # 60 detik
```

### 2. Analisis Data

```bash
python analyze_data.py
```

Script ini akan:
- 📈 Menampilkan statistik data (mean, std dev, min, max)
- 📊 Plot raw EEG signals
- 🎯 Analisis frequency spectrum
- 🧠 Hitung band power (Delta, Theta, Alpha, Beta, Gamma)

## 📁 Format Data CSV

File CSV yang dihasilkan memiliki struktur:

```
Timestamp,Time_sec,AF7_uV,AF8_uV,TP9_uV,TP10_uV,Aux_uV
2024-04-13T10:30:45.123456,0.00,-12.5678,15.4321,-8.9012,11.2345,-5.6789
2024-04-13T10:30:45.124456,0.00,-12.5678,15.4321,-8.9012,11.2345,-5.6789
...
```

### Penjelasan kolom:
- **Timestamp**: Waktu pengambilan data (ISO format)
- **Time_sec**: Waktu relatif dalam detik sejak recording dimulai
- **AF7_uV**: EEG channel kiri atas (µV)
- **AF8_uV**: EEG channel kanan atas (µV)
- **TP9_uV**: EEG channel kiri bawah (µV)
- **TP10_uV**: EEG channel kanan bawah (µV)
- **Aux_uV**: Auxiliary channel (µV)

## 🧠 Muse 2 EEG Channels

Muse 2 memiliki 4 channel EEG + 1 auxiliary:

| Channel | Lokasi | Posisi |
|---------|--------|--------|
| AF7 | Frontal Left | Di atas telinga kiri |
| AF8 | Frontal Right | Di atas telinga kanan |
| TP9 | Temporal Left | Belakang telinga kiri |
| TP10 | Temporal Right | Belakang telinga kanan |

## 📈 Frequency Bands

EEG signals biasanya dianalisis dalam frequency bands:

| Band | Frekuensi | Karakteristik |
|------|-----------|---------------|
| **Delta** | 0.5-4 Hz | Sleep, unconsciousness |
| **Theta** | 4-8 Hz | Drowsiness, meditation |
| **Alpha** | 8-12 Hz | Relaxation, closed eyes |
| **Beta** | 12-30 Hz | Concentration, alert |
| **Gamma** | 30-50 Hz | Cognitive processing |

## ⚙️ Troubleshooting

### Muse device tidak ditemukan
```
❌ Tidak ada Muse device yang ditemukan!
```

**Solusi:**
1. Pastikan Muse 2 sudah menyala
2. Pastikan Bluetooth enable di komputer
3. Cek apakah Muse sudah dipair di Bluetooth settings
4. Re-pair jika perlu

### Permission denied error
Jika mengalami permission error saat akses Bluetooth:
```bash
sudo python muse_connect.py
```

### Koneksi timeout
Jika koneksi terputus:
- Restart Muse 2
- Unpair dan re-pair device
- Restart Bluetooth

## 📝 Contoh Workflow

```bash
# 1. Pakai cek device connected
python muse_connect.py

# 2. Recording selama 10 menit (600 detik)
# Edit duration = 600 di muse_connect.py
python muse_connect.py

# 3. Analisis data yang sudah dikumpulkan
python analyze_data.py
```

## 🔧 Advanced Usage

### Custom duration recording
Edit `muse_connect.py`:
```python
duration = 300  # 5 menit
success = collector.start_recording(duration=duration)
```

### Menganalisis file specific
Edit `analyze_data.py`:
```python
csv_file = Path("muse_data/muse_data_20240413_103045.csv")
analyzer = MuseDataAnalyzer(csv_file)
```

## 📚 Referensi

- **Muse 2 Specifications**: https://choosemuse.com/
- **muselsl library**: https://github.com/alexandrebarachant/muse-lsl
- **EEG frequency bands**: https://en.wikipedia.org/wiki/Electroencephalography

## 📄 License

Open source - bebas digunakan untuk penelitian

---

**Happy EEG recording! 🧠📊**
