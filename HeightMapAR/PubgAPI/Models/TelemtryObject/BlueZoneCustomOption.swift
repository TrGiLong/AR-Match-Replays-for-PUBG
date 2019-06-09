//
//  BlueZoneCustomOption.swift
//  HeightMapAR
//
//  Created by Tran Giang Long on 08.06.19.
//  Copyright © 2019 Tran Giang Long. All rights reserved.
//

import Foundation

class BlueZoneCustomOptions {
    static func parse(string : String) -> [BlueZoneCustomOption] {
        let json = try! JSONSerialization.jsonObject(with: string.data(using: .utf8)!, options: []) as! [[String : Any]]
        
        var list : [BlueZoneCustomOption] = []
        for sub in json {
            list.append(BlueZoneCustomOption(json: sub))
        }
        
        return list
    }
}

class BlueZoneCustomOption {
    let phaseNum :                 Int
    let startDelay :               Int
    let warningDuration :          Int
    let releaseDuration :          Int
    let poisonGasDamagePerSecond : Float
    let radiusRate :               Float
    let spreadRatio :              Float
    let landRatio :                Float
    let circleAlgorithm :          Int
    
    init(json : [String : Any]) {
        phaseNum = json["phaseNum"] as! Int
        startDelay = json["startDelay"] as! Int
        warningDuration = json["warningDuration"] as! Int
        releaseDuration = json["releaseDuration"] as! Int
        circleAlgorithm = json["circleAlgorithm"] as! Int
        poisonGasDamagePerSecond = json["poisonGasDamagePerSecond"] as! Float
        radiusRate = json["radiusRate"] as! Float
        spreadRatio = json["spreadRatio"] as! Float
        landRatio = json["landRatio"] as! Float
    }
}
