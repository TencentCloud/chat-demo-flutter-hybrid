package com.tencent.chat.android

import android.annotation.SuppressLint
import android.content.Context
import android.content.Intent
import com.google.gson.Gson

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.MethodChannel

const val ENGINE_ID = "com.tencent.flutter"

data class ChatInfo(
    val sdkappid: String?,
    val userSig: String?,
    val userID: String?,
)

val chatInfo: ChatInfo = ChatInfo(
    "1400187352",
    "eJyrVgrxCdYrSy1SslIy0jNQ0gHzM1NS80oy0zLBwpam5gYWpqZGFlDJ4pTsxIKCzBQlK0MTAwNDC3NjUyOITElmbipQ1MzMHChoaWQIEU2tKMgsAoqbGYAA1IzMdKDJxua5ZV4ZiVmGoX6BHjnJiU6lSdrGPnmlpiF*BS4mgYWOqYHZYYV*ZqHGnrZKtQDe9zCL",
    "957085528"
)

@SuppressLint("StaticFieldLeak")
object FlutterUtils {
    lateinit var context : Context
    private lateinit var flutterEngine:FlutterEngine
    lateinit var channel: MethodChannel
    val gson = Gson()

    fun init() {
        flutterEngine = FlutterEngine(context)
        flutterEngine
            .dartExecutor
            .executeDartEntrypoint(
                DartExecutor.DartEntrypoint.createDefault()
            )
        FlutterEngineCache.getInstance().put(ENGINE_ID, flutterEngine)
        channel = MethodChannel(flutterEngine.dartExecutor, "com.tencent.chat/add-to-app")
        channel.setMethodCallHandler { call, _ ->
            when (call.method) {
                "requestChatInfo" -> {
                    reportChatInfo()
                }
                "launchChat" -> {
                    launchChatFunc()
                }
            }
        }
    }

    private fun reportChatInfo() {
//        channel.invokeMethod("reportChatInfo", moshi.adapter(ChatInfo::class.java).toJson(chatInfo))
        channel.invokeMethod("reportChatInfo", gson.toJson(chatInfo))
    }

    fun launchChatFunc() {
        val intent = FlutterActivity
            .withCachedEngine(ENGINE_ID)
            .build(context).addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        context.startActivity(intent)
    }

}
