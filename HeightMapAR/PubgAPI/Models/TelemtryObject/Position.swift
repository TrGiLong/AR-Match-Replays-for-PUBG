//
//  Position.swift
//  HeightMapAR
//
//  Created by Tran Giang Long on 08.06.19.
//  Copyright © 2019 Tran Giang Long. All rights reserved.
//

import Foundation

class Position {
    let x, y: Float
    let z: Int
    
    init(json : [String : Any]) {
        x = (json["x"] as! NSNumber).floatValue
        y = (json["y"] as! NSNumber).floatValue
        z = (json["z"] as! NSNumber).intValue
    }
}
