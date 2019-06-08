//
//  Match.swift
//  HeightMapAR
//
//  Created by Tran Giang Long on 08.06.19.
//  Copyright © 2019 Tran Giang Long. All rights reserved.
//

import Foundation

class Match {
    let type : String
    let id : String
    
    init(json : [String : String]) {
        id = json["id"]!
        type = json["type"]!
    }
}
