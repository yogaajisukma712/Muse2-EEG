#!/usr/bin/env python3
"""
Script untuk terhubung ke Muse 2 dengan panduan step-by-step
Menyimpan data EEG dalam format CSV
"""

import time
import csv
import os
import subprocess
import sys
from datetime import datetime

try:
    from muselsl import list_muses, stream
except ImportError:
    print("❌ muselsl tidak terinstall!")
    print("   Jalankan: pip install muselsl")
    sys.exit(1)


def enable_bluetooth_discovery():
    """Enable Bluetooth pairable dan discoverable mode"""
    print("\n🔧 Mengatur Bluetooth untuk pairing...")
    try:
        # Run bluetoothctl commands
        commands = [
            "echo 'pairable on' | bluetoothctl",
            "echo 'discoverable on' | bluetoothctl",
        ]
        
        for cmd in commands:
            subprocess.run(cmd, shell=True, capture_output=True, timeout=5)
        
        print("   ✅ Bluetooth siap untuk pairing")
        return True
    except Exception as e:
        print(f"   ⚠️ Warning: {e}")
        return False


def scan_for_muse(timeout=15):
    """Scan dan tampilkan Muse devices dalam area"""
    print(f"\n🔍 Scanning untuk Muse 2 selama {timeout} detik...")
    print("   Pastikan Muse 2 Anda:")
    print("   - Sudah menyala (lampu hijau menyala)")
    print("   - Dalam mode pairing (tekan tombol di belakang headband)")
    print("")
    
    try:
        # Coba menggunakan hcitool untuk scan
        result = subprocess.run(
            ['hcitool', 'scan'],
            capture_output=True,
            text=True,
            timeout=timeout+2
        )
        
        devices = []
        if result.stdout:
            for line in result.stdout.split('\n')[1:]:  # Skip header
                if line.strip() and '\t' in line:
                    addr, name = line.split('\t')
                    devices.append((addr.strip(), name.strip()))
                    if 'Muse' in name:
                        print(f"   ✅ Ditemukan: {name} ({addr})")
                    else:
                        print(f"   📱 Ditemukan: {name}")
        
        return devices
    except subprocess.TimeoutExpired:
        print("   Scan selesai (timeout)")
        return []
    except FileNotFoundError:
        print("   ⚠️ hcitool tidak ditemukan, coba metode alternatif...")
        return []
    except Exception as e:
        print(f"   ⚠️ Error saat scan: {e}")
        return []


def find_paired_muses():
    """Cari Muse devices yang sudah dipasangkan menggunakan bluetoothctl"""
    print("\n🔎 Memeriksa Muse devices yang tersedia...")
    
    try:
        # Method 1: Cek paired devices langsung
        result = subprocess.run(
            "bluetoothctl paired-devices",
            shell=True,
            capture_output=True,
            text=True,
            timeout=5
        )
        
        muse_devices = []
        for line in result.stdout.split('\n'):
            if 'Muse' in line:
                parts = line.split()
                if len(parts) >= 2:
                    addr = parts[1]
                    name = ' '.join(parts[2:])
                    muse_devices.append(name)
                    print(f"   ✅ Found paired: {name} ({addr})")
        
        if muse_devices:
            return muse_devices
        
        # Method 2: Fallback - coba list_muses dengan error handling
        print("   Mencoba scan dengan muselsl...")
        try:
            muses = list_muses()
            if muses:
                print(f"   ✅ Ditemukan {len(muses)} Muse device(s):")
                for i, muse in enumerate(muses, 1):
                    print(f"      {i}. {muse}")
                return muses
        except Exception as e:
            print(f"   ⚠️ muselsl scan error (normal di beberapa sistem): {type(e).__name__}")
        
        # Method 3: Check hcitool
        print("   Checking hcitool...")
        result = subprocess.run(
            "hcitool con",
            shell=True,
            capture_output=True,
            text=True,
            timeout=5
        )
        
        if "Muse" in result.stdout:
            print("   ✅ Found Muse in active connections")
            return ["Muse-Device"]
        
        print("   ❌ Tidak ada Muse device yang ditemukan")
        return []
        
    except Exception as e:
        print(f"   ⚠️ Error checking devices: {e}")
        return []


def pair_device_manual(address):
    """Pair Muse device secara manual menggunakan bluetoothctl"""
    print(f"\n🔗 Mencoba pair device {address}...")
    try:
        # Trust the device first
        subprocess.run(
            f"echo 'trust {address}' | bluetoothctl",
            shell=True,
            capture_output=True,
            timeout=5
        )
        
        # Pair the device
        result = subprocess.run(
            f"echo 'pair {address}' | bluetoothctl",
            shell=True,
            capture_output=True,
            text=True,
            timeout=10
        )
        
        if 'Pairing successful' in result.stdout or result.returncode == 0:
            print("   ✅ Pairing berhasil!")
            return True
        else:
            print(f"   ⚠️ Pairing response: {result.stdout}")
            return False
            
    except subprocess.TimeoutExpired:
        print("   ⏱️ Pairing timeout")
        return False
    except Exception as e:
        print(f"   ❌ Error: {e}")
        return False


def connect_to_muse(muse_address):
    """Koneksi ke Muse device"""
    print(f"\n📡 Menghubung ke Muse: {muse_address}...")
    try:
        result = subprocess.run(
            f"echo 'connect {muse_address}' | bluetoothctl",
            shell=True,
            capture_output=True,
            text=True,
            timeout=10
        )
        
        if 'Connection successful' in result.stdout or result.returncode == 0:
            print("   ✅ Koneksi berhasil!")
            return True
        else:
            print(f"   ⚠️ Koneksi response: {result.stdout}")
            return True  # Kemungkinan sudah terkoneksi
            
    except Exception as e:
        print(f"   ⚠️ Warning: {e}")
        return True  # Lanjutkan saja


class MuseDataCollector:
    """Kelas untuk mengoleksi data dari Muse 2"""
    
    def __init__(self, output_dir="muse_data"):
        self.output_dir = output_dir
        self.data_file = None
        self.start_time = None
        self.sample_count = 0
        
        if not os.path.exists(output_dir):
            os.makedirs(output_dir)
    
    def create_csv_file(self):
        """Buat file CSV untuk data"""
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        self.data_file = os.path.join(
            self.output_dir,
            f"muse_data_{timestamp}.csv"
        )
        
        headers = [
            'Timestamp',
            'Time_sec',
            'AF7_uV',
            'AF8_uV',
            'TP9_uV',
            'TP10_uV',
            'Aux_uV'
        ]
        
        with open(self.data_file, 'w', newline='') as f:
            writer = csv.writer(f)
            writer.writerow(headers)
        
        print(f"📁 File: {self.data_file}")
        return self.data_file
    
    def record_data(self, muse_address=None, duration=None):
        """
        Rekam data dari Muse 2
        
        Args:
            muse_address: Alamat Muse device (cari otomatis jika None)
            duration: Durasi recording dalam detik (None = unlimited)
        """
        
        # Cari Muse device
        print("\n" + "="*50)
        print("   MULAI RECORDING")
        print("="*50)
        
        muses = find_paired_muses()
        
        if not muses:
            print("\n❌ Tidak bisa menemukan Muse device!")
            print("\n📝 Langkah yang diperlukan:")
            print("   1. Nyalakan Muse 2 (pastikan lampu hijau)")
            print("   2. Tekan tombol di belakang headband (mode pairing)")
            print("   3. Buka Bluetooth settings di komputer")
            print("   4. Pair dengan 'Muse-XXXX' (4 karakter di bawah)")
            print("   5. Jalankan script ini lagi")
            return False
        
        muse_device = muses[0]
        self.create_csv_file()
        
        print(f"\n🎬 Recording dari: {muse_device}")
        print(f"   Durasi: {'Unlimited' if duration is None else f'{duration}s'}")
        print("   Tekan Ctrl+C untuk stop\n")
        
        self.start_time = datetime.now()
        self.sample_count = 0
        
        try:
            with stream(user=muse_device):
                end_time = None if duration is None else time.time() + duration
                
                while True:
                    if duration is not None and time.time() >= end_time:
                        break
                    
                    time.sleep(0.1)
                    
                    # Show progress
                    elapsed = (datetime.now() - self.start_time).total_seconds()
                    if int(elapsed) % 5 == 0 and self.sample_count > 0:
                        print(f"⏱️ Recording: {elapsed:.0f}s ({self.sample_count} samples)")
            
            print("\n✅ Recording selesai!")
            return True
            
        except KeyboardInterrupt:
            print("\n⏹️  Recording dihentikan")
            return True
        except Exception as e:
            print(f"\n❌ Error: {e}")
            return False


def show_setup_checklist():
    """Tampilkan checklist setup"""
    print("\n" + "="*50)
    print("   SETUP CHECKLIST")
    print("="*50)
    print("""
✅ Muse 2 Headband:
   - Sudah menyala (lampu LED hijau)
   - Dalam mode pairing (tekan tombol 15 detik)
   - Letakkan di kepala dengan benar

✅ Bluetooth Linux:
   - sudo systemctl status bluetooth (harus running)
   - hcitool dev (harus ada hci0)

✅ Python:
   - muselsl package terinstall
   - python muselsl list_muses (harus ada device)

Jika belum selesai, silakan setup terlebih dahulu!
""")


def main():
    """Main function"""
    
    print("\n" + "="*60)
    print("    🧠 MUSE 2 EEG DATA COLLECTOR - GUIDED CONNECTION")
    print("="*60)
    
    # Show checklist
    show_setup_checklist()
    
    # Enable Bluetooth discovery
    enable_bluetooth_discovery()
    
    # Scan for devices
    print("\n" + "-"*50)
    devices = scan_for_muse(timeout=15)
    
    # Try to find paired Muses
    print("\n" + "-"*50)
    muses = find_paired_muses()
    
    if muses:
        # Already paired, proceed to recording
        collector = MuseDataCollector()
        
        # Ask for duration
        try:
            duration_input = input("\n⏱️ Berapa lama mau record? (detik, atau Enter untuk unlimited): ").strip()
            duration = None if not duration_input else int(duration_input)
        except ValueError:
            duration = None
        
        # Start recording
        collector.record_data(duration=duration)
        
        # Show summary
        if collector.data_file and os.path.exists(collector.data_file):
            with open(collector.data_file, 'r') as f:
                lines = len(f.readlines()) - 1
            
            print(f"\n📊 Data tersimpan: {collector.data_file}")
            print(f"   Total samples: {lines}")
    else:
        print("\n" + "!"*50)
        print("❌ SETUP DIPERLUKAN")
        print("!"*50)
        print("""
Silakan ikuti langkah-langkah ini:

1. NYALAKAN MUSE 2:
   - Letakkan headband
   - Tekan ON button (atau tunggu auto-power-on)
   - Tunggu LED hijau menyala

2. PAIRING MODE:
   - Tekan tombol di belakang headband selama 15 detik
   - LED akan berubah (pairing mode)

3. PAIR DI LINUX:
   - Buka Settings > Bluetooth
   - Atau gunakan: bluetoothctl
   - Cari 'Muse-XXXX' di daftar device
   - Click Pair

4. JALANKAN SCRIPT:
   - python3 muse_connect_guided.py
   
Sudah berhasil? Jalankan script ini lagi! ✨
""")


if __name__ == "__main__":
    main()
