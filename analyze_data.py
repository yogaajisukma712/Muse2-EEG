"""
Script untuk analisis data Muse 2 yang sudah disimpan
Visualisasi dan analisis statistik
"""

import pandas as pd
import numpy as np
from pathlib import Path
import matplotlib.pyplot as plt
from scipy import signal
import sys


class MuseDataAnalyzer:
    def __init__(self, csv_file):
        self.csv_file = csv_file
        self.df = None
        self.load_data()
    
    def load_data(self):
        """Load data dari CSV file"""
        try:
            self.df = pd.read_csv(self.csv_file)
            print(f"✅ Data loaded: {len(self.df)} data points")
            print(f"   Channels: AF7, AF8, TP9, TP10, Aux")
            return True
        except Exception as e:
            print(f"❌ Error loading data: {e}")
            return False
    
    def show_summary(self):
        """Tampilkan summary statistik data"""
        if self.df is None:
            return
        
        print("\n" + "="*60)
        print("STATISTIK DATA MUSE 2")
        print("="*60)
        
        channels = ['AF7_uV', 'AF8_uV', 'TP9_uV', 'TP10_uV', 'Aux_uV']
        
        for channel in channels:
            if channel in self.df.columns:
                data = self.df[channel]
                print(f"\n{channel}:")
                print(f"   Mean   : {data.mean():>10.4f} µV")
                print(f"   Std Dev: {data.std():>10.4f} µV")
                print(f"   Min    : {data.min():>10.4f} µV")
                print(f"   Max    : {data.max():>10.4f} µV")
    
    def plot_raw_data(self):
        """Plot raw EEG data"""
        if self.df is None:
            return
        
        channels = ['AF7_uV', 'AF8_uV', 'TP9_uV', 'TP10_uV']
        time = self.df['Time_sec']
        
        plt.figure(figsize=(14, 8))
        
        for i, channel in enumerate(channels, 1):
            plt.subplot(2, 2, i)
            plt.plot(time, self.df[channel], linewidth=0.8)
            plt.title(f'Raw EEG - {channel}')
            plt.xlabel('Time (seconds)')
            plt.ylabel('Amplitude (µV)')
            plt.grid(True, alpha=0.3)
        
        plt.tight_layout()
        plt.savefig('muse_raw_data.png', dpi=150, bbox_inches='tight')
        print("\n📊 Plot disimpan: muse_raw_data.png")
        plt.show()
    
    def compute_frequency_spectrum(self, channel='AF7_uV', fs=256):
        """
        Hitung frequency spectrum menggunakan FFT
        
        Args:
            channel: Nama channel untuk analisis
            fs: Sampling frequency (Hz) - Muse 2 biasanya 256 Hz
        """
        if self.df is None:
            return
        
        if channel not in self.df.columns:
            print(f"⚠️ Channel {channel} tidak ditemukan")
            return
        
        data = self.df[channel].values
        
        # FFT
        fft = np.fft.fft(data)
        freq = np.fft.fftfreq(len(data), 1/fs)
        magnitude = np.abs(fft)
        
        # Hanya ambil positive frequencies
        positive_freq = freq[:len(freq)//2]
        positive_mag = magnitude[:len(magnitude)//2]
        
        # Plot
        plt.figure(figsize=(12, 4))
        plt.plot(positive_freq, positive_mag)
        plt.xlim(0, 50)  # 0-50 Hz biasanya cukup untuk EEG
        plt.xlabel('Frequency (Hz)')
        plt.ylabel('Magnitude')
        plt.title(f'Frequency Spectrum - {channel}')
        plt.grid(True, alpha=0.3)
        plt.savefig(f'frequency_spectrum_{channel}.png', dpi=150, bbox_inches='tight')
        print(f"📊 Frequency spectrum disimpan: frequency_spectrum_{channel}.png")
        plt.show()
    
    def compute_band_power(self, channel='AF7_uV', fs=256):
        """
        Hitung power di berbagai frequency bands
        Bands: Delta (0.5-4), Theta (4-8), Alpha (8-12), Beta (12-30), Gamma (30-50)
        """
        if self.df is None:
            return
        
        if channel not in self.df.columns:
            print(f"⚠️ Channel {channel} tidak ditemukan")
            return
        
        data = self.df[channel].values
        
        # Define bands
        bands = {
            'Delta': (0.5, 4),
            'Theta': (4, 8),
            'Alpha': (8, 12),
            'Beta': (12, 30),
            'Gamma': (30, 50)
        }
        
        print(f"\n📈 Band Power Analysis - {channel}:")
        print("-" * 40)
        
        for band_name, (low_freq, high_freq) in bands.items():
            # Bandpass filter
            sos = signal.butter(4, [low_freq, high_freq], 'band', fs=fs, output='sos')
            filtered = signal.sosfilt(sos, data)
            
            # Power (RMS)
            power = np.sqrt(np.mean(filtered**2))
            
            print(f"  {band_name:8} ({low_freq:5.1f}-{high_freq:5.1f} Hz): {power:10.4f} µV²")


def main():
    print("="*60)
    print("   MUSE 2 DATA ANALYZER")
    print("="*60)
    
    # Cari file CSV terbaru di folder muse_data
    data_dir = Path("muse_data")
    
    if not data_dir.exists():
        print("❌ Folder 'muse_data' tidak ditemukan")
        sys.exit(1)
    
    csv_files = list(data_dir.glob("*.csv"))
    
    if not csv_files:
        print("❌ Tidak ada file CSV di folder 'muse_data'")
        sys.exit(1)
    
    # Gunakan file terbaru
    csv_file = max(csv_files, key=lambda p: p.stat().st_mtime)
    
    print(f"\n📂 File: {csv_file}\n")
    
    # Buat analyzer
    analyzer = MuseDataAnalyzer(csv_file)
    
    if analyzer.df is not None:
        # Tampilkan summary
        analyzer.show_summary()
        
        # Plot raw data
        try:
            analyzer.plot_raw_data()
        except Exception as e:
            print(f"⚠️ Error plotting raw data: {e}")
        
        # Analisis frequency spectrum
        print("\n" + "="*60)
        try:
            analyzer.compute_band_power(channel='AF7_uV')
        except Exception as e:
            print(f"⚠️ Error computing band power: {e}")
        
        print("\n✅ Analisis selesai!")


if __name__ == "__main__":
    main()
