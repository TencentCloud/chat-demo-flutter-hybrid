import 'package:flutter/material.dart';
import 'package:tencent_chat_module/call/call_main.dart';
import 'package:tencent_chat_module/call/model.dart';
import 'package:tencent_chat_module/chat/chat_main.dart';
import 'package:provider/provider.dart';

import 'chat/model.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: Container(),
  ));
}

/// The entrypoint for the flutter chat module.
@pragma('vm:entry-point')
void chatMain() {
  // This call ensures the Flutter binding has been set up before creating the
  // MethodChannel-based model.
  WidgetsFlutterBinding.ensureInitialized();

  final model = ChatInfoModel();

  runApp(
    ChangeNotifierProvider.value(
      value: model,
      child: const ChatAPP(),
    ),
  );
}

/// The entrypoint for the flutter chat module.
@pragma('vm:entry-point')
void callMain() {
  // This call ensures the Flutter binding has been set up before creating the
  // MethodChannel-based model.
  WidgetsFlutterBinding.ensureInitialized();

  final model = CallInfoModel();

  runApp(
    ChangeNotifierProvider.value(
      value: model,
      child: const CallAPP(),
    ),
  );
}
