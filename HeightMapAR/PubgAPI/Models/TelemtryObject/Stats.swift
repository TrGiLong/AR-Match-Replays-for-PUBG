//
//  Stats.swift
//  HeightMapAR
//
//  Created by Tran Giang Long on 08.06.19.
//  Copyright © 2019 Tran Giang Long. All rights reserved.
//

import Foundation

class Stats {
    let killCount: Int
    let distanceOnFoot, distanceOnSwim, distanceOnVehicle, distanceOnParachute: Double
    let distanceOnFreefall: Double
    
    init(json : [String : Any]) {
        killCount = (json["killCount"] as! NSNumber).intValue
        distanceOnFoot = (json["distanceOnFoot"] as! NSNumber).doubleValue
        distanceOnSwim = (json["distanceOnSwim"] as! NSNumber).doubleValue
        distanceOnVehicle = (json["distanceOnVehicle"] as! NSNumber).doubleValue
        distanceOnParachute = (json["distanceOnParachute"] as! NSNumber).doubleValue
        distanceOnFreefall = (json["distanceOnFreefall"] as! NSNumber).doubleValue
    }
}
