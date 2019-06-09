//
//  Location.swift
//  HeightMapAR
//
//  Created by Tran Giang Long on 08.06.19.
//  Copyright © 2019 Tran Giang Long. All rights reserved.
//

import Foundation

class Location {
    let x : Float
    let y : Float
    let z : Float
    
    init(json : [String : Any]) {
        x = (json["x"] as! NSNumber).floatValue
        y = (json["y"] as! NSNumber).floatValue
        z = (json["z"] as! NSNumber).floatValue
    }
}
