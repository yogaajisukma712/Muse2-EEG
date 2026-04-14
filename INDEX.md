# 🧠 MUSE 2 EEG DATA DASHBOARD - MASTER INDEX

## 📌 QUICK LINKS

- **👉 START HERE:** [START_HERE.md](./START_HERE.md) - Quick start guide
- **📖 Full Setup:** [SETUP_SUMMARY.md](./SETUP_SUMMARY.md) - Comprehensive setup
- **🐳 Docker Info:** [DOCKER_SETUP.md](./DOCKER_SETUP.md) - Docker details
- **⚙️ General Info:** [README.md](./README.md) - General documentation

---

## 🚀 FASTEST WAY TO START (1 minute!)

```bash
cd "/home/ubuntu/Documents/Penelitian/EEG Muse"
docker compose up
# or
docker-compose up
```

Open: **http://localhost:9009**

Done! 🎉

---

## 📦 WHAT'S INCLUDED

### 🔹 Core Applications

| File | Purpose |
|------|---------|
| **app.py** | Flask web dashboard |
| **muse_connect.py** | Collect data from Muse 2 device |
| **analyze_data.py** | Analyze collected data |

### 🔹 Docker Files

| File | Purpose |
|------|---------|
| **Dockerfile** | Container configuration |
| **docker-compose.yml** | Multi-container orchestration |
| **requirements-docker.txt** | Python dependencies for Docker |

### 🔹 Web Interface

| File | Purpose |
|------|---------|
| **templates/base.html** | Base HTML template |
| **templates/index.html** | Dashboard UI |

### 🔹 Documentation

| File | Purpose |
|------|---------|
| **START_HERE.md** | Quick start guide ⭐ |
| **SETUP_SUMMARY.md** | Complete setup guide |
| **DOCKER_SETUP.md** | Docker detailed guide |
| **README.md** | General information |
| **INDEX.md** | This file |

### 🔹 Execution Scripts

| File | Purpose |
|------|---------|
| **run_dashboard.sh** | Interactive launcher |
| **quick_start.sh** | Fast setup script |

---

## 🎯 3 WAYS TO RUN

### ✅ Method 1: Docker Compose (RECOMMENDED)

```bash
cd "/home/ubuntu/Documents/Penelitian/EEG Muse"
docker compose up
```

**Pros:**
- ✅ Easiest
- ✅ Latest Docker recommendation
- ✅ Auto-manages containers

**Cons:**
- None! 

---

### ✅ Method 2: Docker Compose Legacy

```bash
cd "/home/ubuntu/Documents/Penelitian/EEG Muse"
docker-compose up
```

**Same as Method 1 but uses older command**

---

### ✅ Method 3: Manual Docker

```bash
cd "/home/ubuntu/Documents/Penelitian/EEG Muse"
docker run -p 9009:9009 \
  -v $(pwd)/muse_data:/app/muse_data \
  muse2-dashboard
```

**Pros:**
- More control
- Direct container management

---

### ✅ Method 4: Local Python

```bash
cd "/home/ubuntu/Documents/Penelitian/EEG Muse"
pip install -r requirements-docker.txt
python3 app.py
```

**Pros:**
- No Docker needed
- Direct Python execution

**Cons:**
- Need to install dependencies

---

## 📊 DASHBOARD FEATURES

Once running at **http://localhost:9009**:

### 1. Raw EEG Signals
- Display 4 EEG channels in real-time
- Interactive chart with zoom/pan
- Channel selection dropdown
- Manual refresh button

### 2. Frequency Spectrum
- FFT analysis of selected channel
- Range: 0-50 Hz
- Identifies dominant frequencies

### 3. Band Power Analysis
- 5 frequency bands:
  - 🔵 Delta (0.5-4 Hz) - Sleep
  - 🟢 Theta (4-8 Hz) - Meditation
  - 🟡 Alpha (8-12 Hz) - Relaxation
  - 🟠 Beta (12-30 Hz) - Concentration
  - 🔴 Gamma (30-50 Hz) - High cognition

### 4. Statistics
- Mean, Standard Deviation
- Min, Max, Median
- Per-channel statistics
- Tabbed interface

### 5. File Management
- List all CSV data files
- Download directly
- Shows file size & date
- Latest file highlighted

### 6. Auto-Refresh
- Updates every 5 seconds
- Manual refresh anytime
- Real-time data sync

---

## 🔄 TYPICAL WORKFLOW

### Step 1: Prepare Hardware
```
✅ Muse 2 headband ready
✅ Charged/batteries OK
✅ Bluetooth enabled on computer
✅ Device paired
```

### Step 2: Start Dashboard
```bash
docker compose up
# Wait for: "Running on http://0.0.0.0:9009"
```

### Step 3: Collect Data (New Terminal)
```bash
python3 muse_connect.py
# Recording for 30+ seconds
# Tekan Ctrl+C untuk stop
```

### Step 4: View Dashboard
```
Open: http://localhost:9009
```

### Step 5: Analyze Results
- View raw signals
- Check frequency spectrum
- Review band power
- Download CSV if needed

### Step 6 (Optional): Deep Analysis
```bash
python3 analyze_data.py
# Generates PNG plots
```

---

## 📁 DATA STORAGE

All collected data saved in:
```
/home/ubuntu/Documents/Penelitian/EEG Muse/muse_data/
```

File naming format:
```
muse_data_YYYYMMDD_HHMMSS.csv
```

Example:
```
muse_data_20240413_103045.csv
muse_data_20240413_110230.csv
```

### CSV Format

```csv
Timestamp,Time_sec,AF7_uV,AF8_uV,TP9_uV,TP10_uV,Aux_uV
2024-04-13T10:30:45.123,0.00,-12.5678,15.4321,-8.9012,11.2345,-5.6789
2024-04-13T10:30:45.124,0.01,-12.5676,15.4323,-8.9010,11.2347,-5.6787
```

---

## 🌐 ACCESSING DASHBOARD

### Local Access
```
http://localhost:9009
```

### Remote Access (Multi-device)

**Find your IP:**
```bash
hostname -I
# Output: 192.168.1.100
```

**Access from other device:**
```
http://192.168.1.100:9009
```

**Requirements:**
- Same network as host
- Firewall allows port 9009
- Container is running

---

## 🐛 COMMON ISSUES & FIXES

### Issue: Port 9009 Already in Use

**Check:**
```bash
lsof -i :9009
```

**Fix Option 1:** Use different port in `docker-compose.yml`
```yaml
ports:
  - "9010:9009"  # Change first number
```

**Fix Option 2:** Kill existing process
```bash
sudo kill -9 <PID>
```

---

### Issue: Docker Image Not Found

**Fix:**
```bash
docker build -t muse2-dashboard .
```

---

### Issue: No Data in Dashboard

**Check 1:** Is data being collected?
```bash
ls muse_data/
# Should show CSV files
```

**Fix 1:** Collect data
```bash
python3 muse_connect.py
# Wait 30+ seconds
```

**Check 2:** Is CSV file readable?
```bash
head -5 muse_data/muse_data_*.csv
```

**Fix 2:** Refresh dashboard (F5)

---

### Issue: Can't connect to Muse device

**Check:**
1. Muse 2 powered on?
2. Bluetooth enabled?
3. Device paired in system?

**Fix:**
1. Pair device in Bluetooth settings
2. Restart Muse 2
3. Run: `python3 muse_connect.py` to test

---

## 📚 DOCUMENTATION HIERARCHY

```
INDEX.md (You are here)
├── START_HERE.md ← Quick start
├── SETUP_SUMMARY.md ← Full walkthrough
├── DOCKER_SETUP.md ← Docker details
└── README.md ← General info
```

**Choose based on needs:**
- 🚀 **Quick:** START_HERE.md
- 📖 **Complete:** SETUP_SUMMARY.md
- 🐳 **Docker:** DOCKER_SETUP.md
- ℹ️ **General:** README.md

---

## 🔧 ADVANCED CONFIGURATION

### Change Dashboard Port

Edit `docker-compose.yml`:
```yaml
services:
  muse-dashboard:
    ports:
      - "8080:9009"  # Access at :8080
```

### Change Refresh Rate

Edit `templates/index.html`:
```javascript
const REFRESH_INTERVAL = 5000;  // milliseconds
// Change to 3000 for 3 seconds
```

### Disable Auto-Refresh

Edit `templates/index.html`:
```javascript
const AUTO_REFRESH = false;
```

### Add Custom Analysis

Create new file in project root:
```bash
# my_analysis.py
```

Then import in app.py and create new route.

---

## 📊 MUSE 2 SPECIFICATIONS

| Spec | Value |
|------|-------|
| **Channels** | 4 EEG + 1 Aux |
| **Sampling Rate** | 256 Hz |
| **EEG Electrodes** | AF7, AF8, TP9, TP10 |
| **Resolution** | 12-bit |
| **Range** | ±8192 µV |
| **Bandwidth** | 0.5-100 Hz |

### Electrode Placement

```
       AF7 ─── AF8
        ↑        ↑
      FOREHEAD

       TP9 ─── TP10
        ↑        ↑
      TEMPORAL
```

---

## 🎓 FREQUENCY BANDS REFERENCE

| Band | Hz | State | Activity |
|------|----|----|---------|
| **Delta** | 0.5-4 | Deep sleep | Unconscious |
| **Theta** | 4-8 | Drowsy | Meditation |
| **Alpha** | 8-12 | Relaxed | Eyes closed |
| **Beta** | 12-30 | Alert | Concentration |
| **Gamma** | 30-50 | Active | Problem solving |

---

## 💡 TIPS & TRICKS

### Tip 1: Recording Duration
Edit line in `muse_connect.py`:
```python
duration = None  # Unlimited
# or
duration = 300   # 5 minutes
```

### Tip 2: Queue Multiple Analyses
Keep dashboard open while
analyzing previous data:
```bash
# Terminal 1: Dashboard
docker compose up

# Terminal 2: Old data analysis
python3 analyze_data.py

# Terminal 3: New data collection
python3 muse_connect.py
```

### Tip 3: Batch Process Multiple Files

Create `batch_analyze.py`:
```python
from pathlib import Path
import analyze_data

for csv_file in Path("muse_data").glob("*.csv"):
    analyzer = analyze_data.MuseDataAnalyzer(csv_file)
    analyzer.show_summary()
```

---

## 🚀 QUICK COMMANDS CHEAT SHEET

```bash
# Start dashboard (Docker Compose)
docker compose up

# Start dashboard (old Docker)
docker-compose up

# Start in background
docker compose up -d

# View logs
docker compose logs -f

# Stop container
docker compose stop

# Restart
docker compose restart

# Remove container
docker compose down

# Collect data
python3 muse_connect.py

# Analyse data
python3 analyze_data.py

# Check data
head -10 muse_data/muse_data_*.csv

# Download all data
tar czf muse_data.tar.gz muse_data/
```

---

## 📞 SUPPORT RESOURCES

### Online Resources
- Muse 2 Specs: https://choosemuse.com/
- muselsl Library: https://github.com/alexandrebarachant/muse-lsl
- Flask Documentation: https://flask.palletsprojects.com/
- Docker Documentation: https://docs.docker.com/

### Local Files
- [DOCKER_SETUP.md](./DOCKER_SETUP.md) - Docker help
- [README.md](./README.md) - General help
- [Code comments](./app.py) - In code documentation

---

## ✅ CHECKLIST BEFORE STARTING

- [ ] Muse 2 headband available
- [ ] Bluetooth enabled on computer
- [ ] Docker installed (`docker --version`)
- [ ] Docker running (`docker ps` works)
- [ ] Port 9009 available (`lsof -i :9009` is empty)
- [ ] Read START_HERE.md
- [ ] All files downloaded

---

## 🎯 NEXT STEPS

### 👉 IMMEDIATE
1. Read [START_HERE.md](./START_HERE.md)
2. Run `docker compose up`
3. Open http://localhost:9009

### 📖 LATER
- Run `python3 muse_connect.py`
- View data in dashboard
- Download CSV files
- Run `python3 analyze_data.py`

### 🔬 ADVANCED
- Modify Flask app for custom analysis
- Create custom visualization
- Deploy to cloud
- Implement real-time processing

---

## 🏆 PROJECT STRUCTURE

```
Muse 2 EEG Dashboard/
│
├─ Core Applications
│  ├─ app.py (Flask dashboard)
│  ├─ muse_connect.py (data collector)
│  └─ analyze_data.py (analyzer)
│
├─ Docker Setup
│  ├─ Dockerfile
│  ├─ docker-compose.yml
│  └─ requirements-docker.txt
│
├─ Web UI
│  └─ templates/
│     ├─ base.html
│     └─ index.html
│
├─ Data
│  └─ muse_data/
│     └─ [CSV files here]
│
└─ Documentation
   ├─ INDEX.md (this file)
   ├─ START_HERE.md ⭐
   ├─ SETUP_SUMMARY.md
   ├─ DOCKER_SETUP.md
   └─ README.md
```

---

## 📈 PROGRESS TRACKING

✅ Analysis Tools Created
✅ Data Collection Script Ready
✅ Flask Dashboard Built
✅ Docker Image Built
✅ Documentation Complete
✅ Ready to Use!

---

## 🎉 YOU'RE READY!

Everything is set up and ready to go.

**Next step:** Open [START_HERE.md](./START_HERE.md)

Or run immediately:
```bash
docker compose up
```

Then visit: **http://localhost:9009**

---

**Happy EEG Analysis! 🧠📊**

*Muse 2 Dashboard v1.0*  
*Created: April 2024*  
*All files located in: /home/ubuntu/Documents/Penelitian/EEG Muse*
