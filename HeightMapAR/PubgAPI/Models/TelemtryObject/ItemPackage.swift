//
//  ItemPackage.swift
//  HeightMapAR
//
//  Created by Tran Giang Long on 08.06.19.
//  Copyright © 2019 Tran Giang Long. All rights reserved.
//

import Foundation

class ItemPackage {
    let itemPackageID: String
    let location: Location
    var items: [Item] = []
    
    init(json : [String : Any]) {
        self.itemPackageID = json["itemPackageID"] as! String
        self.location = Location(json: json["location"] as! [String : Any])
        
        for sub in json["items"] as! [Any] {
            items.append(Item(json: sub as! [String : Any]))
        }
        
    }
}
