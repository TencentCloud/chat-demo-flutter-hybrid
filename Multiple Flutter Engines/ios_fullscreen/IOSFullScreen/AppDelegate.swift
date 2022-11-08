// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import UIKit
import Flutter
// Used to connect plugins (only if you have plugins with iOS platform code).
import FlutterPluginRegistrant

extension Dictionary {
    var jsonStringRepresentaiton: String? {
        guard let theJSONData = try? JSONSerialization.data(withJSONObject: self,
                                                            options: [.prettyPrinted]) else {
            return nil
        }

        return String(data: theJSONData, encoding: .ascii)
    }
}

@UIApplicationMain
class AppDelegate: FlutterAppDelegate {
  lazy var flutterEngines = FlutterEngineGroup(name: "chat.flutter.tencent", project: nil)

  override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
      
      if #available(iOS 10.0, *) {
        UNUserNotificationCenter.current().delegate = self
      }
      
      if let remoteNotification = launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification]{
          let notificationExt: [AnyHashable:Any] = remoteNotification as! [AnyHashable:Any]
          let remoteNotificationString: String = notificationExt.jsonStringRepresentaiton ?? "{}"
          FlutterUtils.shared.triggerNotification(msg: remoteNotificationString)
      }
      
    return super.application(application, didFinishLaunchingWithOptions: launchOptions);
  }
    
    override func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let notificationExt: Dictionary = response.notification.request.content.userInfo
        let notificationExtString: String = notificationExt.jsonStringRepresentaiton ?? "{}"
        FlutterUtils.shared.triggerNotification(msg: notificationExtString)
    }
    
}
