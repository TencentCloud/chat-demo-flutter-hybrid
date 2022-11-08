import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tencent_chat_module/chat/chat.dart';
import 'package:tencent_chat_module/chat/push.dart';
import 'package:tencent_chat_module/common/common_model.dart';
import 'package:synchronized/synchronized.dart';
import 'package:tim_ui_kit/business_logic/view_models/tui_chat_global_model.dart';
import 'package:tim_ui_kit/tim_ui_kit.dart';
import 'package:tim_ui_kit/ui/controller/tim_uikit_chat_controller.dart';
import 'package:tim_ui_kit_push_plugin/model/appInfo.dart';

class ChatInfoModel extends ChangeNotifier {
  final CoreServicesImpl _coreInstance = TIMUIKitCore.getInstance();
  final Lock lock = Lock();
  final _channel = const MethodChannel('com.tencent.flutter.chat');
  final TIMUIKitChatController _timuiKitChatController =
  TIMUIKitChatController();
  final PushAppInfo appInfo = PushAppInfo(
      apple_buz_id: 35763
  );

  ChatInfoModel() {
    _channel.setMethodCallHandler(_handleMessage);
    _channel.invokeMethod<void>('requestCallInfo');
  }

  ChatInfo? _chatInfo;
  Map<String, dynamic>? notificationMap;
  bool _isInit = false;
  BuildContext? context;

  bool get isInit => _isInit;

  set isInit(bool value) {
    _isInit = value;
    notifyListeners();
  }

  set chatInfo(ChatInfo? value) {
    _chatInfo = value;
    notifyListeners();
    if(value != null && value.sdkappid != null && value.userID != null && value.userSig != null){
      Future.delayed(const Duration(seconds: 0), () => initChat());
    }
  }

  ChatInfo? get chatInfo => _chatInfo;

  Future<void> initChat() async {
    await lock.synchronized(() async {
      if(isInit){
        return;
      }
      await _coreInstance.init(
          sdkAppID: int.parse(_chatInfo!.sdkappid!),
          loglevel: LogLevelEnum.V2TIM_LOG_DEBUG,
          onTUIKitCallbackListener: (callbackValue) {},
          listener: V2TimSDKListener());
      final res = await _coreInstance.login(
          userID: _chatInfo!.userID!, userSig: _chatInfo!.userSig!);
      if (res.code == 0) {
        isInit = true;
        if (notificationMap != null) {
          Future.delayed(const Duration(milliseconds: 300), () {
            handleClickNotification(notificationMap!);
            notificationMap = null;
          });
        }
      }
      initPush();
    });
  }

  Future<dynamic> _handleMessage(MethodCall call) async {
    if (call.method == 'reportChatInfo') {
      final jsonString = call.arguments as String;
      try{
        final Map<String, dynamic> chatInfoMap = jsonDecode(jsonString) as Map<String, dynamic>;
        chatInfo = ChatInfo.fromJSON(chatInfoMap);
      }catch(e){
        print("error ${e.toString()}");
      }
    }else if (call.method == 'notification') {
      final jsonString = call.arguments as String;
      try{
        final Map<String, dynamic> notification = jsonDecode(jsonString) as Map<String, dynamic>;
        if(isInit){
          await handleClickNotification(jsonDecode(jsonString) as Map<String, dynamic>);
        }else{
          notificationMap = notification;
        }
      }catch(e){
        print("error ${e.toString()}");
      }
    }
  }

  Future<void> initPush() async {
    Future.delayed(const Duration(milliseconds: 10), () async {
      await ChannelPush.init((msg) {
        print("Push Click $msg");
        handleClickNotification(msg);
      }, appInfo);

      final tokenRes = await ChannelPush.uploadToken(appInfo);
      print("Push Upload Result $tokenRes");
    });
  }

  String? _getConvID(V2TimConversation conversation) {
    return conversation.type == 1 ? conversation.userID : conversation.groupID;
  }

  ConvType _getConvType(V2TimConversation conversation) {
    return conversation.type == 1 ? ConvType.c2c : ConvType.group;
  }

  Future<void> handleClickNotification(Map<String, dynamic> msg) async {
    String ext = msg['ext'] as String? ?? "";
    Map<String, dynamic> extMsp = jsonDecode(ext) as Map<String, dynamic>;
    String convId = extMsp["conversationID"] as String? ?? "";
    final currentConvID = _timuiKitChatController.getCurrentConversation();
    if (convId.split("_").length < 2 || currentConvID == convId.split("_")[1]) {
      return;
    }
    final targetConversationRes = await TencentImSDKPlugin.v2TIMManager
        .getConversationManager()
        .getConversation(conversationID: convId);

    V2TimConversation? targetConversation = targetConversationRes.data;

    if (targetConversation != null) {
      Future.delayed(const Duration(milliseconds: 100), () {
        Navigator.push<void>(
            context!,
            MaterialPageRoute(
              builder: (context) => Chat(
                conversationID: _getConvID(targetConversation) ?? "",
                conversationType: _getConvType(targetConversation),
                conversationShowName: targetConversation.showName ?? "Chat",
              ),
            ));
      });
    }
  }

  void triggerVoiceCall(CallInfo callInfo){
    _channel.invokeMethod<void>('voiceCall', jsonEncode(callInfo.toMap()));
  }

  void triggerVideoCall(CallInfo callInfo){
    _channel.invokeMethod<void>('videoCall', jsonEncode(callInfo.toMap()));
  }
}