//
//  FlutterUtils.swift
//  IOSFullScreen
//
//  Created by 王润霖 on 2022/11/1.
//

import Foundation
import UIKit
import Flutter
import Photos

struct ChatInfo: Codable {
    var sdkappid: String = "1400187352"
    var userSig: String = "eJyrVgrxCdYrSy1SslIy0jNQ0gHzM1NS80oy0zLBwpam5gYWpqZGFlDJ4pTsxIKCzBQlK0MTAwNDC3NjUyOITElmbipQ1MzMHChoaWQIEU2tKMgsAoqbGYAA1IzMdKDJxua5ZV4ZiVmGoX6BHjnJiU6lSdrGPnmlpiF*BS4mgYWOqYHZYYV*ZqHGnrZKtQDe9zCL"
    var userID: String = "957085528"
}

public extension Encodable {
    func toJSONString() -> String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        guard let data = try? encoder.encode(self) else{ return "" }
        guard let jsonStr = String(data: data, encoding: .utf8) else{ return "" }
        return jsonStr
    }
}

class FlutterUtils: NSObject {

    static let shared = FlutterUtils()
    
    var methodChannel : FlutterMethodChannel?
    var chatInfo: ChatInfo = ChatInfo()
    var mainView: UIViewController?
    
    // Make sure the class has only one instance
    // Should not init or copy outside
    private override init() {
        super.init()
        if let flutterEngine = (UIApplication.shared.delegate as? AppDelegate)?.flutterEngine {
            methodChannel = FlutterMethodChannel(name: "com.tencent.chat/add-to-app",
                                                 binaryMessenger: flutterEngine.binaryMessenger)
            methodChannel?.setMethodCallHandler({ [weak self]
                (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
                if let strongSelf = self {
                    switch(call.method) {
                    case "requestChatInfo":
                        strongSelf.reportChatInfo()
                    case "launchChat":
                        strongSelf.launchChatFunc()
                    default:
                        print("Unrecognized method name: \(call.method)")
                    }
                }
            })
        }
    }
    
    override func copy() -> Any {
        return self // FlutterUtils.shared
    }
    
    override func mutableCopy() -> Any {
        return self // FlutterUtils.shared
    }
    
    func initViewController(mainViewController: UIViewController){
        self.mainView = mainViewController
    }
    
    func reportChatInfo() {
        methodChannel?.invokeMethod("reportChatInfo", arguments: chatInfo.toJSONString())
    }
    
    func launchChatFunc(){
        if let flutterEngine = (UIApplication.shared.delegate as? AppDelegate)?.flutterEngine {
            if(flutterEngine.viewController == nil){
                let flutterViewController = FlutterViewController(engine: flutterEngine, nibName: nil, bundle: nil)
                mainView?.present(flutterViewController, animated: true, completion: nil)
            }
        }
    }
    
    func triggerNotification(msg: String){
        launchChatFunc()
        methodChannel?.invokeMethod("notification", arguments: msg)
    }
}
