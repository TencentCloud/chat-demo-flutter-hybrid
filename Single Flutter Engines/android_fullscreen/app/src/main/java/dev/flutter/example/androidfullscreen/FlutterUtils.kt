package com.tencent.chat.android

import android.annotation.SuppressLint
import android.content.Context
import android.content.Intent
import com.google.gson.Gson
import com.tencent.imsdk.v2.V2TIMSDKConfig
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

// Please generate `userSig` in your project, recommended on your server, while the hard code here is only for demonstration purpose.
// 实际项目中，这里的userSig必须动态获取，最好通过服务端获取。这里的写死，仅用于演示。
val chatInfo: ChatInfo = ChatInfo(
    "",
    "",
    ""
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

    fun triggerNotification(msg: String){
        launchChatFunc()
        channel.invokeMethod("notification", msg)
    }

}
