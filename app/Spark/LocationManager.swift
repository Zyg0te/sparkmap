//
//  LocationManager.swift
//  Spark
//
//  Created by Edvard Holst on 01/11/15.
//  Copyright © 2015 Zygote Labs. All rights reserved.
//

import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager?
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Location has been updated.
        if let location = locations.last {
            // let currentLocation = location.coordinate
            let locationCoordinate: CLLocationCoordinate2D = location.coordinate
            NSNotificationCenter.defaultCenter().postNotificationName("LocationUpdate", object: nil, userInfo: ["latitude": locationCoordinate.latitude, "longitude": locationCoordinate.longitude])
            // Stop location update
            self.locationManager?.stopUpdatingLocation()
        }
        
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        // Authorization has been responded to by the user.
        switch status {
        case CLAuthorizationStatus.AuthorizedWhenInUse:
            startLocationUpdate()
            NSNotificationCenter.defaultCenter().postNotificationName("LocationAuthorized", object: nil, userInfo: ["isAuthorized": true])
        default:
            break
            
        }
    }
    
    
    func stopLocationUpdate(){
        locationManager?.stopUpdatingLocation()
    }
    
    func requestStartLocationUpdate(){
        let authStatus = CLLocationManager.authorizationStatus()
        
        switch authStatus {
        case CLAuthorizationStatus.AuthorizedWhenInUse:
            // Permission already granted
            locationManager = CLLocationManager()
            locationManager?.delegate = self
            startLocationUpdate()
            
            
        default:
            // Request permission
            locationManager = CLLocationManager()
            locationManager?.delegate = self
            locationManager?.requestWhenInUseAuthorization()
        }
    }
    
    func startLocationUpdate() {
        locationManager?.desiredAccuracy = 50
        locationManager?.distanceFilter = 100
        locationManager?.startUpdatingLocation()
    }
    
}
