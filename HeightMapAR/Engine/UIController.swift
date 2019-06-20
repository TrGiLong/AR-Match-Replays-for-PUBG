//
//  UIController.swift
//  HeightMapAR
//
//  Created by Tran Giang Long on 11.06.19.
//  Copyright © 2019 Tran Giang Long. All rights reserved.
//

import SpriteKit

class UIController {
    let scene : UIScene
    
    init(size : CGSize) {
        scene = UIScene(size: size)
        scene.scaleMode = .resizeFill
        
        aliveLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        aliveLabel.fontSize = 15
        aliveLabel.horizontalAlignmentMode = .right
        aliveLabel.verticalAlignmentMode = .top
        scene.addChild(aliveLabel)
        
        scene.run(SKAction.repeatForever(SKAction.sequence([
            SKAction.wait(forDuration: 2),
            SKAction.run({
                self.updateTableKill()
            })
            ])))
    }
    
    func setSceneTouchChanged(_ sceneTouchChanged : UISceneTouchChanged?) {
        scene.touchChanged = sceneTouchChanged
    }
    
    private var killEvents : [LogPllayerKill] = []
    func showKillEvent(event : LogPllayerKill) {
        killEvents.append(event)
    }
    
    private var killCells : [SKNode] = []
    private var removingCells : [SKNode] = []
    private func updateTableKill() {
        let showingEvents = Array(killEvents.prefix(4))
        for (index, event) in showingEvents.enumerated() {
 
            if let cell = getKillCell(event: event) {
                cell.position = CGPoint(x: 8, y: scene.size.height - CGFloat(40 + index*30))
            } else {
                let cell = createKillCell(event: event)
                killCells.append(cell)
                scene.addChild(cell)
                cell.position = CGPoint(x: 8, y: scene.size.height - CGFloat(40 + index*30))
            }
            
        }
        
        for removeCell in removingCells {
            removeCell.removeFromParent()
        }
        
        if !killCells.isEmpty {
            
            let deleteEvent = killCells.removeFirst()
            
            removingCells.append(deleteEvent)
            killEvents.removeAll { (event) -> Bool in
                return "\(event.attackId)" == deleteEvent.name
            }
            
        }

    }

    let aliveLabel : SKLabelNode
    func numberAlive(event : LogGameStatePeriodoc) {
        aliveLabel.position = CGPoint(x: scene.size.width-8, y: scene.size.height-8)
        aliveLabel.text = "Alive \(event.gameStates.numAlivePlayers)"
    }
    
}

extension UIController {
    
    private  func getKillCell(event : LogPllayerKill) -> SKNode? {
        return killCells.first(where: { (node) -> Bool in
            return node.name == "\(event.attackId)"
        })
    }
    
    private func createKillCell(event : LogPllayerKill) -> SKNode {
        let node = SKNode()
        node.name = "\(event.attackId)"
        
        let textAttacker = SKLabelNode(fontNamed: "AvenirNext-Bold")
        textAttacker.text = event.killer.name
        textAttacker.horizontalAlignmentMode = .left
        let textVictim   = SKLabelNode(fontNamed: "AvenirNext-Bold")
        textVictim.text = event.victim.name
        textVictim.horizontalAlignmentMode = .left
        let weaponIcon : SKSpriteNode!
        
        if let nameWeapon = PubgAsset.shared.damageCauserName[event.damageCauserName] {
            if let item = PubgAsset.shared.itemId.keysForValue(value: nameWeapon).first {
                weaponIcon = SKSpriteNode(imageNamed: item)
                weaponIcon.setScale(1/20)
            } else {
                weaponIcon = SKSpriteNode()
            }
        } else {
            weaponIcon = SKSpriteNode()
        }

        
        
        textAttacker.position = CGPoint(x : 0, y: 0)
        textAttacker.fontSize = 10
        
        weaponIcon?.position = CGPoint(x: textAttacker.frame.maxX + 20, y: 0)
        weaponIcon.anchorPoint = CGPoint(x: 0, y: 0)
        textVictim.position = CGPoint(x: (weaponIcon?.frame.maxX ?? textAttacker.frame.maxX) + 20, y: 0)
        
        textVictim.fontSize = 10

        node.addChild(textAttacker)
        node.addChild(weaponIcon ?? SKSpriteNode())
        node.addChild(textVictim)
        
        return node
    }
}

extension Dictionary where Value: Equatable {
    func keysForValue(value: Value) -> [Key] {
        return compactMap { (key: Key, val: Value) -> Key? in
            value == val ? key : nil
        }
    }
}

typealias UISceneTouchChanged = ((_ touches: Set<UITouch>, _ event: UIEvent?) -> Void)

class UIScene : SKScene {
    
    var touchChanged : UISceneTouchChanged?
    
    override func sceneDidLoad() {
        super.sceneDidLoad()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (touchChanged != nil) {
            touchChanged!(touches,event)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
}
