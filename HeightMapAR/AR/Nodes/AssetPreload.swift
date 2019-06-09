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
    var playerNode : SCNNode
    
    init() {
        
        let playerScene = SCNScene(named: "SceneKitAsset.scnassets/Player.scn")
        playerNode = SCNNode()
        for n in playerScene!.rootNode.childNodes {
            playerNode.addChildNode(n)
        }
        playerNode.scale = SCNVector3(0.01, 0.01, 0.01)
    }
    
}
