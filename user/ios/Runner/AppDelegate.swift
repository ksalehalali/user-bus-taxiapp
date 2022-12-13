import UIKit
import Flutter
import GoogleMaps
import Firebase

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure()
//     GMSServices.provideAPIKey("AIzaSyClqlqaLijNqiCRSIYuSRl5DayRhSdXGyE")
    GMSServices.provideAPIKey("AIzaSyCcAHa78kdTUAZBKF7m2SQheNXfAuOSghc")
    GeneratedPluginRegistrant.register(with: self)
 UIApplication.shared.beginReceivingRemoteControlEvents()
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
var bgTask: UIBackgroundTaskIdentifier = UIBackgroundTaskIdentifier(rawValue: 0);
    override func applicationDidEnterBackground(_ application: UIApplication) {
                bgTask = application.beginBackgroundTask()
    }
    override func applicationDidBecomeActive(_ application: UIApplication) {
        application.endBackgroundTask(bgTask);
        application.applicationIconBadgeNumber = 0;
    }
}
