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
    var smoke  : SCNParticleSystem!
    var mainPlayerNode : SCNNode!
    
    init() {
        
        let playerScene = SCNScene(named: "SceneKitAsset.scnassets/Player.scn")
        guard let playerNode = playerScene?.rootNode.childNode(withName: "box", recursively: true) else {
            print("Error AssetPreload")
            return
        }
        playerNode.scale = SCNVector3(0.01, 0.01, 0.01)
        self.playerNode = playerNode
        
        
        let mainPlayerScene = SCNScene(named: "SceneKitAsset.scnassets/MainPlayer.scn")
        guard let mainPlayerNode = mainPlayerScene?.rootNode.childNode(withName: "cone", recursively: true) else {
            print("Error AssetPreload")
            return
        }
        mainPlayerNode.scale = SCNVector3(0.01, 0.01, 0.01)
        self.mainPlayerNode = mainPlayerNode
        
        
        if let smokeParticle = SCNParticleSystem(named: "smoke.scnp", inDirectory: nil) {
            self.smoke = smokeParticle
            smokeParticle.particleSize = 0.001
            smokeParticle.particleVelocity = 0.001
        } else {
            print("Error AssetPreload")
        }
        
    }
    
    
}
