//
//  Character.swift
//  HeightMapAR
//
//  Created by Tran Giang Long on 08.06.19.
//  Copyright © 2019 Tran Giang Long. All rights reserved.
//

import Foundation

class Character {
    let name :         String
    let teamId :       Int
    let health :       Float
    let location :     Location
    let ranking :      Int
    let accountId :    String
    let isInBlueZone : Bool
    let isInRedZone :  Bool
    let zone :         [String]
    
    init(json : [String : Any]) {
        name = json["name"] as! String
        teamId = (json["teamId"] as! NSNumber).intValue
        health = (json["health"] as! NSNumber).floatValue
        location = Location(json: json["location"] as! [String : Any])
        ranking = (json["ranking"] as! NSNumber).intValue
        accountId = json["accountId"] as! String
        isInBlueZone = (json["isInBlueZone"] as! NSNumber).boolValue
        isInRedZone = (json["isInRedZone"] as! NSNumber).boolValue
        zone = json["zone"] as! [String] 
    }
}
