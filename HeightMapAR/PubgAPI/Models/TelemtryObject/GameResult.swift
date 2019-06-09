//
//  File.swift
//  HeightMapAR
//
//  Created by Tran Giang Long on 08.06.19.
//  Copyright © 2019 Tran Giang Long. All rights reserved.
//

import Foundation

class GameResult {
    let rank: Int
    let gameResult: String
    let teamID: Int
    let stats: Stats
    let accountID: String
    
    init(json : [String : Any]) {
        rank = (json["rank"] as! NSNumber).intValue
        gameResult = json["gameResult"] as! String
        teamID = (json["teamId"] as! NSNumber).intValue
        stats = Stats(json: json["stats"] as! [String : Any])
        accountID = json["accountId"] as! String
    }
}
