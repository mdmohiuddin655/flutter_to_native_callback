import Flutter
import UIKit
import WidgetKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    handleData(controller: controller);
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func handleData(controller: FlutterViewController){
      let channel = FlutterMethodChannel(name: "nutrition_widget", binaryMessenger: controller.binaryMessenger)
      channel.setMethodCallHandler({
          [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
              
                  // Print method name
                  print("🔵 Method called: \(call.method)")
            if call.method == "updateWidget" {
                  if let args = call.arguments as? [String: Any] {

                      // Print each key-value pair
                      print("📦 Received data:")
                      for (key, value) in args {
                          print("   🔑 Key: \(key)")
                          print("   📄 Value: \(value)")
                          print("   📝 Type: \(type(of: value))")
                          print("   ------------------------")
                      }

                      self?.saveToUserDefaults(data: args)
                      if #available(iOS 14.0, *) {
                          WidgetCenter.shared.reloadAllTimelines()
                          print("✅ Widget timeline reloaded")
                      }
                      result(nil)
                  } else {
                      print("❌ Error: Invalid arguments received")
                      result(FlutterError(code: "INVALID_ARGUMENTS",
                                        message: "Arguments are invalid",
                                        details: nil))
                  }
              } else {
                  print("❌ Error: Method not implemented - \(call.method)")
                  result(FlutterMethodNotImplemented)
              }
          })
  }

  private func saveToUserDefaults(data: [String: Any]) {
      if let userDefaults = UserDefaults(suiteName: "group.com.yourapp.nutrition") {
          for (key, value) in data {
              userDefaults.set(value, forKey: key)
          }
          userDefaults.synchronize()
      }
  }

}
