

import 'package:flutter/material.dart';
import 'package:tim_ui_kit/business_logic/view_models/tui_chat_global_model.dart';
import 'package:tim_ui_kit/tim_ui_kit.dart';

import 'chat.dart';

class Conversation extends StatefulWidget {
  const Conversation({super.key});

  @override
  State<Conversation> createState() => _ConversationState();
}

class _ConversationState extends State<Conversation> {

  String? _getConvID(V2TimConversation conversation) {
    return conversation.type == 1 ? conversation.userID : conversation.groupID;
  }

  ConvType _getConvType(V2TimConversation conversation) {
    return conversation.type == 1 ? ConvType.c2c : ConvType.group;
  }

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    void handleOnConvItemTaped(V2TimConversation selectedConv) {
      Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (context) => Chat(
              conversationID: _getConvID(selectedConv) ?? "",
              conversationType: _getConvType(selectedConv),
              conversationShowName: selectedConv.showName ?? "Chat",
            ),
          ));
    }

    return TIMUIKitConversation(
      onTapItem: handleOnConvItemTaped,
    );
  }
}
