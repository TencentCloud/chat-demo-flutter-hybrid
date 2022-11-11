// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import UIKit
import Flutter
import Photos

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        FlutterUtils.shared.initViewController(mainViewController: self)
        FlutterUtils.shared.initTencentChat()
    }


    @IBAction func launchTUIKit(_ sender: Any) {
        FlutterUtils.shared.launchChatFunc()
    }
}
