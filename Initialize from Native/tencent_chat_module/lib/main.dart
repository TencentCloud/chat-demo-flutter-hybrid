// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tencent_chat_module/conversation.dart';
import 'package:tencent_chat_module/push.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:synchronized/synchronized.dart';
import 'package:tim_ui_kit/business_logic/view_models/tui_chat_global_model.dart';
import 'package:tim_ui_kit/tim_ui_kit.dart';
import 'package:tim_ui_kit/ui/controller/tim_uikit_chat_controller.dart';
import 'package:tim_ui_kit_calling_plugin/model/TIMUIKitCallingListener.dart';
import 'package:tim_ui_kit_calling_plugin/tim_ui_kit_calling_plugin.dart';
import 'package:tim_ui_kit_push_plugin/model/appInfo.dart';

import 'chat.dart';

/// The entrypoint for the flutter module.
void main() {
  // This call ensures the Flutter binding has been set up before creating the
  // MethodChannel-based model.
  WidgetsFlutterBinding.ensureInitialized();

  final model = ChatInfoModel();

  runApp(
    ChangeNotifierProvider.value(
      value: model,
      child: const MyApp(),
    ),
  );
}

class ChatInfo {
  String? sdkappid;
  String? userSig;
  String? userID;

  ChatInfo.fromJSON(Map<String, dynamic> json) {
    sdkappid = json["sdkappid"].toString();
    userSig = json["userSig"].toString();
    userID = json["userID"].toString();
  }

}

/// A simple model that uses a [MethodChannel] as the source of truth for the
/// state of a counter.
///
/// Rather than storing app state data within the Flutter module itself (where
/// the native portions of the app can't access it), this module passes messages
/// back to the containing app whenever it needs to increment or retrieve the
/// value of the counter.
class ChatInfoModel extends ChangeNotifier {
  final CoreServicesImpl _coreInstance = TIMUIKitCore.getInstance();
  final TUICalling _calling = TUICalling();
  late TUICallingListener _onRtcListener;
  final Lock lock = Lock();
  final _channel = const MethodChannel('com.tencent.chat/add-to-ios');
  final TIMUIKitChatController _timuiKitChatController =
  TIMUIKitChatController();
  final PushAppInfo appInfo = PushAppInfo(
      apple_buz_id: 35763
  );

  ChatInfoModel() {
    _channel.setMethodCallHandler(_handleMessage);
    _onRtcListener = TUICallingListener(onInvited:
        (params) {
      _channel.invokeMethod<void>('launchChat');
    });
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
      if (isInit) {
        return;
      }
      isInit = true;
      _coreInstance.setDataFromNative(userId: chatInfo?.userID ?? "");
      await _calling.init(
          sdkAppID: int.parse(_chatInfo!.sdkappid!),
          userID: _chatInfo!.userID!,
          userSig: _chatInfo!.userSig!);
      _calling.setCallingListener(_onRtcListener);
      initPush();
      if (notificationMap != null) {
        Future.delayed(const Duration(milliseconds: 300), () {
          handleClickNotification(notificationMap!);
          notificationMap = null;
        });
      }
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
}

/// The "app" displayed by this module.
///
/// It offers two routes, one suitable for displaying as a full screen and
/// another designed to be part of a larger UI.class MyApp extends StatelessWidget {
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tencent Cloud Chat',
      navigatorKey: TUICalling.navigatorKey,
      routes: {
        '/': (context) => const FullScreenView(),
        '/mini': (context) => const Contents(),
      },
    );
  }
}

/// Wraps [Contents] in a Material [Scaffold] so it looks correct when displayed
/// full-screen.
class FullScreenView extends StatelessWidget {
  const FullScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final ChatInfoModel chatInfoModel = Provider.of<ChatInfoModel>(context);
    chatInfoModel.context ??= context;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tencent Cloud Chat'),
      ),
      body: const Contents(),
    );
  }
}

class Contents extends StatelessWidget {

  const Contents({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaInfo = MediaQuery.of(context);
    final ChatInfoModel chatInfoModel = Provider.of<ChatInfoModel>(context);
    chatInfoModel.context ??= context;
    final bool isInit = chatInfoModel.isInit;
    return SizedBox.expand(
      child: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
            ),
          ),
          if(!isInit) Center(
              child: LoadingAnimationWidget.staggeredDotsWave(
                color: Colors.grey,
                size: 40,
              )
          ),
          if(isInit) const Conversation()
        ],
      ),
    );
  }
}
