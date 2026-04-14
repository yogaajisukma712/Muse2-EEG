package com.example.museeegdashboard.service

import android.app.Service
import android.content.Intent
import android.os.Binder
import android.os.Build
import android.os.Handler
import android.os.IBinder
import android.os.Looper
import android.util.Log
import com.choosemuse.libmuse.ConnectionListener
import com.choosemuse.libmuse.Muse
import com.choosemuse.libmuse.MuseConnectionPacket
import com.choosemuse.libmuse.MuseDataListener
import com.choosemuse.libmuse.MuseDataPacket
import com.choosemuse.libmuse.MuseDataPacketType
import com.choosemuse.libmuse.MuseManager
import com.google.gson.Gson
import okhttp3.Call
import okhttp3.Callback
import okhttp3.MediaType
import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.RequestBody
import okhttp3.Response
import java.io.IOException
import java.util.concurrent.TimeUnit

class MuseDataService : Service() {

    private val TAG = "MuseDataService"
    private val binder = LocalBinder()

    private lateinit var museManager: MuseManager
    private var muse: Muse? = null
    private val handler = Handler(Looper.getMainLooper())
    private val gson = Gson()
    private val httpClient = OkHttpClient.Builder()
        .connectTimeout(10, TimeUnit.SECONDS)
        .writeTimeout(10, TimeUnit.SECONDS)
        .readTimeout(10, TimeUnit.SECONDS)
        .build()

    private var serverUrl = "http://192.168.1.100:9009"
    private var isConnected = false
    private var streamingInit = false

    inner class LocalBinder : Binder() {
        fun getService(): MuseDataService = this@MuseDataService
    }

    override fun onCreate() {
        super.onCreate()
        Log.d(TAG, "Service onCreate()")
        
        // Initialize Muse Manager
        museManager = MuseManager.getInstance()
        museManager.setContext(applicationContext)
        
        // Register for Muse connections
        museManager.setMuseListener(museListener)
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        Log.d(TAG, "Service onStartCommand()")

        // Get server URL from intent
        intent?.let {
            serverUrl = it.getStringExtra("server_url") ?: "http://192.168.1.100:9009"
        }

        // Register Android device
        registerDevice()

        // Start discovering Muse devices
        startDiscovery()

        return START_STICKY
    }

    override fun onBind(intent: Intent?): IBinder {
        return binder
    }

    private fun registerDevice() {
        val deviceData = mapOf(
            "device_name" to "Muse-Android",
            "device_id" to android.os.Build.SERIAL,
            "platform" to "Android",
            "android_version" to Build.VERSION.RELEASE
        )

        val json = gson.toJson(deviceData)
        val request = Request.Builder()
            .url("$serverUrl/api/android/register")
            .post(RequestBody.create(MediaType.parse("application/json"), json))
            .build()

        httpClient.newCall(request).enqueue(object : Callback {
            override fun onFailure(call: Call, e: IOException) {
                Log.e(TAG, "Registration failed: ${e.message}")
            }

            override fun onResponse(call: Call, response: Response) {
                Log.d(TAG, "Device registered successfully")
            }
        })
    }

    private fun startDiscovery() {
        Log.d(TAG, "Starting Muse discovery...")
        museManager.startListeningForMuseConnections()
    }

    private val museListener = object : MuseManager.MuseListener {
        override fun museListChanged() {
            Log.d(TAG, "Muse list changed")
            val muses = museManager.muses
            Log.d(TAG, "Found ${muses.size} Muse devices")

            if (muses.isNotEmpty()) {
                val muse = muses[0]
                Log.d(TAG, "Connecting to: ${muse.name}")
                connectToMuse(muse)
            }
        }
    }

    private fun connectToMuse(muse: Muse) {
        this.muse = muse

        muse.registerConnectionListener(museConListener)
        muse.registerDataListener(museDataListener, MuseDataPacketType.EEG)
        muse.registerDataListener(museDataListener, MuseDataPacketType.BATTERY)

        muse.runAsynchronously()
    }

    private val museConListener = object : ConnectionListener {
        override fun museListChanged() {}

        override fun connectionStateChanged(muse: Muse?, state: Muse.ConnectionState?) {
            Log.d(TAG, "Connection state: $state")

            when (state) {
                Muse.ConnectionState.CONNECTED -> {
                    isConnected = true
                    Log.d(TAG, "✅ Connected to Muse 2")
                    sendStatusUpdate("connected")
                }
                Muse.ConnectionState.DISCONNECTED -> {
                    isConnected = false
                    streamingInit = false
                    Log.d(TAG, "❌ Disconnected from Muse 2")
                    sendStatusUpdate("disconnected")
                }
                else -> {}
            }
        }
    }

    private val museDataListener = object : MuseDataListener {
        override fun receiveMuseDataPacket(packet: MuseDataPacket?) {
            packet?.let {
                when (it.packetType()) {
                    MuseDataPacketType.EEG -> {
                        if (!streamingInit) {
                            streamingInit = true
                            Log.d(TAG, "EEG streaming started")
                        }
                        handleEEGData(it)
                    }
                    MuseDataPacketType.BATTERY -> {
                        handleBatteryData(it)
                    }
                    else -> {}
                }
            }
        }

        override fun receiveMuseArtifactPacket(packet: MuseDataPacket?) {}
    }

    private fun handleEEGData(packet: MuseDataPacket) {
        val eegValues = packet.eegChannelData.map { it.toDouble() }

        val data = mapOf(
            "timestamp" to System.currentTimeMillis(),
            "eeg_data" to eegValues,
            "device_name" to (muse?.name ?: "Unknown"),
            "channels" to listOf("AF7", "AF8", "TP9", "TP10", "AUX")
        )

        sendDataToServer(data)
    }

    private fun handleBatteryData(packet: MuseDataPacket) {
        val battery = packet.eegChannelData.getOrNull(0)?.toInt() ?: 0
        val signalQuality = packet.eegChannelData.getOrNull(1)?.toInt() ?: 0

        Log.d(TAG, "Battery: $battery%, Signal: $signalQuality")
    }

    private fun sendDataToServer(data: Map<String, Any>) {
        val json = gson.toJson(data)

        val request = Request.Builder()
            .url("$serverUrl/api/eeg")
            .post(RequestBody.create(MediaType.parse("application/json"), json))
            .build()

        httpClient.newCall(request).enqueue(object : Callback {
            override fun onFailure(call: Call, e: IOException) {
                Log.e(TAG, "Send data failed: ${e.message}")
            }

            override fun onResponse(call: Call, response: Response) {
                // Success
            }
        })
    }

    private fun sendStatusUpdate(status: String) {
        val statusData = mapOf(
            "connection" to status,
            "battery" to 0,
            "signal_quality" to 0
        )

        val json = gson.toJson(statusData)
        val request = Request.Builder()
            .url("$serverUrl/api/android/status")
            .post(RequestBody.create(MediaType.parse("application/json"), json))
            .build()

        httpClient.newCall(request).enqueue(object : Callback {
            override fun onFailure(call: Call, e: IOException) {}
            override fun onResponse(call: Call, response: Response) {}
        })
    }

    override fun onDestroy() {
        super.onDestroy()
        Log.d(TAG, "Service onDestroy()")

        muse?.let {
            it.unregisterAllListeners()
            it.disconnect()
        }

        museManager.stopListeningForMuseConnections()
    }
}
