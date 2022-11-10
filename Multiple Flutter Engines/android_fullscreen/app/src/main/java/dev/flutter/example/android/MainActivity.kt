// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package com.tencent.chat.android

import android.os.Bundle
import android.widget.Button
import androidx.appcompat.app.AppCompatActivity
import com.google.gson.Gson
import com.tencent.flutter.tim_ui_kit_push_plugin.TimUiKitPushPlugin
import com.tencent.flutter.tim_ui_kit_push_plugin.common.Extras
import com.tencent.flutter.tim_ui_kit_push_plugin.pushActivity.OPPOMessageActivity
import io.flutter.Log
import java.util.*

class MainActivity : AppCompatActivity() {

    val gson = Gson()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        setContentView(R.layout.activity_main)

        val button = findViewById<Button>(R.id.launch_button)

        button.setOnClickListener {
            FlutterUtils.launchChatFunc()
        }


        val intent = intent
        val keyMap: HashMap<Any?, Any?> = HashMap<Any?, Any?>()
        try {
            val bundle = intent.extras
            val set = bundle!!.keySet()
            if (set != null) {
                for (key in set) {
                    // 其中 key 和 value 分别为发送端设置的 extKey 和 ext content
                    val value = bundle.getString(key)
                    keyMap[key] = value
                    Log.i("oppo push custom data", "key = $key:value = $value")
                }
            }
        } catch (e: Exception) {
        }

        if(!keyMap.isEmpty()){
            FlutterUtils.triggerNotification(gson.toJson(keyMap))
        }
    }
}
