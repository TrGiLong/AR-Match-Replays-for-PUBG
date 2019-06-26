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
    let imageID : String
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
        
        imageID = getDefaultImageForItemID(id: itemID)
    }
}

private func getDefaultImageForItemID(id : String) -> String {
    var newStr = ""
    
    var index = id.startIndex
    var x = 3;
    while index != id.endIndex {
        if id[index] == "_" {
            x-=1;
        }
        if (x == 0) {
            break
        }
        index = id.index(after: index)
    }
    
    if (index == id.endIndex) { return id }
    
    newStr += String(id[id.startIndex...index])
    newStr += "00"
    newStr += String(id.suffix(6))
    
    return newStr
}
