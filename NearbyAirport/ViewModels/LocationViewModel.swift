//
//  LocationViewModel.swift
//  NearbyAirport
//
//  Created by wira on 12/29/19.
//  Copyright © 2019 Wira Setiawan. All rights reserved.
//

import UIKit
import CoreLocation
import GooglePlaces

protocol FetchPlacesDelegate {
    func didFetchPlaces(locateModel:LocationModel)
}

class LocationViewModel {

    var fetchPlacesDelegate:FetchPlacesDelegate?
    fileprivate var placesClient: GMSPlacesClient!

    init() {
        GMSPlacesClient.provideAPIKey(KEY)
        placesClient = GMSPlacesClient.shared()
    }

    func loadMockData () -> LocationModel{
        var locationModel:LocationModel!
           if let path = Bundle.main.path(forResource: "Data", ofType: "json") {
               do {
                    let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                    locationModel = try JSONDecoder().decode(LocationModel.self, from: data)

                print(locationModel!)

                 } catch let error{
                    print("error\(error)")
                      // handle error
                 }
           }

        return locationModel
    }

    func getGooglePlaces(completion: @escaping (LocationModel) -> Void) {

        var strGoogleApi = "https://maps.googleapis.com/maps/api/place/textsearch/json?query=\(KEYWORD)&key=\(KEY)"
        strGoogleApi = strGoogleApi.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!

        var urlRequest = URLRequest(url: URL(string: strGoogleApi)!)
        urlRequest.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: urlRequest) { (data, resopnse, error) in
            if error == nil {
                do {
                    let locationModel  = try! LocationModel(data: data!)
                    completion(locationModel)
                }
            } else {
                print("Connection issue")
            }
        }
        task.resume()
    }

    func fetchPlaces () {
        self.getGooglePlaces { (locateModel) in
        self.fetchPlacesDelegate?.didFetchPlaces(locateModel: locateModel)

        }
    }

}
