//
//  PubgAsset.swift
//  HeightMapAR
//
//  Created by Tran Giang Long on 11.06.19.
//  Copyright © 2019 Tran Giang Long. All rights reserved.
//

import Foundation

class PubgAsset {
    
    static let shared = PubgAsset()
    
    let map : [String : String]
    
    private init() {
        map = (PubgAsset.getJsonFromFile(fileName: "mapName", type: "json") as? [String : String]) ?? [:]
    }
    
    static private func getJsonFromFile(fileName : String, type : String) -> Any? {
        if let path = Bundle.main.path(forResource: fileName, ofType: type) {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                return try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
            } catch {
                return nil
            }
        }
        return nil
    }
}
