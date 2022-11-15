//
//  FlutterUtils.swift
//  IOSFullScreen
//
//  Created by 王润霖 on 2022/11/1.
//

import Foundation
import UIKit
import Flutter
import FlutterPluginRegistrant
import Photos
import ImSDK_Plus

struct ChatInfo: Codable {
    // Please generate `userSig` in your project, recommended on your server, while the hard code here is only for demonstration purpose.
    // 实际项目中，这里的userSig必须动态获取，最好通过服务端获取。这里的写死，仅用于演示。
    var sdkappid: String = ""
    var userSig: String = ""
    var userID: String = ""
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
    
    var chatMethodChannel : FlutterMethodChannel?
    var callMethodChannel : FlutterMethodChannel?
    
    var chatFlutterEngine : FlutterEngine?
    var callFlutterEngine : FlutterEngine?
    
    var chatInfo: ChatInfo = ChatInfo()
    var mainView: UIViewController?
    
    // Make sure the class has only one instance
    // Should not init or copy outside
    private override init() {
        super.init()
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        // Flutter - Chat
        chatFlutterEngine = appDelegate.flutterEngines.makeEngine(withEntrypoint: "chatMain", libraryURI: nil)
        GeneratedPluginRegistrant.register(with: chatFlutterEngine!)
        chatMethodChannel = FlutterMethodChannel(name: "com.tencent.flutter.chat",
                                                 binaryMessenger: chatFlutterEngine!.binaryMessenger)
        chatMethodChannel?.setMethodCallHandler({ [weak self]
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            if let strongSelf = self {
                switch(call.method) {
                case "requestChatInfo":
                    strongSelf.reportChatInfo()
                    break
                case "launchChat":
                    strongSelf.launchChatFunc()
                    break
                case "voiceCall":
                    strongSelf.triggerVoiceCall(callInfo: call.arguments as! String)
                    break
                case "videoCall":
                    strongSelf.triggerVideoCall(callInfo: call.arguments as! String)
                    break
                default:
                    print("Unrecognized method name: \(call.method)")
                }
            }
        })
        
        // Flutter - Call
        callFlutterEngine = appDelegate.flutterEngines.makeEngine(withEntrypoint: "callMain", libraryURI: nil)
        GeneratedPluginRegistrant.register(with: callFlutterEngine!)
        callMethodChannel = FlutterMethodChannel(name: "com.tencent.flutter.call",
                                                 binaryMessenger: callFlutterEngine!.binaryMessenger)
        callMethodChannel?.setMethodCallHandler({ [weak self]
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            if let strongSelf = self {
                switch(call.method) {
                case "requestCallInfo":
                    strongSelf.reportCallInfo()
                    break
                case "launchCall":
                    strongSelf.launchCallFunc()
                    break
                case "endCall":
                    strongSelf.endCallFunc()
                    break
                default:
                    print("Unrecognized method name: \(call.method)")
                }
            }
        })
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
        chatMethodChannel?.invokeMethod("reportChatInfo", arguments: chatInfo.toJSONString())
    }
    
    func reportCallInfo() {
        callMethodChannel?.invokeMethod("reportCallInfo", arguments: chatInfo.toJSONString())
    }
    
    func launchChatFunc(){
        if self.chatFlutterEngine != nil && self.chatFlutterEngine!.viewController == nil {
            let flutterViewController = FlutterViewController(engine: self.chatFlutterEngine!, nibName: nil, bundle: nil)
            self.mainView?.navigationController?.pushViewController(flutterViewController, animated: true)
        }
    }
    
    func launchCallFunc(){
        if self.callFlutterEngine != nil && self.callFlutterEngine!.viewController == nil {
            let flutterViewController = FlutterViewController(engine: self.callFlutterEngine!, nibName: nil, bundle: nil)
            mainView?.present(flutterViewController, animated: true, completion: nil)
        }
    }
    
    func endCallFunc(){
        if self.callFlutterEngine != nil && self.callFlutterEngine!.viewController != nil {
            self.callFlutterEngine!.viewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    func triggerNotification(msg: String){
        launchChatFunc()
        chatMethodChannel?.invokeMethod("notification", arguments: msg)
    }
    
    func triggerVoiceCall(callInfo: String) {
        callMethodChannel?.invokeMethod("voiceCall", arguments: callInfo)
        self.launchCallFunc()
    }
    
    func triggerVideoCall(callInfo: String) {
        callMethodChannel?.invokeMethod("videoCall", arguments: callInfo)
        self.launchCallFunc()
    }
}
