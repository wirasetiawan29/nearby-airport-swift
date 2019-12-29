//
//  LocationManagerProvider.swift
//  NearbyAirport
//
//  Created by wira on 12/29/19.
//  Copyright © 2019 Wira Setiawan. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class LocationManagerProvider: NSObject, CLLocationManagerDelegate {

    fileprivate var map: MKMapView!

    override init() {}

    init(map:MKMapView) {
        self.map = map
        self.map.showsUserLocation = true
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // allow map to show user location on two status aitherzation (authorizedAlways or authorizedWhenInUse)
        self.map.showsUserLocation = status == .authorizedAlways || status == .authorizedWhenInUse
    }

    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
           print("Failed for getting region with identifier: \(region!.identifier)")
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
           print("Failed for getting location with error: \(error)")
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Failed for getting location with error: \(locations)")
        userLocation = locations.last
    }
}
