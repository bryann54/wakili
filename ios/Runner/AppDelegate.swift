import UIKit
import Flutter
import FirebaseCore
import GoogleSignIn
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Initialize Firebase
    FirebaseApp.configure()
    
    // Initialize Google Maps
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let channel = FlutterMethodChannel(name: "com.yourapp.maps",
                                     binaryMessenger: controller.binaryMessenger)
    
    channel.setMethodCallHandler({
      [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      if call.method == "setApiKey" {
        if let args = call.arguments as? Dictionary<String, Any>,
           let apiKey = args["apiKey"] as? String {
          GMSServices.provideAPIKey(apiKey)
          result(nil)
        } else {
          result(FlutterError(code: "INVALID_ARGUMENTS",
                            message: "API key not provided",
                            details: nil))
        }
      } else {
        result(FlutterMethodNotImplemented)
      }
    })
    
    // Notification center setup
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    }
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  // Handle Google Sign-In URL
  override func application(
    _ app: UIApplication,
    open url: URL,
    options: [UIApplication.OpenURLOptionsKey : Any] = [:]
  ) -> Bool {
    var handled = super.application(app, open: url, options: options)
    
    if !handled {
      handled = GIDSignIn.sharedInstance.handle(url)
    }
    
    return handled
  }
  
  // For older iOS versions
  override func application(
    _ application: UIApplication,
    open url: URL,
    sourceApplication: String?,
    annotation: Any
  ) -> Bool {
    return GIDSignIn.sharedInstance.handle(url)
  }
}