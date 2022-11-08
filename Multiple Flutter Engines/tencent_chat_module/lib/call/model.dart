import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tencent_chat_module/chat/chat.dart';
import 'package:tencent_chat_module/chat/push.dart';
import 'package:synchronized/synchronized.dart';
import 'package:tim_ui_kit/business_logic/view_models/tui_chat_global_model.dart';
import 'package:tim_ui_kit/data_services/core/core_services_implements.dart';
import 'package:tim_ui_kit/tim_ui_kit.dart';
import 'package:tim_ui_kit/ui/controller/tim_uikit_chat_controller.dart';
import 'package:tim_ui_kit/ui/utils/permission.dart';
import 'package:tim_ui_kit_calling_plugin/enum/tim_uikit_trtc_calling_scence.dart';
import 'package:tim_ui_kit_calling_plugin/model/TIMUIKitCallingListener.dart';
import 'package:tim_ui_kit_calling_plugin/tim_ui_kit_calling_plugin.dart';
import 'package:tim_ui_kit_push_plugin/model/appInfo.dart';

import '../common/common_model.dart';

class CallInfoModel extends ChangeNotifier {
  final TUICalling _calling = TUICalling();
  late TUICallingListener _onRtcListener;
  final Lock lock = Lock();
  final _channel = const MethodChannel('com.tencent.flutter.call');

  CallInfoModel() {
    _channel.setMethodCallHandler(_handleMessage);
    _channel.invokeMethod<void>('requestCallInfo');
    _onRtcListener = TUICallingListener(
      onInvited: (params) {
        _channel.invokeMethod<void>('launchCall');
      },
      onCallEnd: () {
        _channel.invokeMethod<void>('endCall');
      },
      onCallingTimeout: (_) {
        _channel.invokeMethod<void>('endCall');
      },
      onKickedOffline: () {
        _channel.invokeMethod<void>('endCall');
      },
      onNoResp: (_) {
        _channel.invokeMethod<void>('endCall');
      },
      onReject: (_) {
        _channel.invokeMethod<void>('endCall');
      },
      onError: (_) {
        _channel.invokeMethod<void>('endCall');
      },
      onCallingCancel: () {
        _channel.invokeMethod<void>('endCall');
      },
    );
  }

  ChatInfo? _chatInfo;
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
      Future.delayed(const Duration(seconds: 0), () => initCall());
    }
  }

  ChatInfo? get chatInfo => _chatInfo;

  Future<void> initCall() async {
    await lock.synchronized(() async {
      if(isInit){
        return;
      }
      isInit = true;
      await _calling.init(
          sdkAppID: int.parse(_chatInfo!.sdkappid!),
          userID: _chatInfo!.userID!,
          userSig: _chatInfo!.userSig!);
      _calling.setCallingListener(_onRtcListener);
    });
  }

  Future<dynamic> _handleMessage(MethodCall call) async {
    if (call.method == 'reportCallInfo') {
      final jsonString = call.arguments as String;
      try{
        final Map<String, dynamic> chatInfoMap = jsonDecode(jsonString) as Map<String, dynamic>;
        chatInfo = ChatInfo.fromJSON(chatInfoMap);
      }catch(e){
        print("error ${e.toString()}");
      }
    } else if (call.method == 'voiceCall'){
      final jsonString = call.arguments as String;
      try{
        final Map<String, dynamic> callInfoMap = jsonDecode(jsonString) as Map<String, dynamic>;
        final callInfo = CallInfo.fromJSON(callInfoMap);
        voiceCall(callInfo);
      }catch(e){
        print("error ${e.toString()}");
      }
    } else if (call.method == 'videoCall'){
      final jsonString = call.arguments as String;
      try{
        final Map<String, dynamic> callInfoMap = jsonDecode(jsonString) as Map<String, dynamic>;
        final callInfo = CallInfo.fromJSON(callInfoMap);
        videoCall(callInfo);
      }catch(e){
        print("error ${e.toString()}");
      }
    }
  }

  Future<void> videoCall(CallInfo callInfo) async {
    if(context == null){
      return;
    }
    final hasCameraPermission =
    await Permissions.checkPermission(context!, Permission.camera.value);
    final hasMicrophonePermission = await Permissions.checkPermission(
        context!, Permission.microphone.value);
    if (!hasCameraPermission || !hasMicrophonePermission) {
      return;
    }
    // final isGroup = widget.conversationType == ConvType.group;
    const isGroup = false;
    if (isGroup) {
      // 请根据我们的完整版Demo，扩展群语音时，先选人，再发起语音的能力
      // Please implement the choosing user for group call based on our demo.
    } else {
      OfflinePushInfo offlinePush = OfflinePushInfo(
        title: "",
        desc: TIM_t("邀请你视频通话"),
        ext: "{\"conversationID\": \"\"}",
        disablePush: false,
        ignoreIOSBadge: false,
      );

      await _calling.call(callInfo.userID ?? callInfo.groupID ?? "", CallingScenes.Video,
          offlinePush);
    }
  }

  Future<void> voiceCall(CallInfo callInfo) async {
    if(context == null){
      return;
    }
    final hasMicrophonePermission = await Permissions.checkPermission(
        context!, Permission.microphone.value);
    if (!hasMicrophonePermission) {
      return;
    }
    // final isGroup = widget.conversationType == ConvType.group;

    // final isGroup = widget.conversationType == ConvType.group;
    const isGroup = false;
    if (isGroup) {
      // 请根据我们的完整版Demo，扩展群语音时，先选人，再发起语音的能力
      // Please implement the choosing user for group call based on our demo.
    } else {
      OfflinePushInfo offlinePush = OfflinePushInfo(
        title: "",
        desc: TIM_t("邀请你语音通话"),
        ext: "{\"conversationID\": \"\"}",
        disablePush: false,
        ignoreIOSBadge: false,
      );

      await _calling.call(callInfo.userID ?? callInfo.groupID ?? "", CallingScenes.Audio,
          offlinePush);
    }
  }
}