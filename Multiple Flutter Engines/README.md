## Multiple Flutter Engine

This is a sample that shows how to use the Flutter Engine Groups API to embed multiple instances of Flutter into an existing Android or iOS project.

## Requirements

* Flutter
* Android
  * Android Studio
* iOS
  * Xcode
  * Cocoapods

## Flutter Engine Group

These examples use the Flutter Engine Group APIs on the host platform which allows engines to share memory and CPU intensive resources. This leads to easier embedding of Flutter into an existing app since multiple entrypoints can be maintained via a FlutterFragment on Android or a UIViewController on iOS. Before FlutterEngineGroup, users had to juggle the usage of a small number of engines judiciously.

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

## Contact Us

Please do not hesitate to contact us in the following place, if you have any further questions or tend to learn more about the use cases.

- Telegram Group: <https://t.me/+1doS9AUBmndhNGNl>
- WhatsApp Group: <https://chat.whatsapp.com/Gfbxk7rQBqc8Rz4pzzP27A>
- QQ Group: 788910197, chat in Chinese

Our Website: <https://www.tencentcloud.com/products/im?from=pub>