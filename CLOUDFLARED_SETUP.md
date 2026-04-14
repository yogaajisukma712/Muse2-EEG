# 🔗 CLOUDFLARED TUNNEL - SETUP GUIDE

**Status:** ✅ Cloudflared running  
**Muse Dashboard:** ✅ Running on port 9009

---

## 📋 MASALAH & SOLUSI

### Masalah:
- Cloudflared tunnel sudah running
- Tapi belum bisa akses dashboard dari public tunnel

### Penyebab:
- Tunnel belum dikonfigurasi untuk route ke port 9009

### Solusi:
3 opsi di bawah

---

## ✅ OPSI 1: SETUP BARU (RECOMMENDED)

### Step 1: Stop Cloudflared Lama
```bash
docker stop cloudflared
docker rm cloudflared
```

### Step 2: Login ke Cloudflare Account
```bash
cloudflared login
# Browser akan buka, sign in dengan Cloudflare account
# Copy domain dari list yang muncul
```

### Step 3: Create Tunnel
```bash
# Create tunnel
cloudflared tunnel create muse-eeg-dashboard

# Output akan berisi tunnel ID
# Copy tunnel ID untuk langkah berikutnya
```

### Step 4: Setup Config
Edit file: `/etc/cloudflared/config.yml`

```yaml
tunnel: muse-eeg-dashboard
credentials-file: /root/.cloudflared/[TUNNEL-ID].json

ingress:
  # Jika punya domain Cloudflare, gunakan ini:
  - hostname: muse.yourdomain.com
    service: http://localhost:9009
  
  # Atau biarkan akses dengan default tunnel URL
  - service: http://localhost:9009

loglevel: info
```

### Step 5: Create DNS Records (Optional)
Jika gunakan domain sendiri:
```
- Type: CNAME
- Name: muse
- Target: [TUNNEL-ID].cfargotunnel.com
```

### Step 6: Start Tunnel
```bash
# Run in foreground (to test)
cloudflared tunnel run muse-eeg-dashboard

# Or run as service
sudo systemctl enable cloudflared
sudo systemctl start cloudflared
```

### Step 7: Get Public URL
```bash
cloudflared tunnel info muse-eeg-dashboard
```

Output akan berisi public URL untuk akses dashboard!

---

## ✅ OPSI 2: DOCKER SETUP

Jalankan Cloudflared dalam Docker:

```bash
docker run -d \
  --name cloudflared-muse \
  --restart unless-stopped \
  -v ~/.cloudflared:/home/nonroot/.cloudflared \
  cloudflare/cloudflared:latest \
  tunnel run muse-eeg-dashboard
```

---

## ✅ OPSI 3: QUICK START (Temporary)

Testing cepat tanpa setup domain:

```bash
# Terminal baru
cloudflared tunnel --url http://localhost:9009

# Output akan berisi temporary URL:
# https://xxxxx.trycloudflare.com
```

URL ini **valid 8 jam** - cukup untuk testing!

---

## 🔐 SECURITY BEST PRACTICES

### 1. Add Authentication
```yaml
tunnel: muse-eeg-dashboard
credentials-file: /root/.cloudflared/[TUNNEL-ID].json

ingress:
  - hostname: muse.yourdomain.com
    service: http://localhost:9009
  - service: http_status:404
```

### 2. Add IP Whitelist
```yaml
ingress:
  - hostname: muse.yourdomain.com
    service: http://localhost:9009
    originRequest:
      access:
        required: true
```

### 3. Enable Cloudflare DDoS Protection
- Go to Cloudflare Dashboard
- Select your domain
- Security → DDoS Protection: ON

---

## 🔍 TROUBLESHOOTING

### Issue 1: "Cannot connect to tunnel"

**Fix:**
```bash
# Check tunnel status
cloudflared tunnel list

# Restart tunnel
docker restart cloudflared-muse

# Check logs
docker logs -f cloudflared-muse
```

### Issue 2: "Invalid credentials"

**Fix:**
```bash
# Re-login
cloudflared login

# Verify credentials file exists
ls -la ~/.cloudflared/
```

### Issue 3: "Page not loading from tunnel"

**Verify:**
1. Dashboard running: `curl http://localhost:9009`
2. Tunnel has correct route to 9009
3. Check config.yml has correct ingress rules

---

## 📊 VERIFY SETUP

### Test Locally:
```bash
curl -v http://localhost:9009
# Should show dashboard HTML
```

### Test Tunnel:
```bash
curl -v https://muse.yourdomain.com
# Should also show dashboard
```

### Check Tunnel Status:
```bash
cloudflared tunnel info muse-eeg-dashboard
# Shows URL, status, credentials
```

---

## 🚀 COMPLETE COMMAND SEQUENCE

```bash
# 1. Stop old cloudflared
docker stop cloudflared

# 2. Login & create tunnel
cloudflared login
cloudflared tunnel create muse-eeg-dashboard

# 3. Run tunnel
cloudflared tunnel run muse-eeg-dashboard

# 4. Get URL
cloudflared tunnel info muse-eeg-dashboard

# 5. Share URL!
```

---

## 📱 ACCESSING DASHBOARD

### Option A: Via Domain
```
https://muse.yourdomain.com
```

### Option B: Via Tunnel URL
```
https://[TUNNEL-ID].cfargotunnel.com
```

### Option C: Temporary URL (8 hours)
```
https://xxxxx.trycloudflare.com
```

---

## 🎯 NEXT STEPS

1. **Choose setup option above** (Opsi 1 recommended)
2. **Run commands** to create tunnel
3. **Copy public URL**
4. **Test from phone/other device**
5. **Share URL safely** with others

---

## 📞 QUICK REFERENCE

```bash
# List tunnels
cloudflared tunnel list

# Get info
cloudflared tunnel info muse-eeg-dashboard

# Check logs
cloudflared tunnel logs muse-eeg-dashboard

# Delete tunnel
cloudflared tunnel delete muse-eeg-dashboard

# Route domain to tunnel
cloudflared route dns muse.yourdomain.com muse-eeg-dashboard

# Unroute
cloudflared route dns --remove muse.yourdomain.com
```

---

**Current Status:**
✅ Dashboard: Running on http://localhost:9009
✅ Cloudflared: Running
⏳ Tunnel Config: Ready to setup

**Next:** Follow Opsi 1 above or let me know which option you prefer!
