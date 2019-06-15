//
//  ReplayDrawing.swift
//  HeightMapAR
//
//  Created by Tran Giang Long on 15.06.19.
//  Copyright © 2019 Tran Giang Long. All rights reserved.
//

import SceneKit

extension Replay {
    
    func playerNameNode(character : Character) -> SCNNode {
        let text = SCNText(string: "\(character.name)", extrusionDepth: 1)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.white
        material.lightingModel = .blinn
        text.firstMaterial = material
        
        return SCNNode(geometry: text)
    }
    
    func hpGeometry(health : Float) -> SCNGeometry {
        let textHP = SCNText(string: "\(Int(health)) HP", extrusionDepth: 1)
        let materialHP = SCNMaterial()
        if (health < 20) {
            materialHP.diffuse.contents = UIColor.red
        } else {
            materialHP.diffuse.contents = UIColor.green
        }
        materialHP.lightingModel = .blinn
        textHP.firstMaterial = materialHP
        return textHP
    }

    func drawZone(position : SCNVector3, radius : CGFloat, color : UIColor) -> SCNNode {
        
        let cylinder = SCNCylinder(radius: radius, height: 0.5)
        
        let material = SCNMaterial()
        material.lightingModel = .blinn
        material.isDoubleSided = true
        material.diffuse.contents = color
        
        let material2 = SCNMaterial()
        material2.diffuse.contents = UIColor.clear
        
        cylinder.materials = [material,material2,material2]
        
        let node = SCNNode(geometry: cylinder)
        node.position = position
        
        return node
    }

    func drawLine(from : SCNVector3, to : SCNVector3, repeaterAnimation : Int = 1, duration : TimeInterval) {
        let line = SCNGeometry.lineThrough(points: [from,to], width: 4, closed: false, color: UIColor.green.cgColor)
        
        let node = SCNNode(geometry: line)
        mapInfo.map.addChildNode(node)
        node.runAction(SCNAction.sequence([
            
            SCNAction.repeat(SCNAction.sequence([
                SCNAction.unhide(),
                SCNAction.wait(duration: 0.05),
                SCNAction.hide()
                ]), count: repeaterAnimation),
            
            SCNAction.wait(duration: duration),
            SCNAction.removeFromParentNode()
            ]))
    }
}
