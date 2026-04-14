package com.example.museeegdashboard

import android.Manifest
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import android.os.Bundle
import android.util.Log
import android.widget.Button
import android.widget.EditText
import android.widget.TextView
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import com.example.museeegdashboard.service.MuseDataService

class MainActivity : AppCompatActivity() {

    private val TAG = "MainActivity"
    private val PERMISSION_REQUEST_CODE = 101

    private lateinit var serverUrlEditText: EditText
    private lateinit var connectButton: Button
    private lateinit var statusTextView: TextView
    private lateinit var dashboardButton: Button

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        // Initialize views
        serverUrlEditText = findViewById(R.id.serverUrlEditText)
        connectButton = findViewById(R.id.connectButton)
        statusTextView = findViewById(R.id.statusTextView)
        dashboardButton = findViewById(R.id.dashboardButton)

        // Load preferences
        val sharedPref = getSharedPreferences("muse_eeg_prefs", MODE_PRIVATE)
        val savedUrl = sharedPref.getString("server_url", "http://192.168.1.100:9009")
        serverUrlEditText.setText(savedUrl)

        // Request permissions
        requestNecessaryPermissions()

        // Set up event listeners
        connectButton.setOnClickListener {
            val serverUrl = serverUrlEditText.text.toString()
            if (serverUrl.isEmpty()) {
                Toast.makeText(this, "Please enter server URL", Toast.LENGTH_SHORT).show()
                return@setOnClickListener
            }

            // Save server URL
            sharedPref.edit().putString("server_url", serverUrl).apply()

            // Start MuseDataService
            val intent = Intent(this, MuseDataService::class.java)
            intent.putExtra("server_url", serverUrl)
            startService(intent)

            statusTextView.text = "🔄 Connecting to Muse 2..."
            connectButton.isEnabled = false
        }

        dashboardButton.setOnClickListener {
            val intent = Intent(this, DashboardActivity::class.java)
            startActivity(intent)
        }
    }

    private fun requestNecessaryPermissions() {
        val permissions = mutableListOf(
            Manifest.permission.BLUETOOTH,
            Manifest.permission.BLUETOOTH_ADMIN,
            Manifest.permission.INTERNET,
            Manifest.permission.ACCESS_FINE_LOCATION,
            Manifest.permission.ACCESS_COARSE_LOCATION
        )

        // Add Android 12+ permissions
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            permissions.add(Manifest.permission.BLUETOOTH_SCAN)
            permissions.add(Manifest.permission.BLUETOOTH_CONNECT)
        }

        val permissionsToRequest = permissions.filter {
            ContextCompat.checkSelfPermission(this, it) != PackageManager.PERMISSION_GRANTED
        }

        if (permissionsToRequest.isNotEmpty()) {
            ActivityCompat.requestPermissions(
                this,
                permissionsToRequest.toTypedArray(),
                PERMISSION_REQUEST_CODE
            )
        }
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)

        if (requestCode == PERMISSION_REQUEST_CODE) {
            val allGranted = grantResults.all { it == PackageManager.PERMISSION_GRANTED }
            if (allGranted) {
                statusTextView.text = "✅ All permissions granted"
                Toast.makeText(this, "Permissions granted", Toast.LENGTH_SHORT).show()
            } else {
                statusTextView.text = "❌ Some permissions denied"
                Toast.makeText(this, "Some permissions were denied", Toast.LENGTH_SHORT).show()
            }
        }
    }
}
