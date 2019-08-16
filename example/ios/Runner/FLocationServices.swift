//
//  FLocationServices.swift
//  Runner
//
//  Created by Dannylo Dangel on 15/08/19.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import UserNotifications

class FLocationService:NSObject, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    var hasLocationPermission  = false
    var debug = true
    var localPushTitle:String = "Location detected 📌"
    var senddNotification = false
    var updateCallUrl:String = ""
    private var hasUrl = false
    let center = UNUserNotificationCenter.current()
    var lastLocation = [CLLocation]()
    

    
    
    override init() {
        
    }
    
    
    func startMonitoring(url:String){
        updateCallUrl = url
        print(
            "init plugin. senddNotification:\(senddNotification) updateCallUrl:\(updateCallUrl)"
        )
        
        if(senddNotification){
            print("Initializing notification asking for permission")
            initNotifications()
        }
        
        initLocation()
    }

    
    private func initLocation(){
        print("Starting init location ")
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
    }
    func initNotifications(){
        center.requestAuthorization(options: [.alert, .sound]){
            granted, error in
            print("Notification request status: \(granted)" )
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Location updated.")
        lastLocation = locations
        sendPositionToSlack()
        if(senddNotification){
            let debugAlert = "Location updated Set senddNotification to false to avoid this alert. Lat: \(String(describing: locations.last?.coordinate.latitude)) Long:\(String(describing: locations.last?.coordinate.longitude))"
            sendAlert(body: debugAlert)
        }
    }
    func sendAlert(body:String){
        let content = UNMutableNotificationContent()
        content.title = localPushTitle
        content.body = body
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "updating location received", content: content, trigger: trigger)
        center.add(request, withCompletionHandler: nil)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("Changing locations permission")
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                print("CLAuthorizationStatus user dont allow location permission")
                hasLocationPermission = false
            case .authorizedAlways, .authorizedWhenInUse:
                print("Location permission allowd")
                hasLocationPermission = true
            @unknown default:
               print("Unknow location permission")
            }
        } else {
            print("Location services are not enabled")
        }
        
    }
    
    func sendPositionToSlack(){
        print("Sending to slack")
        let parameters = ["text": "Lat: \(String(describing: lastLocation.last?.coordinate.latitude)) Long:\(String(describing: lastLocation.last?.coordinate.longitude))"] as [String : String]
        let url = URL(string:updateCallUrl)
        var  request = URLRequest(url:url!)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let session = URLSession.shared
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
        }
        
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard error == nil else {
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    print(json)
                    
                }
            } catch let error {
                print(error.localizedDescription)
            }
        })
        task.resume()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("didFailWithError:")
        print(error)
    }
    
}


