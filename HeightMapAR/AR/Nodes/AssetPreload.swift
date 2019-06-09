//
//  AssetsPreload.swift
//  HeightMapAR
//
//  Created by Tran Giang Long on 09.06.19.
//  Copyright © 2019 Tran Giang Long. All rights reserved.
//

import Foundation
import SceneKit

class AssetPreload {
    var playerNode : SCNNode!
    
    init() {
        
        let playerScene = SCNScene(named: "SceneKitAsset.scnassets/Player.scn")

        guard let playerNode = playerScene?.rootNode.childNode(withName: "box", recursively: true) else {
            print("Error")
            return
        }
        playerNode.scale = SCNVector3(0.01, 0.01, 0.01)
        self.playerNode = playerNode
    }
    
}
