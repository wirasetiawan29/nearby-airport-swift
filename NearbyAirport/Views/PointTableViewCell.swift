//
//  PointTableViewCell.swift
//  NearbyAirport
//
//  Created by wira on 12/29/19.
//  Copyright © 2019 Wira Setiawan. All rights reserved.
//

import UIKit

class PointTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLbl:UILabel!
    @IBOutlet weak var latLbl:UILabel!
    @IBOutlet weak var longLbl:UILabel!
    @IBOutlet weak var distanceLbl:UILabel!

    var result : Result! {
        didSet {
            nameLbl.text  = result?.name ?? ""
            latLbl.text    = "Lattitude : \(result?.geometry?.location?.lat ?? 0.0)"
            longLbl.text   = "Longitude : \(result?.geometry?.location?.lng ?? 0.0)"
        }
    }
}
