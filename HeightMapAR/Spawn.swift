//
//  Spawn.swift
//  HeightMapAR
//
//  Created by Tran Giang Long on 07.06.19.
//  Copyright © 2019 Tran Giang Long. All rights reserved.
//

import UIKit

enum VehicleType {
    case car
    case boot
}

struct VehicleSpawn {
    var x    : Float
    var y    : Float
    var type : VehicleType
}

class Vehicles {
    static func list() -> [VehicleSpawn]? {
        guard let url = Bundle.main.url(forResource: "spawns", withExtension: "json") else { return nil }
        guard let data = try? Data(contentsOf: url) else { return nil }
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: [[String:Any]]] else { return nil }
        
        
        var list : [VehicleSpawn] = []
        if let vehicles = json["vehicles"] {
            for vehicle in vehicles {
                list.append(VehicleSpawn(x: (vehicle["x"] as! NSNumber).floatValue, y: (vehicle["y"] as! NSNumber).floatValue, type: .car))
            }
        } else {
            print("Not found cars")
        }
        
        
        if let vehicles = json["boats"] {
            for vehicle in vehicles {
                list.append(VehicleSpawn(x: (vehicle["latitude"] as! NSNumber).floatValue, y: (vehicle["longitude"] as! NSNumber).floatValue, type: .boot))
            }
        } else {
            print("Not found boats")
        }
        
        return list
    }
}
