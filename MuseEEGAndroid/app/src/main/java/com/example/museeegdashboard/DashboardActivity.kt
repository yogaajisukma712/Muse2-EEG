package com.example.museeegdashboard

import android.os.Bundle
import android.webkit.WebChromeClient
import android.webkit.WebViewClient
import android.webkit.WebView
import android.widget.ProgressBar
import androidx.appcompat.app.AppCompatActivity

class DashboardActivity : AppCompatActivity() {
    
    private lateinit var webView: WebView
    private lateinit var progressBar: ProgressBar
    
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_dashboard)
        
        webView = findViewById(R.id.webview)
        progressBar = findViewById(R.id.progress_bar)
        
        val serverIp = intent.getStringExtra("SERVER_IP") ?: "localhost:9009"
        
        // Configure WebView
        val settings = webView.settings
        settings.javaScriptEnabled = true
        settings.domStorageEnabled = true
        settings.databaseEnabled = true
        settings.useWideViewPort = true
        settings.loadWithOverviewMode = true
        
        webView.webViewClient = object : WebViewClient() {
            override fun onPageFinished(view: WebView?, url: String?) {
                super.onPageFinished(view, url)
                progressBar.visibility = android.view.View.GONE
            }
        }
        
        webView.webChromeClient = object : WebChromeClient() {
            override fun onProgressChanged(view: WebView?, newProgress: Int) {
                super.onProgressChanged(view, newProgress)
                progressBar.progress = newProgress
            }
        }
        
        // Load dashboard
        val dashboardUrl = "http://$serverIp/download"
        webView.loadUrl(dashboardUrl)
    }
}
