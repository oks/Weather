//
//  LocationService.swift
//  Weather
//
//  Created by Oksana Kovalchuk on 11/1/17.
//  Copyright © 2017 ANODA. All rights reserved.
//

import Foundation
import CoreLocation

public typealias LocationCompletion = (Error?, CLLocationCoordinate2D?) -> ()

class LocationService: NSObject {
    
    let locationManager = CLLocationManager()
    var completion: LocationCompletion?
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func load(completion: @escaping LocationCompletion) {
        self.completion = completion
        
        handleStatus(CLLocationManager.authorizationStatus())
        
    }
    
    func handleStatus(_ status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedAlways,
             .authorizedWhenInUse:
            locationManager.startMonitoringSignificantLocationChanges()
        default:
            //return error
            break
        }
    }
}


extension LocationService: CLLocationManagerDelegate {
    
    internal func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        completion?(error, nil)
    }
    
    internal func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        completion?(nil, locations.last?.coordinate)
    }
    
    internal func locationManager(_ manager: CLLocationManager,
                                  didChangeAuthorization status: CLAuthorizationStatus) {
        
        handleStatus(status)
//
//        var hasAuthorised = false
//        switch status {
//        case CLAuthorizationStatus.restricted:
////            locationStatus = "Restricted Access"
//        case CLAuthorizationStatus.denied:
////            locationStatus = "Denied access"
//        case CLAuthorizationStatus.notDetermined:
////            locationStatus = "Not determined"
//        default:
////            locationStatus = "Allowed access"
//            hasAuthorised = true
//        }
//
//        if (hasAuthorised == true) {
////            startLocationManger()
//        } else {
//
//        }
        
    }
}
