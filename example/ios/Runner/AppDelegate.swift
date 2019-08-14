import UIKit
import Flutter
import UserNotifications
import CoreLocation



@available(iOS 10.0, *)
@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
    let locationManager = CLLocationManager()
    let center = UNUserNotificationCenter.current()
    var authorized = false
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        let bglocation = FlutterMethodChannel(name: "geofences_backgound_location/locations",
                                              binaryMessenger: controller as! FlutterBinaryMessenger)
        
        
        bglocation.setMethodCallHandler({
            (call:FlutterMethodCall,result:FlutterResult)->Void in
            guard call.method=="initLocation" else{
                result(FlutterMethodNotImplemented)
                return
            }
            self.requestPermissionLocalization(result:result)
        })
        
        bglocation.setMethodCallHandler({
            (call: FlutterMethodCall,result:@escaping FlutterResult)-> Void in
            guard call.method=="initNotifications" else{
                result(FlutterMethodNotImplemented)
                return
            }
            self.initNotifications(result:result)
        })
        
        bglocation.setMethodCallHandler({
            (call: FlutterMethodCall, result: FlutterResult) -> Void in
            
            guard call.method=="getPosition" else {
                result (FlutterMethodNotImplemented)
                return
            }
            self.getPosition(result:result)
        })
        
        GeneratedPluginRegistrant.register(with: self)
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    
    private func getPosition(result: FlutterResult) {
        result("Hello plugin - from swift")
    }
    
    func initNotifications(result:@escaping FlutterResult){
        center.requestAuthorization(options: [.alert, .sound])
        { (granted, error) in
            result(granted)
        }
    }
    
    func requestPermissionLocalization(result:FlutterResult){
        result("Initializing request for localizations")
        locationManager.requestAlwaysAuthorization()
    }
}


@available(iOS 10.0, *)
extension AppDelegate:CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didVisit visit: CLVisit) {
        print("location manager received")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Update location")
        let content = UNMutableNotificationContent()
        content.title = "Location detected 📌"
        content.body = "Locations descriptuon alert"
        content.sound = .default()
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "location.dateString", content: content, trigger: trigger)
        center.add(request, withCompletionHandler: nil)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if(status == CLAuthorizationStatus.authorizedAlways){
            authorized = true
            locationManager.delegate = self
            locationManager.distanceFilter = 2
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.allowsBackgroundLocationUpdates = true
            locationManager.startUpdatingLocation()
        }
        else {
            print("user dont authorized always location")
        }
        
    }
    
}
