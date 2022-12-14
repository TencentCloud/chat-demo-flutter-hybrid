// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:tencent_chat_module/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

class MockCounterModel extends ChangeNotifier implements CounterModel {
  int _count = 0;

  @override
  int get count => _count;

  @override
  void increment() {
    _count++;
    notifyListeners();
  }
}

void main() {
  testWidgets('MiniView smoke test', (tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<CounterModel>.value(
          value: MockCounterModel(),
          child: const Contents(),
        ),
      ),
    );

    // Verify that our counter starts at 0.
    expect(find.text('Taps: 0'), findsOneWidget);
    expect(find.text('Taps: 1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.text('Tap me!'));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('Taps: 0'), findsNothing);
    expect(find.text('Taps: 1'), findsOneWidget);
  });
}
