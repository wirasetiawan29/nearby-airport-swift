//
//  NearbyAirportTests.swift
//  NearbyAirportTests
//
//  Created by wira on 12/29/19.
//  Copyright © 2019 Wira Setiawan. All rights reserved.
//

import XCTest
import CoreLocation
import MapKit
@testable import NearbyAirport

class PointDelegateDatasourceMock: PointProviderDelegate {

    var didSelectCell: Bool = false
    var result: Result?

    func didSelectCell(result : Result) {

        print("PointProviderDelegate :\(result)")

        didSelectCell = true
        self.result = result
    }
}

class NearbyAirportTests: XCTestCase {

    fileprivate var viewController = ViewController()
    fileprivate var locationModel:LocationModel!
    fileprivate var locationViewModel:LocationViewModel!
    fileprivate let testDelegate = PointDelegateDatasourceMock()


    fileprivate var pointProvider: PointProvider!
    fileprivate var tableView: UITableView!

    override func setUp() {
        locationViewModel = LocationViewModel()
        locationModel = locationViewModel.loadMockData()
        pointProvider = PointProvider(locateModel: locationModel)
        tableView = UITableView()
        tableView.register(PointTableViewCell.self, forCellReuseIdentifier: CellID.pointTableViewCell)
        tableView.dataSource = pointProvider
        tableView.delegate = pointProvider
        pointProvider.placesProviderDelegate = testDelegate


        do {
            locationModel = try LocationModel(data: self.getMockItem())// mock data contains 20 models
        } catch let error {
            print(error)
        }

    }

    func testLocationManager() {
        XCTAssertNotNil(viewController.locationManager)
    }

    func testLocationManagerServicesEnabled() {
        XCTAssertTrue(CLLocationManager.locationServicesEnabled())
    }

     func testRowCount () {
         XCTAssertEqual(pointProvider.tableView(tableView, numberOfRowsInSection: 0), 20)
     }

     func testSectionCount () {
        XCTAssertEqual(pointProvider.numberOfSections(in: tableView), 1)
    }

     func testDistance()  {
         let cllocation1 = CLLocation(latitude: 3.1157063, longitude: 101.6390933)
         let cllocation2 = CLLocation(latitude: 2.7455962, longitude: 101.7071602)
         print(pointProvider.getDistance(location1: cllocation1, location2: cllocation2))
         XCTAssertEqual(pointProvider.getDistance(location1: cllocation1, location2: cllocation2), 41619.46524668598)
     }

    func getMockItem () -> Data{
        var tempData : Data!
        let path = Bundle.main.path(forResource: "Data", ofType: "json")
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path!), options: .mappedIfSafe)
            tempData =  data
        } catch let error{
            print("error\(error)")
        }
        return tempData
    }

    func testMapping () {
        let result = locationModel.results?.first
        XCTAssertEqual(result?.name, "Soekarno-Hatta International Airport")
        XCTAssertEqual(result?.id, "d06ce94ba8b2c414ebaa106d6d341da006f98988")
        XCTAssertEqual(result?.rating, 4.3)
    }

}
