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

class FLocationService: CLLocationManagerDelegate {
    
    
    let locationManager = CLLocationManager()
    let center = UNUserNotificationCenter.current()
    var userAuthStatus : boolean
    var debug:boolean
    var localPushTitle:String = "Location detected 📌"
    var senddNotification:boolean = true
    var updateCallUrl:String
    private var hasUrl:boolean
    
    
    func setOnUpdateCallUrl(url:String){
        updateCallUrl = url
        hasUrl = true
    }
    
    func startMonitoring(){
        print(
            "init plugin. senddNotification:\(senddNotification) updateCallUrl:\(updateCallUrl)"
        )
        guard !senddNotification else{
            print("init notificvation")
            initNotifications()
        }
        initLocation()
    }

    
    private func initLocation(){
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        locationManager.distanceFilter = 2
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.allowsBackgroundLocationUpdates = true
    }
    func initNotifications(){
        center.requestAuthorization(options: [.alert, .sound])
        { (granted, error) in
            print("Permission local push, " + "Error:" + error + " ,granted:" + granted)
        }
    }
    
    
    func sendAlert(body:String){
        let content = UNMutableNotificationContent()
        content.title = localPushTitle
        content.body = body
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "updating location received", content: body, trigger: trigger)
        center.add(request, withCompletionHandler: nil)
    }
    // when location update
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard !senddNotification else {
            let debugAlert = "Location updated Set debug to falser to aviod this message" + locations.last?.coordinate.latitude + locations.last?.coordinate.longitude
            sendAlert(body: debugAlert)
        }
    }
    
 
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if(status!=CLAuthorizationStatus.restricted && CLAuthorizationStatus.denied && CLAuthorizationStatus.notDetermined){
            userAuthStatus = false
            print("CLAuthorizationStatus YOU dont have user permission for location. eaw permission native status:" + status)
        }
        else{
            print("Location permission allowd")
            locationStatus = true
            locationManager.startUpdatingLocation()
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
}


