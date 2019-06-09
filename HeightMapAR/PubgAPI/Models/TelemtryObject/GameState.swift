//
//  GameState.swift
//  HeightMapAR
//
//  Created by Tran Giang Long on 08.06.19.
//  Copyright © 2019 Tran Giang Long. All rights reserved.
//

import Foundation

class GameState {
    let elapsedTime, numAliveTeams, numJoinPlayers, numStartPlayers: Int
    let numAlivePlayers: Int
    let safetyZonePosition: Position
    let safetyZoneRadius: Float
    let poisonGasWarningPosition: Position
    let poisonGasWarningRadius: Float
    let redZonePosition: Position
    let redZoneRadius: Float
    
    init(json : [String : Any]) {
        self.elapsedTime = (json["elapsedTime"] as! NSNumber).intValue
        self.numAliveTeams = (json["numAliveTeams"] as! NSNumber).intValue
        self.numJoinPlayers = (json["numJoinPlayers"] as! NSNumber).intValue
        self.numStartPlayers = (json["numStartPlayers"] as! NSNumber).intValue
        self.numAlivePlayers = (json["numAlivePlayers"] as! NSNumber).intValue
        self.safetyZonePosition = Position(json: json["safetyZonePosition"] as! [String : Any])
        self.safetyZoneRadius = (json["safetyZoneRadius"] as! NSNumber).floatValue
        self.poisonGasWarningPosition = Position(json: json["poisonGasWarningPosition"] as! [String : Any])
        self.poisonGasWarningRadius = (json["poisonGasWarningRadius"] as! NSNumber).floatValue
        self.redZonePosition = Position(json: json["redZonePosition"] as! [String : Any])
        self.redZoneRadius = (json["redZoneRadius"] as! NSNumber).floatValue
    }
}
