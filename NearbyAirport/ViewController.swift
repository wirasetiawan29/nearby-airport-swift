//
//  ViewController.swift
//  NearbyAirport
//
//  Created by wira on 12/29/19.
//  Copyright © 2019 Wira Setiawan. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {

    @IBOutlet var placesProvider: PointProvider!
    @IBOutlet var locationManagerProvider: LocationManagerProvider!
    var pointView:PointView!
    fileprivate let locateViewModel = LocationViewModel()
    @IBOutlet weak var map: MKMapView!
    let locationManager = CLLocationManager()
    @IBOutlet var mapProvider: MapProvider!

    override func viewDidLoad() {

        super.viewDidLoad()
        locationManagerProvider = LocationManagerProvider(map:self.map)
        locationManager.delegate = locationManagerProvider
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.distanceFilter = 1
        locationManager.desiredAccuracy = kCLLocationAccuracyBest

        self.mapProvider = MapProvider()
        self.map.delegate = self.mapProvider
    }

    //MARK: private function
    @objc func close(){
       UIView.transition(with: self.view, duration: 0.5, options: [.transitionCrossDissolve], animations: {
         self.pointView.removeFromSuperview()
       }, completion: nil)
    }

    //MARK: private action
    @IBAction func locate(_ sender: Any) {
        map.zoom()
    }

    @IBAction func showPlaces(_ sender: Any) {
        if self.pointView == nil {
                  // load views

              self.pointView = (PointView.instanceFromNib() as! PointView)
              self.pointView.frame = CGRect(x: 20, y: 200, width: UIScreen.main.bounds.width-40, height: UIScreen.main.bounds.height-400)


              // register cell
              self.pointView.pointTableView.register(UINib(nibName: CellID.pointTableViewCell, bundle: nil), forCellReuseIdentifier: CellID.pointTableViewCell)
              }

        // start loading
        self.pointView.activityIndicatorView.startAnimating()

        // cell view model to fetch places and set liseneer
        locateViewModel.fetchPlaces()
        locateViewModel.fetchPlacesDelegate = self

        // show tableview with animation
        UIView.transition(with: self.view, duration: 0.5, options: [.transitionCrossDissolve], animations: {
            self.view.addSubview(self.pointView)
            self.pointView.closeButton.addTarget(self, action: #selector(self.close), for: .touchUpInside)

        }, completion: nil)
    }

}

extension ViewController:FetchPlacesDelegate {
    func didFetchPlaces(locateModel: LocationModel) {
        self.placesProvider = PointProvider(locateModel: locateModel,map: self.map , parentView: self.pointView)
        DispatchQueue.main.async {
            self.pointView.activityIndicatorView.stopAnimating()
            self.pointView.pointTableView.reloadData()
            self.pointView.pointTableView.delegate = self.placesProvider
            self.pointView.pointTableView.dataSource = self.placesProvider
        }

        locateModel.results?.forEach({
            guard let name = $0.name else {return}
            print(name)
        })
    }
}


