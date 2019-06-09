//
//  ItemElement.swift
//  HeightMapAR
//
//  Created by Tran Giang Long on 08.06.19.
//  Copyright © 2019 Tran Giang Long. All rights reserved.
//

import Foundation

class Item {
    let itemID: String
    let stackCount: Int
    let category: String
    let subCategory: String
    let attachedItems: [String]
    
    init(json : [String : Any]) {
        self.itemID = json["itemId"] as! String
        self.stackCount = (json["stackCount"] as! NSNumber).intValue
        self.category = json["category"] as! String
        self.subCategory = json["subCategory"] as! String
        self.attachedItems = json["attachedItems"] as! [String]
    }
}
