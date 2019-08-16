import UIKit
import Flutter
import UserNotifications
import CoreLocation



@available(iOS 10.0, *)
@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    var locations_service: FLocationService?
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        let locations = FlutterMethodChannel(name: "dl.geofences.flutter/locations",
                                              binaryMessenger: controller as! FlutterBinaryMessenger)
        
        locations_service = FLocationService()
        
        
        
        locations.setMethodCallHandler({
            (call:FlutterMethodCall,result:FlutterResult)->Void in
            if (call.method=="initLocation")
            {
                self.locations_service?.startMonitoring()
                
            }
            else{
                result(FlutterMethodNotImplemented)
                return
            }
            
        })
        
        
        GeneratedPluginRegistrant.register(with: self)
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
}
    

