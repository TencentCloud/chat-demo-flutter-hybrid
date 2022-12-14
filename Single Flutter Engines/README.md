# Single Flutter Engine

Embeds a single full screen instance of Flutter into an existing iOS or Android app.

## Description

These apps showcase a relatively straightforward integration of
`tencent_chat_module`:

* The Flutter module is built along with the app when the app is built.
* The Flutter engine is warmed up at app launch.
* The Flutter view is presented with a full-screen Activity or
  UIViewController.
* The Flutter view is a navigational leaf node; it does not launch any new,
  native Activities or UIViewControllers in response to user actions.

If you are new to Flutter's add-to-app APIs, these projects are a great place
to begin learning how to use them.

## tl;dr

If you're just looking to get up and running quickly, these bash commands will
fetch packages and set up dependencies (note that the above commands assume
you're building for both iOS and Android, with both toolchains installed):

```bash
  #!/bin/bash
  set -e

  cd tencent_chat_module/
  flutter pub get

  # For Android builds:
  open -a "Android Studio" ../android_fullscreen # macOS only
  # Or open the ../android_fullscreen folder in Android Studio for other platforms.

  # For iOS builds:
  cd ../ios_fullscreen
  pod install
  open IOSFullScreen.xcworkspace
```

## Requirements

* Flutter
* Android
  * Android Studio
* iOS
  * Xcode
  * Cocoapods

## Contact Us

Please do not hesitate to contact us in the following place, if you have any further questions or tend to learn more about the use cases.

- Telegram Group: <https://t.me/+1doS9AUBmndhNGNl>
- WhatsApp Group: <https://chat.whatsapp.com/Gfbxk7rQBqc8Rz4pzzP27A>
- QQ Group: 788910197, chat in Chinese

Our Website: <https://www.tencentcloud.com/products/im?from=pub>