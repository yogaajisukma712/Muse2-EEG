"""
Flask Dashboard untuk Muse 2 EEG Data
Real-time visualization dan analysis
"""

from flask import Flask, render_template, jsonify, request, send_file
from flask_socketio import SocketIO, emit, join_room, leave_room
from pathlib import Path
import pandas as pd
import numpy as np
from scipy import signal
import json
from datetime import datetime
import os
from threading import Lock

app = Flask(__name__)
app.config['DATA_FOLDER'] = 'muse_data'
app.config['SECRET_KEY'] = 'muse-eeg-secret-2024'

# Initialize SocketIO
socketio = SocketIO(app, cors_allowed_origins="*", async_mode='threading')

# Lock untuk thread safety
data_lock = Lock()

# Buat folder jika belum ada
os.makedirs(app.config['DATA_FOLDER'], exist_ok=True)


def get_latest_csv():
    """Dapatkan file CSV terbaru"""
    data_dir = Path(app.config['DATA_FOLDER'])
    csv_files = list(data_dir.glob("*.csv"))
    
    if not csv_files:
        return None
    
    return max(csv_files, key=lambda p: p.stat().st_mtime)


def load_csv_data(csv_file=None):
    """Load data dari CSV"""
    if csv_file is None:
        csv_file = get_latest_csv()
    
    if csv_file is None:
        return None
    
    try:
        df = pd.read_csv(csv_file)
        return df
    except Exception as e:
        print(f"Error loading CSV: {e}")
        return None


@app.route('/')
def index():
    """Halaman utama dashboard"""
    csv_file = get_latest_csv()
    
    if csv_file:
        df = load_csv_data(csv_file)
        if df is not None:
            status = "✅ Data tersedia"
            data_points = len(df)
        else:
            status = "⚠️ Error loading data"
            data_points = 0
    else:
        status = "⚠️ Belum ada data"
        data_points = 0
    
    return render_template('index.html', 
                         status=status, 
                         data_points=data_points,
                         csv_file=str(csv_file) if csv_file else "")


@app.route('/dashboard-android')
def dashboard_android():
    """Dashboard khusus untuk streaming dari Android"""
    return render_template('dashboard_android.html')


@app.route('/api/data')
def api_data():
    """API endpoint untuk mendapatkan data"""
    csv_file = get_latest_csv()
    
    # Return empty data structure if no file available
    if csv_file is None:
        return jsonify({
            'time': [],
            'channels': {
                'AF7_uV': [],
                'AF8_uV': [],
                'TP9_uV': [],
                'TP10_uV': []
            },
            'empty': True
        }), 200
    
    df = load_csv_data(csv_file)
    
    # Return empty data on load error
    if df is None:
        return jsonify({
            'time': [],
            'channels': {
                'AF7_uV': [],
                'AF8_uV': [],
                'TP9_uV': [],
                'TP10_uV': []
            },
            'empty': True
        }), 200
    
    # Limit data (ambil setiap Nth point untuk performance)
    step = max(1, len(df) // 500)  # Max 500 points untuk chart
    df_limited = df.iloc[::step]
    
    channels = ['AF7_uV', 'AF8_uV', 'TP9_uV', 'TP10_uV']
    
    data = {
        'time': df_limited['Time_sec'].tolist(),
        'channels': {},
        'empty': False
    }
    
    for channel in channels:
        if channel in df_limited.columns:
            data['channels'][channel] = df_limited[channel].tolist()
    
    return jsonify(data)


@app.route('/api/statistics')
def api_statistics():
    """API endpoint untuk statistik data"""
    csv_file = get_latest_csv()
    
    # Return empty statistics if no file available
    if csv_file is None:
        empty_stats = {
            'AF7_uV': {'mean': 0, 'std': 0, 'min': 0, 'max': 0, 'median': 0},
            'AF8_uV': {'mean': 0, 'std': 0, 'min': 0, 'max': 0, 'median': 0},
            'TP9_uV': {'mean': 0, 'std': 0, 'min': 0, 'max': 0, 'median': 0},
            'TP10_uV': {'mean': 0, 'std': 0, 'min': 0, 'max': 0, 'median': 0},
            'Aux_uV': {'mean': 0, 'std': 0, 'min': 0, 'max': 0, 'median': 0},
            'empty': True
        }
        return jsonify(empty_stats), 200
    
    df = load_csv_data(csv_file)
    
    # Return empty statistics on load error
    if df is None:
        empty_stats = {
            'AF7_uV': {'mean': 0, 'std': 0, 'min': 0, 'max': 0, 'median': 0},
            'AF8_uV': {'mean': 0, 'std': 0, 'min': 0, 'max': 0, 'median': 0},
            'TP9_uV': {'mean': 0, 'std': 0, 'min': 0, 'max': 0, 'median': 0},
            'TP10_uV': {'mean': 0, 'std': 0, 'min': 0, 'max': 0, 'median': 0},
            'Aux_uV': {'mean': 0, 'std': 0, 'min': 0, 'max': 0, 'median': 0},
            'empty': True
        }
        return jsonify(empty_stats), 200
    
    channels = ['AF7_uV', 'AF8_uV', 'TP9_uV', 'TP10_uV', 'Aux_uV']
    stats = {}
    
    for channel in channels:
        if channel in df.columns:
            data = df[channel]
            stats[channel] = {
                'mean': float(data.mean()),
                'std': float(data.std()),
                'min': float(data.min()),
                'max': float(data.max()),
                'median': float(data.median())
            }
        else:
            stats[channel] = {'mean': 0, 'std': 0, 'min': 0, 'max': 0, 'median': 0}
    
    stats['empty'] = False
    return jsonify(stats)


@app.route('/api/frequency-spectrum')
def api_frequency_spectrum():
    """API endpoint untuk frequency spectrum"""
    csv_file = get_latest_csv()
    channel = request.args.get('channel', 'AF7_uV')
    fs = 256  # Sampling frequency Muse 2
    
    # Return empty spectrum if no file available
    if csv_file is None:
        return jsonify({
            'frequency': [],
            'magnitude': [],
            'channel': channel,
            'empty': True
        }), 200
    
    df = load_csv_data(csv_file)
    
    # Return empty spectrum on load error
    if df is None:
        return jsonify({
            'frequency': [],
            'magnitude': [],
            'channel': channel,
            'empty': True
        }), 200
    
    if channel not in df.columns:
        return jsonify({
            'frequency': [],
            'magnitude': [],
            'channel': channel,
            'empty': True
        }), 200
    
    data = df[channel].values
    
    # FFT
    fft = np.fft.fft(data)
    freq = np.fft.fftfreq(len(data), 1/fs)
    magnitude = np.abs(fft)
    
    # Hanya ambil positive frequencies sampai 50 Hz
    max_freq = 50
    max_idx = int(len(freq) * max_freq / (fs/2))
    
    freq_positive = freq[:max_idx]
    mag_positive = magnitude[:max_idx]
    
    return jsonify({
        'frequency': freq_positive.tolist(),
        'magnitude': mag_positive.tolist(),
        'channel': channel,
        'empty': False
    })


@app.route('/api/band-power')
def api_band_power():
    """API endpoint untuk band power analysis"""
    csv_file = get_latest_csv()
    channel = request.args.get('channel', 'AF7_uV')
    
    # Define bands
    bands = {
        'Delta': (0.5, 4),
        'Theta': (4, 8),
        'Alpha': (8, 12),
        'Beta': (12, 30),
        'Gamma': (30, 50)
    }
    
    # Return empty band power if no file available
    if csv_file is None:
        empty_bands = {band: 0 for band in bands.keys()}
        empty_bands['empty'] = True
        return jsonify(empty_bands), 200
    
    df = load_csv_data(csv_file)
    
    # Return empty band power on load error
    if df is None:
        empty_bands = {band: 0 for band in bands.keys()}
        empty_bands['empty'] = True
        return jsonify(empty_bands), 200
    
    fs = 256
    
    if channel not in df.columns:
        empty_bands = {band: 0 for band in bands.keys()}
        empty_bands['empty'] = True
        return jsonify(empty_bands), 200
    
    data = df[channel].values
    
    band_power = {}
    
    for band_name, (low_freq, high_freq) in bands.items():
        # Bandpass filter
        try:
            sos = signal.butter(4, [low_freq, high_freq], 'band', fs=fs, output='sos')
            filtered = signal.sosfilt(sos, data)
            power = np.sqrt(np.mean(filtered**2))
            band_power[band_name] = float(power)
        except Exception as e:
            band_power[band_name] = 0
    
    band_power['empty'] = False
    return jsonify(band_power)


@app.route('/api/file-list')
def api_file_list():
    """API endpoint untuk list file CSV"""
    data_dir = Path(app.config['DATA_FOLDER'])
    csv_files = sorted(data_dir.glob("*.csv"), 
                      key=lambda p: p.stat().st_mtime, 
                      reverse=True)
    
    files = []
    for f in csv_files[:20]:  # Limit 20 files terbaru
        stat = f.stat()
        files.append({
            'name': f.name,
            'path': str(f),
            'size': stat.st_size,
            'modified': datetime.fromtimestamp(stat.st_mtime).strftime('%Y-%m-%d %H:%M:%S')
        })
    
    return jsonify(files)


@app.route('/api/download/<filename>')
def api_download(filename):
    """Download CSV file"""
    file_path = Path(app.config['DATA_FOLDER']) / filename
    
    if not file_path.exists():
        return jsonify({'error': 'File not found'}), 404
    
    return send_file(file_path, as_attachment=True)


@app.errorhandler(404)
def page_not_found(e):
    """Handle 404 errors"""
    return jsonify({'error': 'Page not found'}), 404


@app.errorhandler(500)
def server_error(e):
    """Handle 500 errors"""
    return jsonify({'error': 'Server error'}), 500


# ============= WEBSOCKET EVENTS =============

@socketio.on('connect', namespace='/dashboard')
def handle_connect():
    """Handle client connection"""
    print(f"📱 Client connected to /dashboard: {request.sid}")
    emit('response', {'data': 'Connected to Flask Dashboard', 'status': 'ok'})


@socketio.on('disconnect', namespace='/dashboard')
def handle_disconnect():
    """Handle client disconnection"""
    print(f"📱 Client disconnected from /dashboard: {request.sid}")


@socketio.on('eeg_data', namespace='/dashboard')
def handle_eeg_data(data):
    """Receive EEG data dari Android app"""
    try:
        with data_lock:
            # Broadcast ke semua connected clients
            emit('eeg_update', {
                'timestamp': data.get('timestamp'),
                'eeg_data': data.get('eeg_data'),
                'source': 'android',
                'device_name': data.get('device_name', 'Muse 2')
            }, broadcast=True, include_self=False, namespace='/dashboard')
            
            print(f"✅ EEG Data received from Android: {len(data.get('eeg_data', []))} channels")
    except Exception as e:
        print(f"❌ Error processing EEG data: {e}")
        emit('error', {'message': str(e)}, namespace='/dashboard')


@socketio.on('status_update', namespace='/dashboard')
def handle_status_update(data):
    """Receive status update dari Android"""
    emit('status', {
        'battery': data.get('battery'),
        'connection': data.get('connection'),
        'signal_quality': data.get('signal_quality'),
        'timestamp': datetime.now().isoformat()
    }, broadcast=True, namespace='/dashboard')
    print(f"📊 Status update: {data}")


# ============= API ENDPOINTS UNTUK ANDROID =============

@app.route('/api/android/register', methods=['POST'])
def android_register():
    """Register Android device"""
    data = request.get_json()
    device_name = data.get('device_name', 'Unknown')
    device_id = data.get('device_id', 'unknown')
    
    print(f"📱 Android device registered: {device_name} ({device_id})")
    
    return jsonify({
        'status': 'registered',
        'message': f'Device {device_name} registered successfully',
        'server_time': datetime.now().isoformat(),
        'server_version': '1.0.0'
    })


@app.route('/api/android/config', methods=['GET'])
def android_config():
    """Get configuration untuk Android app"""
    return jsonify({
        'sampling_rate': 256,
        'channels': ['AF7', 'AF8', 'TP9', 'TP10', 'AUX'],
        'streaming_interval': 100,
        'server_version': '1.0.0',
        'features': ['real_time_stream', 'statistics', 'frequency_analysis']
    })


# ============= APK DOWNLOAD ENDPOINTS =============

@app.route('/download')
def download_page():
    """Halaman download APK"""
    return render_template('download.html')


@app.route('/api/apk/list', methods=['GET'])
def api_apk_list():
    """List semua APK yang tersedia"""
    apk_dir = Path('apk_downloads')
    apk_files = list(apk_dir.glob("*.apk"))
    
    apks = []
    for apk_file in sorted(apk_files, key=lambda p: p.stat().st_mtime, reverse=True):
        stat = apk_file.stat()
        apks.append({
            'name': apk_file.name,
            'size': stat.st_size,
            'size_mb': f"{stat.st_size / (1024*1024):.2f}",
            'modified': datetime.fromtimestamp(stat.st_mtime).isoformat(),
            'download_url': f'/download/apk/{apk_file.name}'
        })
    
    return jsonify({
        'total': len(apks),
        'apks': apks,
        'base_url': request.base_url.rstrip('/')
    })


@app.route('/download/apk/<filename>', methods=['GET'])
def download_apk(filename):
    """Download APK file"""
    # Security: Prevent directory traversal
    if '..' in filename or '/' in filename:
        return jsonify({'error': 'Invalid filename'}), 400
    
    file_path = Path('apk_downloads') / filename
    
    if not file_path.exists() or not file_path.suffix == '.apk':
        return jsonify({'error': 'APK not found'}), 404
    
    try:
        return send_file(
            file_path,
            as_attachment=True,
            download_name=filename,
            mimetype='application/vnd.android.package-archive'
        )
    except Exception as e:
        print(f"Error downloading APK: {e}")
        return jsonify({'error': str(e)}), 500


@app.route('/api/apk/upload', methods=['POST'])
def upload_apk():
    """Upload APK file (untuk development)"""
    if 'file' not in request.files:
        return jsonify({'error': 'No file provided'}), 400
    
    file = request.files['file']
    
    if file.filename == '':
        return jsonify({'error': 'No filename'}), 400
    
    if not file.filename.endswith('.apk'):
        return jsonify({'error': 'Only APK files allowed'}), 400
    
    try:
        # Create apk_downloads folder if not exists
        apk_dir = Path('apk_downloads')
        apk_dir.mkdir(exist_ok=True)
        
        # Save file
        filepath = apk_dir / file.filename
        file.save(str(filepath))
        
        stat = filepath.stat()
        
        return jsonify({
            'status': 'uploaded',
            'filename': file.filename,
            'size': stat.st_size,
            'size_mb': f"{stat.st_size / (1024*1024):.2f}",
            'download_url': f'/download/apk/{file.filename}'
        }), 201
    except Exception as e:
        print(f"Error uploading APK: {e}")
        return jsonify({'error': str(e)}), 500


if __name__ == '__main__':
    # Run dengan WebSocket support
    socketio.run(app, host='0.0.0.0', port=9009, debug=False, allow_unsafe_werkzeug=True)
