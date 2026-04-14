"""
Script untuk terhubung ke Muse 2 dan mengambil data EEG
Menyimpan data dalam format CSV yang mudah digunakan
"""

import time
import csv
from datetime import datetime
from muselsl import list_muses, stream
import sys
import signal
import os

class MuseDataCollector:
    def __init__(self, output_dir="data"):
        self.output_dir = output_dir
        self.data_file = None
        self.csv_writer = None
        self.start_time = None
        self.is_recording = False
        o
        # Membuat folder untuk menyimpan data jika belum ada
        if not os.path.exists(output_dir):
            os.makedirs(output_dir)
    
    def find_muse_device(self):
        """Mencari device Muse 2 yang tersedia"""
        print("🔍 Mencari Muse 2 Device...")
        muses = list_muses()
        
        if not muses:
            print("❌ Tidak ada Muse device yang ditemukan!")
            print("   Pastikan:")
            print("   1. Muse 2 sudah menyala")
            print("   2. Bluetooth sudah enable")
            print("   3. Muse 2 sudah dipasangkan dengan komputer")
            return None
        
        print(f"✅ Ditemukan {len(muses)} device:")
        for i, muse in enumerate(muses):
            print(f"   {i+1}. {muse}")
        
        if len(muses) == 1:
            selected = muses[0]
        else:
            # Jika banyak device, pilih yang pertama atau prompt user
            selected = muses[0]
            print(f"   Menggunakan: {selected}")
        
        return selected
    
    def create_csv_file(self):
        """Membuat file CSV untuk menyimpan data"""
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        self.data_file = os.path.join(
            self.output_dir, 
            f"muse_data_{timestamp}.csv"
        )
        
        # Header untuk file CSV
        # Muse 2 memiliki 4 channel EEG (TP9, AF7, AF8, TP10)
        headers = [
            'Timestamp',
            'Time_sec',
            'AF7_uV',      # Channel 1
            'AF8_uV',      # Channel 2
            'TP9_uV',      # Channel 3
            'TP10_uV',     # Channel 4
            'Aux_uV'       # Auxiliary channel
        ]
        
        with open(self.data_file, 'w', newline='') as f:
            self.csv_writer = csv.writer(f)
            self.csv_writer.writerow(headers)
        
        print(f"📁 File data: {self.data_file}")
        return self.data_file
    
    def process_data(self, sample):
        """
        Memproses dan menyimpan sample data
        """
        if not self.is_recording:
            return
        
        try:
            # Extract data dari sample
            timestamp = datetime.now()
            elapsed_time = (timestamp - self.start_time).total_seconds()
            
            # Data dari Muse 2 (5 channel: 4 EEG + 1 auxiliary)
            # Format: [ch1, ch2, ch3, ch4, aux]
            row = [
                timestamp.isoformat(),
                f"{elapsed_time:.2f}"
            ]
            
            # Tambahkan channel data
            if len(sample) >= 5:
                for value in sample[:5]:
                    row.append(f"{value:.4f}")
            else:
                # Jika data tidak lengkap, isi dengan 0
                for i in range(5):
                    row.append('0')
            
            # Tulis ke CSV
            with open(self.data_file, 'a', newline='') as f:
                writer = csv.writer(f)
                writer.writerow(row)
                
        except Exception as e:
            print(f"⚠️ Error saat memproses data: {e}")
    
    def start_recording(self, duration=None):
        """
        Mulai merekam data dari Muse 2
        
        Args:
            duration: Durasi recording dalam detik (None = selamanya)
        """
        # Cari device
        muse_device = self.find_muse_device()
        if not muse_device:
            return False
        
        # Buat file CSV
        self.create_csv_file()
        
        self.is_recording = True
        self.start_time = datetime.now()
        
        print(f"\n🎬 Mulai recording dari {muse_device}")
        print(f"   Durasi: {'Unlimited' if duration is None else f'{duration} detik'}")
        print("   Tekan Ctrl+C untuk stop\n")
        
        try:
            # Stream data dari Muse 2
            with stream(user=muse_device):
                end_time = None if duration is None else time.time() + duration
                
                while self.is_recording:
                    if duration is not None and time.time() >= end_time:
                        break
                    
                    time.sleep(0.1)
            
            print("\n✅ Recording selesai!")
            return True
            
        except KeyboardInterrupt:
            print("\n⏹️ Recording dihentikan oleh user")
            return True
        except Exception as e:
            print(f"\n❌ Error: {e}")
            return False
        finally:
            self.is_recording = False


def main():
    """Main function untuk menjalankan collector"""
    print("=" * 50)
    print("   MUSE 2 EEG DATA COLLECTOR")
    print("=" * 50)
    print()
    
    # Buat collector
    collector = MuseDataCollector(output_dir="muse_data")
    
    # Jalankan recording
    # Ubah duration ke None jika ingin record selamanya
    duration = None  # None = unlimited, atau ganti dengan angka dalam detik
    
    success = collector.start_recording(duration=duration)
    
    if success and os.path.exists(collector.data_file):
        print(f"\n📊 Data disimpan di: {collector.data_file}")
        
        # Tampilkan jumlah data yang direkam
        with open(collector.data_file, 'r') as f:
            lines = len(f.readlines()) - 1  # Minus header
        
        print(f"   Total data points: {lines}")
    else:
        print("\n⚠️ Tidak ada data yang disimpan")


if __name__ == "__main__":
    main()
