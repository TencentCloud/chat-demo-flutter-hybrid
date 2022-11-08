// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

class MockCounterModel extends ChangeNotifier  {
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

}
