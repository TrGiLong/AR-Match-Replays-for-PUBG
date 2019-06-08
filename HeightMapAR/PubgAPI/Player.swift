//
//  Player.swift
//  HeightMapAR
//
//  Created by Tran Giang Long on 08.06.19.
//  Copyright © 2019 Tran Giang Long. All rights reserved.
//

import Foundation

enum PlayerException : Error {
    case initFailed
    case notFound
}

class Player {
    let id : String
    let createdAt : String
    let patchVersion : String
    let shardId : String
    let stats : String?
    let titleId : String
    let updatedAt : String
    
    init(json : [String : Any]) throws {
        
        guard let firstData = json["data"] as? [Any] else {
            throw PlayerException.initFailed
        }
        
        guard let data = firstData.first as? [String : Any] else {
            throw PlayerException.initFailed
        }
        
        guard let id = data["id"] as? String else {
            throw PlayerException.initFailed
        }
        self.id = id
        
        guard let attributes = data["attributes"] as?  [String : Any] else {
            throw PlayerException.initFailed
        }
        
        guard let patchVersion = attributes["patchVersion"] as? String else {
            throw PlayerException.initFailed
        }
        self.patchVersion = patchVersion
        
        guard let createdAt = attributes["createdAt"] as? String else {
            throw PlayerException.initFailed
        }
        self.createdAt = createdAt
        
        if let stats = attributes["stats"] as? String {
            self.stats = stats
        } else {
            self.stats = nil
        }
        
        
        guard let shardId = attributes["shardId"] as? String else {
            throw PlayerException.initFailed
        }
        self.shardId = shardId
        
        guard let titleId = attributes["titleId"] as? String else {
            throw PlayerException.initFailed
        }
        self.titleId = titleId
        
        guard let updatedAt = attributes["titleId"] as? String else {
            throw PlayerException.initFailed
        }
        self.updatedAt = updatedAt
        
    }
}
