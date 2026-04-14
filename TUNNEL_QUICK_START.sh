#!/bin/bash

cat << 'EOF'

╔═════════════════════════════════════════════════════════════════════╗
║                                                                     ║
║    🌐 MUSE 2 DASHBOARD + CLOUDFLARED - QUICK SETUP GUIDE          ║
║                                                                     ║
╚═════════════════════════════════════════════════════════════════════╝


✅ CURRENT STATUS:

   ✔️  Dashboard: Running on http://localhost:9009
   ✔️  Cloudflared: Installed & running
   ⏳  Tunnel: Need to configure


═════════════════════════════════════════════════════════════════════


🚀 FASTEST METHOD (5 MINUTES):

   Jalankan di terminal baru:

   $ cloudflared tunnel --url http://localhost:9009

   Tunggu output seperti ini:
   
   ╭─────────────────────────────────────╮
   │ Your tunnel is online!              │
   │ https://xxxxx.trycloudflare.com     │
   ╰─────────────────────────────────────╯

   ✨ URL itu bisa langsung dibuka di browser!
   
   Note: URL valid selama 8 jam. Setelah itu perlu jalankan lagi.


═════════════════════════════════════════════════════════════════════


🔗 SETUP PERMANEN (15 MINUTES):

   Step 1: Authentikasi ke Cloudflare
   ─────────────────────────────────────
   $ cloudflared login
   
   Browser akan buka. Sign in dengan account Cloudflare.
   Pilih domain dari list.


   Step 2: Setup tunnel
   ──────────────────────
   $ bash /home/ubuntu/Documents/Penelitian/EEG\ Muse/setup_tunnel.sh

   Follow instructions.


   Step 3: Run tunnel
   ──────────────────
   $ cloudflared tunnel run muse-eeg-dashboard

   Tunnel akan online. URL akan ditampilkan.


═════════════════════════════════════════════════════════════════════


💡 RECOMMENDATION:

   Untuk testing CEPAT (tidak butuh setup):
   ▶ Gunakan method #1 (temporary URL)
   
   Untuk PRODUCTION (permanen):
   ▶ Gunakan method #2 (permanent tunnel)


═════════════════════════════════════════════════════════════════════


🔥 TROUBLESHOOTING:


   Q: "Dashboard tidak bisa diakses dari tunnel?"
   A: Cek apakah dashboard running:
      $ curl http://localhost:9009
      
      Jika 404, restart dashboard:
      $ docker compose restart


   Q: "URL tunnel tidak muncul?"
   A: Check tunnel status:
      $ cloudflared tunnel info muse-eeg-dashboard
      
      Atau lihat logs:
      $ cloudflared tunnel logs muse-eeg-dashboard


   Q: "Error: 'Unauthorized' saat login?"
   A: Logout dulu kemudian login ulang:
      $ cloudflared logout
      $ cloudflared login


═════════════════════════════════════════════════════════════════════


📱 SETELAH TUNNEL READY:

   ✅ Akses dari browser:
      https://xxxxx.trycloudflare.com
      
   ✅ Akses dari mobile:
      Buka URL yang sama
      
   ✅ Share dengan orang lain:
      Bagikan URL tersebut
      
   ✅ View data:
      - Real-time EEG signals
      - Frequency spectrum
      - Band power analysis
      - Download CSV files


═════════════════════════════════════════════════════════════════════


🎯 RECOMMENDED WORKFLOW:

   Terminal 1 (Dashboard):
   $ docker compose up -d && docker logs -f muse2-dashboard

   Terminal 2 (Tunnel):
   $ cloudflared tunnel --url http://localhost:9009

   Terminal 3 (Data Collection - optional):
   $ python3 muse_connect.py

   Browser:
   Open tunnel URL from Terminal 2 output


═════════════════════════════════════════════════════════════════════


📚 FOR MORE INFO:

   Detailed guide: CLOUDFLARED_SETUP.md
   Dashboard docs: START_HERE.md


═════════════════════════════════════════════════════════════════════


✨ READY? Let's go!

   Run this in new terminal:
   
   $ cloudflared tunnel --url http://localhost:9009


═════════════════════════════════════════════════════════════════════

EOF
