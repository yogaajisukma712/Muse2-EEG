╔═══════════════════════════════════════════════════════════════════════╗
║                                                                       ║
║  📱 MUSE 2 + DASHBOARD - SETUP & USAGE GUIDE                        ║
║                                                                       ║
╚═══════════════════════════════════════════════════════════════════════╝


✅ BLUETOOTH STATUS
═══════════════════════════════════════════════════════════════════════

Device:    hci0
Status:    ✅ UP RUNNING
Powered:   ✅ YES
Name:      ubuntu
Address:   2C:D0:5A:E4:90:08

✨ Bluetooth Anda SUDAH AKTIF dan siap digunakan!


📋 STEP-BY-STEP WORKFLOW
═══════════════════════════════════════════════════════════════════════


STEP 1: PAIR MUSE 2 DEVICE
───────────────────────────

A. Siapkan Muse 2 Headband:
   1. Nyalakan Muse 2 (tombol power di belakang)
   2. Tunggu LED berkedip (device discoverable)
   3. Tunggu 10-20 detik

B. Pair via Bluetooth (Graphical):
   1. Buka Settings → Bluetooth
   2. Klik "Add Device" atau "Scan"
   3. Cari "Muse-XXXX" (4 digit angka)
   4. Klik untuk pair
   5. Tunggu sampai connected

C. Pair via Command Line (Alternative):
   ```bash
   bluetoothctl
   scan on
   # Tunggu sampai melihat "Muse-XXXX"
   
   pair <MAC_ADDRESS>
   # Contoh: pair 00:55:DA:B0:05:A3
   
   connect <MAC_ADDRESS>
   quit
   ```


STEP 2: JALANKAN MUSE 2 CONNECTION TOOL
─────────────────────────────────────────

Terminal 1 - Start Dashboard:
   cd "/home/ubuntu/Documents/Penelitian/EEG Muse"
   docker compose up -d
   
   Verify:
   curl http://localhost:9009
   # Should return dashboard HTML

Terminal 2 - Collect Data:
   cd "/home/ubuntu/Documents/Penelitian/EEG Muse"
   python3 muse_connect.py
   
   Script akan:
   1. Cari Muse 2 device
   2. Koneksi otomatis
   3. Mulai record EEG data
   4. Simpan ke CSV automatically
   
   Tekan Ctrl+C untuk stop (minimal 30 detik)


STEP 3: BUKA DASHBOARD
───────────────────────

Browser:
   http://localhost:9009

Anda akan melihat:
   ✅ Raw EEG signals dari 4 channel
   ✅ Frequency spectrum analysis
   ✅ Band power analysis
   ✅ Statistics
   ✅ File management


STEP 4: LIHAT DATA
──────────────────

Dashboard akan otomatis:
   • Auto-refresh setiap 5 detik
   • Update dengan data terbaru
   • Tampilkan visualisasi
   • Bisa download CSV


═══════════════════════════════════════════════════════════════════════


📊 DASHBOARD FEATURES EXPLANATION
═══════════════════════════════════════════════════════════════════════


1️⃣  RAW EEG SIGNAL
──────────────────

Apa itu?
  • Tegangan listrik dari otak (dalam µV)
  • 4 channel untuk lokasi berbeda
  • Real-time display

Channels:
  • AF7    = Atas kiri (prefrontal)
  • AF8    = Atas kanan (prefrontal)
  • TP9    = Belakang kiri (temporal)
  • TP10   = Belakang kanan (temporal)

Cara baca:
  • Garis gelombang = aktivitas otak
  • Naik turun normal
  • Amplitude ±5-20 µV typical


2️⃣  FREQUENCY SPECTRUM (FFT)
──────────────────────────────

Apa itu?
  • Analisis frekuensi EEG signal
  • Melihat dominant frequencies
  • Range 0-50 Hz

Cara baca:
  • Puncak = dominant frequency
  • Tinggi = lebih banyak power di frequency itu
  • Bisa lihat alpha wave dll


3️⃣  BAN POWER ANALYSIS
──────────────────────

Apa itu?
  Pembagian EEG ke 5 frequency bands:

  🔵 DELTA (0.5-4 Hz)
     State: Tidur dalam (deep sleep)
     Meaning: Istirahat total

  🟢 THETA (4-8 Hz)
     State: Mengantuk, meditasi
     Meaning: Relaksasi sedang

  🟡 ALPHA (8-12 Hz)
     State: Santai, mata tertutup
     Meaning: Relaxed awareness

  🟠 BETA (12-30 Hz)
     State: Terjaga, fokus
     Meaning: Mental activity

  🔴 GAMMA (30-50 Hz)
     State: Problem solving
     Meaning: High cognitive processing

Cara pakai:
  • Lihat bar chart
  • Lebih tinggi = lebih banyak power
  • Alpha tinggi = rileks


4️⃣  STATISTICS
───────────────

Menampilkan:
  • Mean = rata-rata nilai
  • Std Dev = variasi
  • Min/Max = range
  • Median = nilai tengah

Gunakan untuk:
  • Karakterisasi sinyal
  • Perbandingan session berbeda


5️⃣  FILE MANAGEMENT
────────────────────

Download data CSV:
  • Klik download button
  • CSV berisi semua data
  • Bisa import ke Excel/Python


═══════════════════════════════════════════════════════════════════════


🎯 COMPLETE WORKFLOW EXAMPLE
═══════════════════════════════════════════════════════════════════════

Waktu: ~15 menit

9:00 AM - PERSIAPAN
  □ Nyalakan Muse 2
  □ Pastikan charged
  □ Check Bluetooth

9:02 AM - START DASHBOARD
  Terminal 1:
  $ docker compose up -d
  $ curl http://localhost:9009
  
  Tunggu sampai respond

9:03 AM - START DATA COLLECTION
  Terminal 2:
  $ python3 muse_connect.py
  
  Output akan:
  🔍 Mencari Muse 2 Device...
  ✅ Ditemukan: Muse-XXXX
  🎬 Mulai recording...

9:03 AM - WEAR HEADBAND & RELAX
  • Pasang Muse 2 di kepala
  • Duduk santai
  • Minimal 1 menit recording

9:04-9:14 AM - COLLECT DATA
  Dashboard Recording...
  Terminal 2 akan menampilkan:
  Events recorded, data points saved

9:14 AM - STOP RECORDING
  Terminal 2:
  Tekan Ctrl+C
  
  Output:
  ✅ Recording selesai!
  📁 Data disimpan: muse_data_20240413_091400.csv

9:15 AM - VIEW DATA
  Browser:
  http://localhost:9009
  
  Dashboard auto-refresh:
  • Raw signals loading...
  • Frequency spectrum...
  • Band power analysis...
  • Statistics visible!

9:15+ AM - EXPLORE
  • Switch channels (AF7, AF8, TP9, TP10)
  • View different analysis
  • Download CSV if needed


═══════════════════════════════════════════════════════════════════════


❓ COMMON QUESTIONS
═══════════════════════════════════════════════════════════════════════

Q: Muse 2 tidak ketemu di device list?
A: 1. Pastikan Muse 2 ON (LED berkedip)
   2. Cek jarak (max 10 meter)
   3. Tunggu 20 detik scanning
   4. Restart Muse 2 jika perlu

Q: Connection error saat jalankan muse_connect.py?
A: 1. Pastikan Muse 2 sudah di-pair
   2. Buka bluetooth settings
   3. Pilih Muse 2 dan connect manual
   4. Coba lagi

Q: Dashboard tidak loading?
A: 1. Check: curl http://localhost:9009
   2. Restart: docker compose restart
   3. Check logs: docker logs muse2-dashboard

Q: Data tidak muncul di dashboard?
A: 1. Pastikan muse_connect.py sudah berjalan
   2. Tunggu minimal 30 detik recording
   3. Refresh browser (F5)
   4. Check CSV di muse_data/ folder

Q: Recording tapi data tidak tersemat?
A: 1. Check file size: ls -lah muse_data/
   2. Pastikan setup Muse 2 benar
   3. Cek headband kontak bagus


═══════════════════════════════════════════════════════════════════════


⚡ QUICK COMMANDS REFERENCE
═══════════════════════════════════════════════════════════════════════

Dashboard Management:
  docker compose up -d        # Start dashboard
  docker compose stop         # Stop
  docker compose restart      # Restart
  docker logs -f muse2-dashboard  # View logs

Data Collection:
  python3 muse_connect.py     # Collect data
  # Ctrl+C to stop

Check Data:
  ls -lah muse_data/          # List CSV files
  head -5 muse_data/muse_data_*.csv  # Preview data
  wc -l muse_data/muse_data_*.csv    # Count lines

Bluetooth Tools:
  bluetoothctl                # BT control (interactive)
  hciconfig -a                # Show BT info
  bluetoothctl scan on        # Scan devices


═══════════════════════════════════════════════════════════════════════


📁 DEFAULT CONFIGURATIONS
═══════════════════════════════════════════════════════════════════════

Dashboard Port:   9009
Dashboard URL:    http://localhost:9009
Data Folder:      ./muse_data/
Sampling Rate:    256 Hz
EEG Channels:     4 (AF7, AF8, TP9, TP10)
Aux Channel:      1
Auto-Refresh:     5 seconds
CSV Format:       Timestamp, Time_sec, Channel data


═══════════════════════════════════════════════════════════════════════


🔗 TUNNEL SETUP (Optional - For Remote Access)
═══════════════════════════════════════════════════════════════════════

Jika ingin akses dashboard dari internet:

Terminal 2 (baru):
  cloudflared tunnel --url http://localhost:9009

Tunggu output:
  https://xxxxx.trycloudflare.com

Share URL tersebut untuk akses remote!


═══════════════════════════════════════════════════════════════════════


✨ TIPS & TRICKS
═══════════════════════════════════════════════════════════════════════

Tip 1: Recording Duration
  Edit muse_connect.py line:
  duration = none    # Unlimited
  # atau
  duration = 300     # 5 minutes

Tip 2: Multiple Sessions
  Keep dashboard running (Terminal 1)
  Run multiple muse_connect.py (Terminal 2, 3, etc)
  Each generates new CSV file

Tip 3: Better Signal
  • Basahi headband pads dengan air
  • Pasang dengan pas di kepala
  • Kurangi gerakan
  • Duduk santai

Tip 4: Background Processing
  # Run dashboard in background
  docker compose up -d
  docker logs -f &    # View logs in background

Tip 5: Data Analysis
  python3 analyze_data.py     # Generate plots
  # Outputs:
  # - muse_raw_data.png
  # - frequency_spectrum_*.png


═══════════════════════════════════════════════════════════════════════


📞 GETTING HELP
═══════════════════════════════════════════════════════════════════════

For Issues:
  1. See: /home/ubuntu/Documents/Penelitian/EEG\ Muse/README.md
  2. Check: docker logs muse2-dashboard
  3. Test: bash test_tunnel.sh

For Documentation:
  1. SETUP_SUMMARY.md  → Setup details
  2. START_HERE.md     → Quick start
  3. CLOUDFLARED_SETUP.md → Tunnel help


═══════════════════════════════════════════════════════════════════════


🎉 YOU'RE READY!

1. Pair Muse 2 via Bluetooth
2. Run: docker compose up -d
3. Run: python3 muse_connect.py
4. Open: http://localhost:9009
5. Enjoy your EEG data! 


═══════════════════════════════════════════════════════════════════════

Questions? Read this file or check documentation.

Happy EEG analyzing! 🧠📊

═══════════════════════════════════════════════════════════════════════
