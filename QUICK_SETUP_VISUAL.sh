#!/bin/bash

cat << 'EOF'

╔═════════════════════════════════════════════════════════════════════════╗
║                                                                         ║
║   ✅ BLUETOOTH AKTIF & SIAP DIGUNAKAN                                 ║
║                                                                         ║
║   Sekarang tinggal ikuti langkah di bawah ini!                         ║
║                                                                         ║
╚═════════════════════════════════════════════════════════════════════════╝


🔍 BLUETOOTH STATUS ANDA:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

   ✅ Adapter:      UP RUNNING
   ✅ Powered:      YES
   ✅ Discoverable: YES
   ✅ Ready:        YES

   Siap pair dengan Muse 2!


═════════════════════════════════════════════════════════════════════════


📱 STEP 1: PAIR MUSE 2 HEADBAND
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

   1.1 Nyalakan Muse 2
   ──────────────────
   • Cari tombol power di belakang headband
   • Tahan 2 detik
   • LED akan berkedip (tanda entry Bluetooth mode)
   • Tunggu 10 detik


   1.2 Pair via Bluetooth Settings
   ────────────────────────────────
   Option A: Graphical
   • Settings → Bluetooth
   • Klik "Add New Device"
   • Cari "Muse-XXXX" (XXXX = 4 digit angka)
   • Klik untuk pair
   • Enter PIN jika diminta (default: 0000)
   • Tunggu sampai "Connected❶"

   Option B: Command Line
   $ bluetoothctl
   [bluetooth]# scan on
   # Tunggu sampai melihat "Muse-XXXX"
   [bluetooth]# pair XX:XX:XX:XX:XX:XX
   [bluetooth]# connect XX:XX:XX:XX:XX:XX
   [bluetooth]# quit


═════════════════════════════════════════════════════════════════════════


🖥️  STEP 2: SETUP DASHBOARD
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

   2.1 Terminal 1: Jalankan Dashboard
   ──────────────────────────────────
   
   $ cd "/home/ubuntu/Documents/Penelitian/EEG Muse"
   $ docker compose up -d
   
   Tunggu 3-5 detik
   
   Verify:
   $ curl http://localhost:9009
   
   Jika berhasil output HTML dashboard


   2.2 Check Dashboard Running
   ─────────────────────────────
   
   $ docker compose ps
   
   Harus menunjukkan:
   ✅ muse2-dashboard    Running
   ✅ Port 0.0.0.0:9009


═════════════════════════════════════════════════════════════════════════


📊 STEP 3: COLLECT DATA
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

   3.1 Terminal 2: Jalankan Data Collector
   ───────────────────────────────────────
   
   $ cd "/home/ubuntu/Documents/Penelitian/EEG Muse"
   $ python3 muse_connect.py
   
   Output akan:
   
   🔍 Mencari Muse 2 Device...
   ✅ Ditemukan: Muse-XXXX
   ✅ Terhubung ke device
   🎬 Mulai recording...
   📊 Recording data...


   3.2 Pakai Headband
   ──────────────────
   • Pasang Muse 2 di kepala
   • Pastikan semua electrode menyentuh kulit
   • Duduk santai
   • Record minimal 30 detik (lebih baik 1-2 menit)


   3.3 Stop Recording
   ──────────────────
   Setelah selesai:
   • Tekan Ctrl+C di Terminal 2
   
   Output:
   ✅ Recording selesai!
   📁 Data disimpan: muse_data_YYYYMMDD_HHMMSS.csv


═════════════════════════════════════════════════════════════════════════


🌐 STEP 4: VIEW DASHBOARD
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

   4.1 Open Browser
   ────────────────
   
   URL: http://localhost:9009
   
   Anda akan melihat:
   
   ┌─────────────────────────────────────────┐
   │ 🧠 MUSE 2 EEG DATA DASHBOARD           │
   │                                          │
   │ Status: ✅ Data tersedia                │
   │ Data Points: 256 sampel                 │
   │                                          │
   │ ┌──────────────────────────────────┐   │
   │ │ 📊 Raw EEG Signal                │   │
   │ │ [Dropdown: AF7 ▼]                │   │
   │ │ [Wave graph showing data]        │   │
   │ └──────────────────────────────────┘   │
   │                                          │
   │ ┌──────────────────────────────────┐   │
   │ │ 📈 Frequency Spectrum            │   │
   │ │ [FFT graph 0-50 Hz]              │   │
   │ └──────────────────────────────────┘   │
   │                                          │
   │ ┌──────────────────────────────────┐   │
   │ │ 🧠 Band Power Analysis           │   │
   │ │ Delta: ████ Theta: ██ Alpha: ███│   │
   │ └──────────────────────────────────┘   │
   │                                          │
   │ ┌──────────────────────────────────┐   │
   │ │ 📉 Statistics (AF7)              │   │
   │ │ Mean: 10.5 µV | Std: 2.3 µV    │   │
   │ │ Min: 2.1 | Max: 18.9 | Med: 10.8│  │
   │ └──────────────────────────────────┘   │
   │                                          │
   │ ┌──────────────────────────────────┐   │
   │ │ 📁 File Management               │   │
   │ │ muse_data_20240413_091400.csv ⬇️ │   │
   │ └──────────────────────────────────┘   │
   └─────────────────────────────────────────┘


   4.2 Explore Dashboard
   ─────────────────────
   
   • Switch Channels:
     Pilih AF7, AF8, TP9, TP10 dari dropdown
   
   • View Frequency:
     Lihat FFT analysis 0-50 Hz
   
   • Check Band Power:
     Delta, Theta, Alpha, Beta, Gamma
   
   • Download Data:
     Klik download button untuk CSV


═════════════════════════════════════════════════════════════════════════


📋 SUMMARY WORKFLOW
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

   Terminal 1:
   $ docker compose up -d       ← Start dashboard

   Terminal 2:
   $ python3 muse_connect.py    ← Collect data (wait 1-2 min)
                                ← Ctrl+C to stop

   Browser:
   http://localhost:9009        ← View results!


═════════════════════════════════════════════════════════════════════════


✅ VERIFICATION CHECKLIST
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

   Before Starting:
   ☐ Muse 2 charged
   ☐ Muse 2 paired via Bluetooth
   ☐ Bluetooth active (✅ YES - already active!)

   During Setup:
   ☐ Dashboard running (docker compose up)
   ☐ Data collector running (python3 muse_connect.py)
   ☐ Muse 2 wearing & connected

   After Recording:
   ☐ CSV file in muse_data/ folder
   ☐ Dashboard showing data
   ☐ Can see all 4 channels


═════════════════════════════════════════════════════════════════════════


🎯 NEXT IMMEDIATE STEPS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

   Right Now:
   
   1. Pair Muse 2 (via Bluetooth Settings)
   
   2. Open Terminal & run:
      docker compose up -d
   
   3. Open New Terminal & run:
      python3 muse_connect.py
   
   4. Open Browser:
      http://localhost:9009
   
   5. Done! Enjoy your EEG data! 🎉


═════════════════════════════════════════════════════════════════════════


❓ TROUBLESHOOTING QUICK FIXES
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

   "Muse 2 tidak ditemukan"
   → ON-kan Muse 2, tunggu 20 detik, pair manual

   "Connection failed in muse_connect.py"
   → Pair Muse 2 via Bluetooth settings dulu

   "Dashboard tidak loading"
   → docker compose restart

   "Data tidak muncul"
   → Tunggu 30+ detik recording, refresh F5


═════════════════════════════════════════════════════════════════════════


📚 DOCUMENTATION FILES
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

   /home/ubuntu/Documents/Penelitian/EEG\ Muse/

   📖 MUSE_AND_DASHBOARD_GUIDE.md   ← Detailed guide
   📖 START_HERE.md                 ← Quick start
   📖 SETUP_SUMMARY.md              ← Setup details
   📖 README.md                     ← General info


═════════════════════════════════════════════════════════════════════════


✨ YOU'RE ALL SET!

Bluetooth: ✅ ACTIVE
Dashboard: ✅ READY
Guides: ✅ PREPARED

Now go pair Muse 2 and start collecting data!

═════════════════════════════════════════════════════════════════════════

EOF
