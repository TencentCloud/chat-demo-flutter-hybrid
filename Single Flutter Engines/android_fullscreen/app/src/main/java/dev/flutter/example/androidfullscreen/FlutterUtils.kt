package dev.flutter.example.androidfullscreen

import android.annotation.SuppressLint
import android.content.Context
import androidx.core.content.ContextCompat.startActivity
import com.squareup.moshi.JsonAdapter
import com.squareup.moshi.JsonClass
import com.squareup.moshi.Moshi
import com.squareup.moshi.Types
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.MethodChannel

const val ENGINE_ID = "com.tencent.flutter"

@JsonClass(generateAdapter = true)
class ChatInfo{
    val sdkappid: String = "1400187352"
    val userSig: String = "eJyrVgrxCdYrSy1SslIy0jNQ0gHzM1NS80oy0zLBwpam5gYWpqZGFlDJ4pTsxIKCzBQlK0MTAwNDC3NjUyOITElmbipQ1MzMHChoaWQIEU2tKMgsAoqbGYAA1IzMdKDJxua5ZV4ZiVmGoX6BHjnJiU6lSdrGPnmlpiF*BS4mgYWOqYHZYYV*ZqHGnrZKtQDe9zCL"
    val userID: String = "957085528"
}

@SuppressLint("StaticFieldLeak")
object FlutterUtils {
    lateinit var context : Context
    private lateinit var flutterEngine:FlutterEngine
    lateinit var channel: MethodChannel

    // moshi
    val moshi = Moshi.Builder().build()
    val type = Types.newParameterizedType(Map::class.java, String::class.java, Any::class.java)
    val adapter: JsonAdapter<Map<String, Any>> = moshi.adapter(type)

    var count = 0
    var chatInfo : ChatInfo = ChatInfo()

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
                "incrementCounter" -> {
                    count++
                    reportChatInfo()
                }
                "requestChatInfo" -> {
                    reportChatInfo()
                }
            }
        }
    }

    private fun reportChatInfo() {
        channel.invokeMethod("reportChatInfo", moshi.adapter(ChatInfo::class.java).toJson(chatInfo))
    }

    fun launchChatFunc() {
        val intent = FlutterActivity
            .withCachedEngine(ENGINE_ID)
            .build(context)
        context.startActivity(intent)
    }

}