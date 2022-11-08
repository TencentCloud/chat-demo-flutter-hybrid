
import 'package:flutter/material.dart';
import 'package:tencent_chat_module/chat/conversation.dart';
import 'package:tencent_chat_module/chat/model.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:tim_ui_kit_calling_plugin/tim_ui_kit_calling_plugin.dart';

/// The "app" displayed by this module.
///
/// It offers two routes, one suitable for displaying as a full screen and
/// another designed to be part of a larger UI.class MyApp extends StatelessWidget {
class ChatAPP extends StatelessWidget {
  const ChatAPP({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tencent Cloud Chat',
      routes: {
        '/': (context) => const ChatMainView(),
        '/mini': (context) => const Contents(),
      },
    );
  }
}

/// Wraps [Contents] in a Material [Scaffold] so it looks correct when displayed
/// full-screen.
class ChatMainView extends StatelessWidget {
  const ChatMainView({super.key});

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
