//
//  PointProvider.swift
//  NearbyAirport
//
//  Created by wira on 12/29/19.
//  Copyright © 2019 Wira Setiawan. All rights reserved.
//

import UIKit
import MapKit

protocol PointProviderDelegate {
    func didSelectCell(result: Result)
}

class PointProvider: NSObject,UITableViewDelegate, UITableViewDataSource {

    fileprivate var locateModel:LocationModel!
    fileprivate var map:MKMapView!
    var parentView:PointView!
    var placesProviderDelegate: PointProviderDelegate?

    override init() {}

    init(locateModel:LocationModel) { // for test
        self.locateModel = locateModel
    }

    init(locateModel:LocationModel, map:MKMapView, parentView:PointView!) {
        self.locateModel = locateModel
        self.map = map
        self.parentView = parentView
    }

    func numberOfSections(in tableView: UITableView) -> Int {
          return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.locateModel != nil {
            return self.locateModel.results!.count
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellID.pointTableViewCell, for: indexPath) as! PointTableViewCell
        let result =  locateModel.results?[indexPath.row]
        let cllocation = CLLocation(latitude:  result!.geometry?.location?.lat ?? 0.0, longitude: result!.geometry?.location?.lng ?? 0.0)
        cell.result  = result
        cell.distanceLbl.text   = "\(String(format: "%.2f",getDistance(location1:userLocation,location2: cllocation)/1000)) KM distance"
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let result =  locateModel.results?[indexPath.row] else {
            return
        }

        placesProviderDelegate?.didSelectCell(result: result)
        let location = CLLocationCoordinate2D(latitude: result.geometry?.location?.lat ?? 0.0, longitude: result.geometry?.location?.lng ?? 0.0)
        let cllocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
        let region = MKCoordinateRegion(center: location, latitudinalMeters: 6000, longitudinalMeters: 6000)

        if map != nil {
            map.setRegion(region, animated: true)
        }

        if userLocation != nil {
            showAnnotation(title: result.name ?? "", subtitle: "DISTANCE \(String(format: "%.2f",getDistance(location1:userLocation,location2: cllocation)/1000)) KM", coordinate: location)
        }
    }

    func getDistance(location1:CLLocation,location2:CLLocation)  -> Double {
       return location1.distance(from: location2) // result is in meters
    }

     func showAnnotation(title:String , subtitle:String,coordinate: CLLocationCoordinate2D!) {
        let annotation = MKPointAnnotation()
          annotation.title = title
          annotation.subtitle  = subtitle
          annotation.coordinate = coordinate
          map.addAnnotation(annotation)
    }

     func hidePointView (view:UIView) -> Bool {
        UIView.transition(with:view.superview!, duration: 0.5, options: [.transitionCrossDissolve], animations: {
                view.removeFromSuperview()
                  }, completion: nil)
            return true
    }

}
