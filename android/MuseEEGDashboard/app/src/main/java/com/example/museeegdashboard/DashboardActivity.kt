package com.example.museeegdashboard

import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.webkit.WebSettings
import android.webkit.WebView
import android.webkit.WebViewClient
import androidx.appcompat.app.AppCompatActivity

class DashboardActivity : AppCompatActivity() {

    private lateinit var webView: WebView
    private val handler = Handler(Looper.getMainLooper())

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_dashboard)

        webView = findViewById(R.id.webView)
        setupWebView()

        // Load Flask dashboard
        val sharedPref = getSharedPreferences("muse_eeg_prefs", MODE_PRIVATE)
        val serverUrl = sharedPref.getString("server_url", "http://192.168.1.100:9009") ?: "http://192.168.1.100:9009"
        
        webView.loadUrl(serverUrl)
    }

    private fun setupWebView() {
        // Enable JavaScript
        webView.settings.apply {
            javaScriptEnabled = true
            mixedContentMode = WebSettings.MIXED_CONTENT_ALLOW_ALL
            domStorageEnabled = true
            databaseEnabled = true
            cacheMode = WebSettings.LOAD_DEFAULT
        }

        // Set WebView client
        webView.webViewClient = WebViewClient()
    }

    override fun onBackPressed() {
        if (webView.canGoBack()) {
            webView.goBack()
        } else {
            super.onBackPressed()
        }
    }

    override fun onDestroy() {
        webView.destroy()
        super.onDestroy()
    }
}
