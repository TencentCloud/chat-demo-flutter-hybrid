package com.tencent.chat.android

import android.annotation.SuppressLint
import android.app.Instrumentation
import android.content.Context
import android.content.Intent
import android.view.KeyEvent
import com.google.gson.Gson
import io.flutter.FlutterInjector
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.embedding.engine.FlutterEngineGroup
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.MethodChannel

const val CHAT_ENGINE_ID = "chat"
const val CALL_ENGINE_ID = "call"

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
    val gson = Gson()

    lateinit var flutterEngines: FlutterEngineGroup
    private lateinit var chatFlutterEngine:FlutterEngine
    private lateinit var callFlutterEngine:FlutterEngine

    lateinit var chatMethodChannel: MethodChannel
    lateinit var callMethodChannel: MethodChannel

    fun init() {
        flutterEngines = FlutterEngineGroup(context)

        // Flutter - Chat
        val chatEntrypoint =
            DartExecutor.DartEntrypoint(
                FlutterInjector.instance().flutterLoader().findAppBundlePath(), "chatMain"
            )
        chatFlutterEngine = flutterEngines.createAndRunEngine(context, chatEntrypoint)
        FlutterEngineCache.getInstance().put(CHAT_ENGINE_ID, chatFlutterEngine)
        chatMethodChannel = MethodChannel(chatFlutterEngine.dartExecutor, "com.tencent.flutter.chat")
        chatMethodChannel.setMethodCallHandler { call, _ ->
            when (call.method) {
                "requestChatInfo" -> {
                    reportChatInfo()
                }
                "launchChat" -> {
                    launchChatFunc()
                }
                "voiceCall" -> {
                    triggerVoiceCall(call.arguments as String)
                }
                "videoCall" -> {
                    triggerVideoCall(call.arguments as String)
                }
            }
        }

        // Flutter - Call
        val callEntrypoint =
            DartExecutor.DartEntrypoint(
                FlutterInjector.instance().flutterLoader().findAppBundlePath(), "callMain"
            )
        callFlutterEngine = flutterEngines.createAndRunEngine(context, callEntrypoint)
        FlutterEngineCache.getInstance().put(CALL_ENGINE_ID, callFlutterEngine)
        callMethodChannel = MethodChannel(callFlutterEngine.dartExecutor, "com.tencent.flutter.call")
        callMethodChannel.setMethodCallHandler { call, _ ->
            when (call.method) {
                "requestCallInfo" -> {
                    reportCallInfo()
                }
                "launchCall" -> {
                    launchCallFunc()
                }
                "endCall" -> {
                    endCallFunc()
                }
            }
        }
    }

    private fun reportChatInfo() {
        chatMethodChannel.invokeMethod("reportChatInfo", gson.toJson(chatInfo))
    }

    private fun reportCallInfo() {
        callMethodChannel.invokeMethod("reportCallInfo", gson.toJson(chatInfo))
    }

    fun launchChatFunc() {
        val intent = FlutterActivity
            .withCachedEngine(CHAT_ENGINE_ID)
            .build(context).addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)

        context.startActivity(intent)
    }

    fun launchCallFunc() {
        val intent = FlutterActivity
            .withCachedEngine(CALL_ENGINE_ID)
            .build(context).addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)

        context.startActivity(intent)
    }

    fun endCallFunc() {
        object : Thread() {
            override fun run() {
                try {
                    val inst = Instrumentation()
                    inst.sendKeyDownUpSync(KeyEvent.KEYCODE_BACK)
                } catch (e: Exception) {
                    e.printStackTrace()
                }
            }
        }.start()
    }

    fun triggerVoiceCall(callInfo: String) {
        callMethodChannel.invokeMethod("voiceCall", callInfo)
        launchCallFunc()
    }

    fun triggerVideoCall(callInfo: String) {
        callMethodChannel.invokeMethod("videoCall", callInfo)
        launchCallFunc()
    }

    fun triggerNotification(msg: String){
        launchChatFunc()
        chatMethodChannel.invokeMethod("notification", msg)
    }
}
