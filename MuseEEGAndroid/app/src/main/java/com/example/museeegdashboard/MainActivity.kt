package com.example.museeegdashboard

import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothManager
import android.content.Intent
import android.os.Build
import android.os.Bundle
import android.widget.Button
import android.widget.EditText
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity

class MainActivity : AppCompatActivity() {
    
    private lateinit var bluetoothAdapter: BluetoothAdapter
    private lateinit var serverIpInput: EditText
    private lateinit var connectionStatus: TextView
    
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        
        // Initialize Bluetooth
        val bluetoothManager = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            getSystemService(BluetoothManager::class.java)
        } else {
            null
        }
        
        bluetoothAdapter = bluetoothManager?.adapter ?: BluetoothAdapter.getDefaultAdapter()
        
        // UI Elements
        serverIpInput = findViewById(R.id.server_ip_input)
        connectionStatus = findViewById(R.id.connection_status)
        val connectButton = findViewById<Button>(R.id.connect_button)
        
        serverIpInput.setText("192.168.1.100:9009")
        
        connectButton.setOnClickListener {
            val serverIp = serverIpInput.text.toString()
            if (serverIp.isEmpty()) {
                connectionStatus.text = "Masukkan alamat server"
                return@setOnClickListener
            }
            
            // Navigate to dashboard
            val intent = Intent(this, DashboardActivity::class.java)
            intent.putExtra("SERVER_IP", serverIp)
            startActivity(intent)
        }
        
        // Check Bluetooth status
        updateBluetoothStatus()
    }
    
    private fun updateBluetoothStatus() {
        val status = if (bluetoothAdapter.isEnabled) {
            "Bluetooth: Aktif"
        } else {
            "Bluetooth: Tidak Aktif"
        }
        connectionStatus.text = status
    }
}
