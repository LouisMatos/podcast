# Fase 18 — regras R8/proguard pro release.
# `isMinifyEnabled = true` + `isShrinkResources = true` no build.gradle.kts.
# O Flutter Gradle Plugin já injeta as regras do engine e dos plugins que
# publicam consumer-rules; abaixo só o que costuma faltar / deu problema.

# --- just_audio / audio_service (ExoPlayer via media3) ---
-keep class com.google.android.exoplayer2.** { *; }
-keep class androidx.media3.** { *; }
-dontwarn com.google.android.exoplayer2.**
-dontwarn androidx.media3.**

# --- flutter_local_notifications: usa Gson (TypeToken via reflection) ---
-keep class com.google.gson.reflect.TypeToken { *; }
-keep class * extends com.google.gson.reflect.TypeToken
-keep public class * implements java.lang.reflect.Type

# --- workmanager: worker instanciado por reflection ---
-keep class * extends androidx.work.Worker
-keep class * extends androidx.work.ListenableWorker { <init>(...); }
-keep class androidx.work.impl.** { *; }

# --- flutter_downloader: BroadcastReceiver/Service por nome ---
-keep class vn.hunghd.flutterdownloader.** { *; }

# --- drift/sqlite3: carrega a lib nativa via JNI ---
-keep class org.sqlite.** { *; }

# --- Kotlin coroutines (usado por vários plugins) ---
-keepnames class kotlinx.coroutines.internal.MainDispatcherFactory {}
-keepnames class kotlinx.coroutines.CoroutineExceptionHandler {}
-dontwarn kotlinx.coroutines.**

# Modelos serializados (json_serializable gera código, não reflection) —
# nada a fazer. Freezed idem.
