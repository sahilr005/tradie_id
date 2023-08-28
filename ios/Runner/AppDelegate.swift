import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
    let channel = FlutterMethodChannel(name: "com.example.screenshot/block", binaryMessenger: controller.binaryMessenger)
    
    channel.setMethodCallHandler { (call, result) in
        if call.method == "blockScreenCapture" {
            self.blockScreenCapture()
            result(nil)
        } else {
            result(FlutterMethodNotImplemented)
        }
    }
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func blockScreenCapture() {
    let rootViewController = window?.rootViewController
    
    let blankView = UIView(frame: UIScreen.main.bounds)
    blankView.backgroundColor = .white
    
    rootViewController?.view.addSubview(blankView)
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
        blankView.removeFromSuperview()
    }
  }
}