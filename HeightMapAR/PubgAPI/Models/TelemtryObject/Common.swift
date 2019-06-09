//
//  Common.swift
//  HeightMapAR
//
//  Created by Tran Giang Long on 08.06.19.
//  Copyright © 2019 Tran Giang Long. All rights reserved.
//

import Foundation

class Common {
    let isGame: Float
    
    init(json : [String : Any]) {
        self.isGame = (json["isGame"] as! NSNumber).floatValue
    }
}
