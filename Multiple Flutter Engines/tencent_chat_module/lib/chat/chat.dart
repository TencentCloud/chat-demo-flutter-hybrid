import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tencent_chat_module/chat/model.dart';
import 'package:provider/provider.dart';
import 'package:tim_ui_kit/business_logic/view_models/tui_chat_global_model.dart';
import 'package:tim_ui_kit/tim_ui_kit.dart';
import 'package:tim_ui_kit/ui/utils/color.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tim_ui_kit_calling_plugin/tim_ui_kit_calling_plugin.dart';

import '../common/common_model.dart';
import 'group_profile.dart';
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

  @override
  Widget build(BuildContext context) {
    final ChatInfoModel chatInfoModel = Provider.of<ChatInfoModel>(context);
    return TIMUIKitChat(
      key: tuiChatField,
      morePanelConfig: MorePanelConfig(
        extraAction: [
          if(!kIsWeb) MorePanelItem(
              id: "voiceCall",
              title: TIM_t("语音通话"),
              onTap: (c) {
                print("triggerVoiceCall, ontap");
                CallInfo callInfo = CallInfo();
                print("triggerVoiceCall, callInfo");
                if(widget.conversationType == ConvType.c2c){
                  callInfo.userID = widget.conversationID;
                }else {
                  callInfo.groupID = widget.conversationID;
                }
                print("triggerVoiceCall, userID");
                chatInfoModel.triggerVoiceCall(callInfo);
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
                CallInfo callInfo = CallInfo();
                if(widget.conversationType == ConvType.c2c){
                  callInfo.userID = widget.conversationID;
                }else {
                  callInfo.groupID = widget.conversationID;
                }
                chatInfoModel.triggerVideoCall(callInfo);
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
