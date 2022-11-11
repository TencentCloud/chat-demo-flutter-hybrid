import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tim_ui_kit/business_logic/view_models/tui_chat_global_model.dart';
import 'package:tim_ui_kit/tim_ui_kit.dart';
import 'package:tim_ui_kit/ui/utils/color.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tim_ui_kit/ui/utils/permission.dart';
import 'package:tim_ui_kit_calling_plugin/enum/tim_uikit_trtc_calling_scence.dart';
import 'package:tim_ui_kit_calling_plugin/tim_ui_kit_calling_plugin.dart';

import 'gtoup_profile.dart';
import 'user_profile.dart';

class Chat extends StatefulWidget {
  final String conversationID;
  final ConvType conversationType;
  final String conversationShowName;

  const Chat(
      {super.key,
      required this.conversationID,
      required this.conversationType,
      required this.conversationShowName});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final TUICalling _calling = TUICalling();
  final V2TIMManager sdkInstance = TIMUIKitCore.getSDKInstance();
  GlobalKey<dynamic> tuiChatField = GlobalKey();

  Future<void> _goToVideoUI() async {
    if (!kIsWeb) {
      final hasCameraPermission =
      await Permissions.checkPermission(context, Permission.camera.value);
      final hasMicrophonePermission = await Permissions.checkPermission(
          context, Permission.microphone.value);
      if (!hasCameraPermission || !hasMicrophonePermission) {
        return;
      }
    }
    final isGroup = widget.conversationType == ConvType.group;
    tuiChatField.currentState.textFieldController.hideAllPanel();
    if (isGroup) {

    } else {
      final user = await sdkInstance.getLoginUser();
      final myId = user.data;
      OfflinePushInfo offlinePush = OfflinePushInfo(
        title: "",
        desc: TIM_t("邀请你视频通话"),
        ext: "{\"conversationID\": \"\"}",
        disablePush: false,
        ignoreIOSBadge: false,
      );

      await _calling.call(widget.conversationID, CallingScenes.Video,
          offlinePush);
    }
  }

  Future<void> _goToVoiceUI() async {
    if (!kIsWeb) {
      final hasMicrophonePermission = await Permissions.checkPermission(
          context, Permission.microphone.value);
      if (!hasMicrophonePermission) {
        return;
      }
    }
    final isGroup = widget.conversationType == ConvType.group;
    tuiChatField.currentState.textFieldController.hideAllPanel();
    if (isGroup) {

    } else {
      final user = await sdkInstance.getLoginUser();
      final myId = user.data;
      OfflinePushInfo offlinePush = OfflinePushInfo(
        title: "",
        desc: TIM_t("邀请你语音通话"),
        ext: "{\"conversationID\": \"\"}",
        disablePush: false,
        ignoreIOSBadge: false,
      );

      await _calling?.call(widget.conversationID, CallingScenes.Audio,
          offlinePush);
    }
  }


  @override
  Widget build(BuildContext context) {
    return TIMUIKitChat(
      key: tuiChatField,
      morePanelConfig: MorePanelConfig(
        extraAction: [
          if(!kIsWeb) MorePanelItem(
              id: "voiceCall",
              title: TIM_t("语音通话"),
              onTap: (c) {
                // _onFeatureTap("voiceCall", c);
                _goToVoiceUI();
              },
              icon: Container(
                height: 64,
                width: 64,
                margin: const EdgeInsets.only(bottom: 4),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                child: SvgPicture.asset(
                  "images/voice-call.svg",
                  package: 'tim_ui_kit',
                  height: 64,
                  width: 64,
                ),
              )),
          if(!kIsWeb) MorePanelItem(
              id: "videoCall",
              title: TIM_t("视频通话"),
              onTap: (c) {
                // _onFeatureTap("videoCall", c);
                _goToVideoUI();
              },
              icon: Container(
                height: 64,
                width: 64,
                margin: const EdgeInsets.only(bottom: 4),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                child: SvgPicture.asset(
                  "images/video-call.svg",
                  package: 'tim_ui_kit',
                  height: 64,
                  width: 64,
                ),
              ))
        ]
      ),
      appBarConfig: AppBar(
        backgroundColor: hexToColor("f2f3f5"),
        textTheme: TextTheme(
            titleMedium: TextStyle(
                color: hexToColor("010000"),
                fontSize: 16
            )
        ),
        actions: [
          IconButton(
              padding: const EdgeInsets.only(left: 8, right: 16),
              onPressed: () async {
                if (widget.conversationType == ConvType.c2c) {
                  final userID = widget.conversationID;
                  // if had remark modifed its will back new remark
                  await Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (context) => UserProfile(
                          userID: userID,
                        ),
                      ));
                } else {
                  final groupID = widget.conversationID;
                  await Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (context) => GroupProfile(
                          groupID: groupID,
                        ),
                      ));
                }
              },
              icon: Icon(
                Icons.more_horiz,
                color: hexToColor("010000"),
                size: 20,
              ))
        ],
      ),
        conversationID: widget.conversationID,
        conversationType: widget.conversationType,
        conversationShowName: widget.conversationShowName);
  }
}
