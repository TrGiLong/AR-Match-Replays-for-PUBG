//
//  ReplayScene.swift
//  HeightMapAR
//
//  Created by Tran Giang Long on 15.06.19.
//  Copyright © 2019 Tran Giang Long. All rights reserved.
//

import SceneKit

extension Replay {
    
    func getPlayer(id : String) -> SCNNode? {
        if let node = players.first(where: { (node) -> Bool in
            return node.name == id
        }) {
            return node
        }
        return nil
    }
    
    func getPlayer(character : Character) -> SCNNode? {
        if let node = players.first(where: { (node) -> Bool in
            return node.name == character.accountId
        }) {
            updatCharacterNode(node: node, character: character)
            return node
        }
        return nil
    }
    
    func getPlayerNodeOrCreated(character : Character) -> SCNNode {
        if let node = players.first(where: { (node) -> Bool in
            return node.name == character.accountId
        }) {
            return node
        } else {
            
            var node : SCNNode!
            if character.accountId == mainPlayerId {
                node = assetPreload.mainPlayerNode.clone()
            } else {
                node = assetPreload.playerNode.clone()
            }
            node.geometry = (node.geometry?.copy() as! SCNGeometry)
            if let newMaterial = node.geometry?.materials.first?.copy() as? SCNMaterial {
                newMaterial.diffuse.contents = UIColor.randomColor(seed: "\(character.teamId)")
                node.geometry?.materials = [newMaterial]
            }
            
            node.name = character.accountId
            node.geometry?.firstMaterial?.diffuse.contents = UIColor.randomColor(seed: "\(character.teamId)")
            
            players.insert(node)
            
            updatCharacterNode(node: node, character: character)
            
            return node
        }
    }
    
    func updatCharacterNode(node : SCNNode, character : Character) {
        node.childNodes.forEach { (node) in
            node.removeFromParentNode()
        }
        
        let text = SCNText(string: "\(character.name)", extrusionDepth: 1)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.white
        material.lightingModel = .blinn
        text.firstMaterial = material
        
        let nodeText = SCNNode(geometry: text)
        nodeText.position = SCNVector3(0.1, 0.1, 0)
        nodeText.scale = SCNVector3(0.01, 0.01, 0.01)
        node.addChildNode(nodeText)
        
        let nodeTextHP = SCNNode(geometry: hpGeometry(health: character.health))
        nodeTextHP.name = kHP
        nodeTextHP.position = SCNVector3(0.1, 0.0, 0)
        nodeTextHP.scale = SCNVector3(0.01, 0.01, 0.01)
        node.addChildNode(nodeTextHP)
    }
    
    func locationToVector(location : Location) -> SCNVector3 {
        let xPos = (location.x)/Float(mapRealSize(map: map).width)
        let yPos = (location.y)/Float(mapRealSize(map: map).height)
        let zPos = ((location.z)/Float(mapRealSize(map: map).height)) + 0.043
        
        //        let xIndex = Int(xPos) < mapInfo.size.width ? Int(xPos) : Int(mapInfo.size.width-1)
        //        let yIndex = Int(yPos) < mapInfo.size.width ? Int(yPos) : Int(mapInfo.size.height-1)
        //
        //        let index = xIndex + yIndex*yIndex
        //
        //        let vector = mapInfo.points[index]
        //
        return SCNVector3(xPos , zPos, yPos)
    }
}
