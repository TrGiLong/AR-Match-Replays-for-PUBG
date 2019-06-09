//
//  Vehicle.swift
//  HeightMapAR
//
//  Created by Tran Giang Long on 08.06.19.
//  Copyright © 2019 Tran Giang Long. All rights reserved.
//

import Foundation

class Vehicle {
    let vehicleType: String
    let vehicleID: String
    let healthPercent, feulPercent: Float
    
    init(json : [String : Any]) {
        vehicleType = json["vehicleType"] as! String
        vehicleID = json["vehicleType"] as! String
        healthPercent = (json["healthPercent"] as! NSNumber).floatValue
        feulPercent = (json["feulPercent"] as! NSNumber).floatValue
    }
}
