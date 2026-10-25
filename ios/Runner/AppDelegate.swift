import Flutter
import UIKit
import workmanager_apple

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Periyodik senkron (lib/app/background_sync.dart). Kimlik Info.plist'teki
    // BGTaskSchedulerPermittedIdentifiers ile aynı; iOS 15 dakikadan önce
    // başlatmaz, zamanı kullanıma göre kendisi seçer.
    WorkmanagerPlugin.setPluginRegistrantCallback { registry in
      GeneratedPluginRegistrant.register(with: registry)
    }
    WorkmanagerPlugin.registerPeriodicTask(
      withIdentifier: "com.abdullahtutun.mobilarici.sync",
      earliestBeginInSeconds: NSNumber(value: 15 * 60)
    )
    // Çıkarma hatırlatıcısı (flutter_local_notifications) uygulama açıkken
    // de görünsün.
    UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
  }
}
