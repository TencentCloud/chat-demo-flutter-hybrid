
import 'package:tim_ui_kit/tim_ui_kit.dart';
import 'package:tim_ui_kit_push_plugin/tim_ui_kit_push_plugin.dart';

class ChannelPush {
  static final TimUiKitPushPlugin cPush = TimUiKitPushPlugin(
    isUseGoogleFCM: false,
  );

  static Future<void> init(PushClickAction pushClickAction, PushAppInfo appInfo) async {
    await cPush.init(
      pushClickAction: pushClickAction,
      appInfo: appInfo,
    );

    cPush.createNotificationChannel(
        channelId: "new_message",
        channelName: "消息推送",
        channelDescription: "推送新聊天消息");
    cPush.createNotificationChannel(
        channelId: "high_system",
        channelName: "新消息提醒",
        channelDescription: "推送新聊天消息");
    return;
  }

  static void requestPermission() {
    cPush.requireNotificationPermission();
  }

  static Future<String> getDeviceToken() async {
    return cPush.getDevicePushToken();
  }

  static void setBadgeNum(int badgeNum) {
    return cPush.setBadgeNum(badgeNum);
  }

  static void clearAllNotification() {
    return cPush.clearAllNotification();
  }

  static Future<bool> uploadToken(PushAppInfo appInfo) async {
    return cPush.uploadToken(appInfo);
  }

  static void displayNotification(String title, String body, [String? ext]) {
    cPush.displayNotification(
        channelID: "new_message",
        channelName: "消息推送",
        title: title,
        body: body,
        ext: ext);
  }

  static void displayDefaultNotificationForMessage(V2TimMessage message) {
    cPush.displayDefaultNotificationForMessage(
        message: message, channelID: "new_message", channelName: "消息推送");
  }
}
