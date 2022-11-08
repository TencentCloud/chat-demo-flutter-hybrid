
import 'package:flutter/material.dart';
import 'package:tencent_chat_module/call/model.dart';
import 'package:provider/provider.dart';
import 'package:tim_ui_kit_calling_plugin/tim_ui_kit_calling_plugin.dart';

class CallAPP extends StatelessWidget{
  const CallAPP({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tencent Cloud Call',
      navigatorKey: TUICalling.navigatorKey,
      home: const CallMainView(),
    );
  }
}

class CallMainView extends StatelessWidget {
  const CallMainView({super.key});

  @override
  Widget build(BuildContext context) {
    final CallInfoModel callInfoModel = Provider.of<CallInfoModel>(context);
    callInfoModel.context ??= context;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.transparent
        ),
      ),
    );
  }
}