proguard-rules.pro

# Keep muse library classes
-keep class com.choosemuse.** { *; }
-keep interface com.choosemuse.** { *; }

# Keep Gson classes
-keep class com.google.gson.** { *; }
-keep interface com.google.gson.** { *; }

# Keep OkHttp
-keep class okhttp3.** { *; }
-keep interface okhttp3.** { *; }

# Keep WebSocket
-keep class org.java_websocket.** { *; }

# Keep Android support
-keep class androidx.** { *; }
-keep interface androidx.** { *; }

# General
-keepattributes *Annotation*
-keepattributes SourceFile,LineNumberTable
