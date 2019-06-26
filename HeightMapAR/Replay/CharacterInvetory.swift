//
//  CharacterInvetory.swift
//  HeightMapAR
//
//  Created by Tran Giang Long on 26.06.19.
//  Copyright © 2019 Tran Giang Long. All rights reserved.
//

import Foundation

class CharacterInventory {
    
    let characterID : String
    
    var head : Item?
    var armor : Item?
    var back : Item?
    var weapon : Item?
    var throwable : Item?
    
    init(characterID : String) {
        self.characterID = characterID
    }
    
    func getNewItem(item : Item) {
        if item.category == "Weapon" {
            weapon = item
        } else if item.category == "Equipment" {
            if item.subCategory == "Backpack" {
                back = item
            } else if item.subCategory == "Headgear" {
                head = item
            } else if item.subCategory == "Vest" {
                armor = item
            } else if item.subCategory == "Throwable" {
                throwable = item
            }
        }
        
    }

}
