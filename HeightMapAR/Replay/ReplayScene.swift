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
            updatePlayerInfoNode(node: node, character: character)
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
            
            updatePlayerInfoNode(node: node, character: character)
            
            return node
        }
    }
    
    func updatePlayerInfoNode(node : SCNNode, character : Character) {
        
        var infoNode = node.childNode(withName: kPlayerInfoNode, recursively: false)
        if infoNode == nil {
            infoNode = SCNNode()
            infoNode?.name = kPlayerInfoNode
            node.addChildNode(infoNode!)
            
            // Static node
            let playerName = playerNameNode(character: character)
            playerName.position = SCNVector3(0.1, 0.1, 0)
            playerName.scale = SCNVector3(0.01, 0.01, 0.01)
            infoNode!.addChildNode(playerName)
        }
        
        // dynamic node
        var hpNode = infoNode!.childNode(withName: kHP, recursively: false)
        if hpNode == nil {
            hpNode = SCNNode(geometry: hpGeometry(health: character.health))
            hpNode!.name = kHP
            hpNode!.position = SCNVector3(0.1, 0.0, 0)
            hpNode!.scale = SCNVector3(0.01, 0.01, 0.01)
            infoNode!.addChildNode(hpNode!)
        }
        hpNode?.geometry = hpGeometry(health: character.health)
        
        guard let inventory = getInventory(character: character) else { return }
        
        // Weapon
        var weaponNode = infoNode!.childNode(withName: kWeaponLabel, recursively: false)
        if (weaponNode == nil) {
            let plane = SCNPlane(width: 0.25, height: 0.125)
            plane.firstMaterial?.diffuse.contents = UIColor.clear
            plane.firstMaterial?.isDoubleSided = true
            weaponNode = SCNNode(geometry: plane)
            weaponNode!.name = kWeaponLabel
            weaponNode!.position = SCNVector3(0.35, 0.3, 0)
            infoNode!.addChildNode(weaponNode!)
        }
        if let weapon = inventory.weapon {
            weaponNode!.geometry?.firstMaterial?.diffuse.contents = UIImage(named: weapon.itemID)
        }

        //head
        var headNode = infoNode!.childNode(withName: kHeadLabel, recursively: false)
        if (headNode == nil) {
            let plane = SCNPlane(width: 0.1, height: 0.1)
            plane.firstMaterial?.diffuse.contents = UIColor.clear
            plane.firstMaterial?.isDoubleSided = true
            headNode = SCNNode(geometry: plane)
            headNode!.name = kHeadLabel
            headNode!.position = SCNVector3(0.15, 0.5, 0)
            infoNode!.addChildNode(headNode!)
        }

        if let head = inventory.head {
            headNode!.geometry?.firstMaterial?.diffuse.contents = UIImage(named: head.imageID)
        }
        
        //armor
        var armorNode = infoNode!.childNode(withName: kArmorLabel, recursively: false)
        if (armorNode == nil) {
            let plane = SCNPlane(width: 0.1, height: 0.1)
            plane.firstMaterial?.diffuse.contents = UIColor.clear
            plane.firstMaterial?.isDoubleSided = true
            armorNode = SCNNode(geometry: plane)
            armorNode!.name = kArmorLabel
            armorNode!.position = SCNVector3(0.35, 0.5, 0)
            infoNode!.addChildNode(armorNode!)
        }
        
        if let armor = inventory.armor {
            armorNode!.geometry?.firstMaterial?.diffuse.contents = UIImage(named: armor.imageID)
        }
        
    }
    
    func updateRotationInfoNode() {
        for playerNode in players {
            
            if playerNode.parent == nil {
                continue
            }
            
            guard let infoNode = playerNode.childNode(withName: kPlayerInfoNode, recursively: false) else {
                continue
            }
            
            guard let cameraEulerAngles = cameraEulerAngles else {
                return
            }
            
            infoNode.eulerAngles.y = cameraEulerAngles.y
            
            
        }
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
