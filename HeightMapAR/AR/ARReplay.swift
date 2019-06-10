//
//  ViewController.swift
//  HeightMapAR
//
//  Created by Tran Giang Long on 05.06.19.
//  Copyright © 2019 Tran Giang Long. All rights reserved.
//

import UIKit

import ARKit
import RxSwift

class ARReplay: UIViewController, ARSCNViewDelegate, ARSessionDelegate {
    
    var map : Map = .sanhok
    
    var events : [Event]!
    var currentEventIndex : Int = 0

    let assetPreload = AssetPreload()
    
    @IBOutlet weak var arView: ARSCNView!
    
    var mapInfo : MapInfo!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapInfo = MapFactory.map(map: map)
        eventLoopTime = events[0]._D
        
        arView.delegate = self

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.isLightEstimationEnabled = true;
        configuration.planeDetection = .horizontal
        
        arView.showsStatistics = true
        arView.debugOptions = [ARSCNDebugOptions.showFeaturePoints,
                               ARSCNDebugOptions.showWorldOrigin]
        
        // Run the view's session
        arView.session.run(configuration)
        arView.session.delegate = self
        
        let light = SCNLight()
        light.type = .omni
        let lightNode = SCNNode()
        lightNode.light = light
        arView.pointOfView?.addChildNode(lightNode)
        
        //parseImage()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        arView.session.pause()
    }
    
    @IBAction func reset(_ sender: Any) {
        
    }
    
    @IBAction func loadImage(_ sender: Any) {
        guard let currentTransform = currentTransform else {
            return
        }
        
        let width = mapInfo.map.boundingBox.max.x - mapInfo.map.boundingBox.min.x
        let height = mapInfo.map.boundingBox.max.z - mapInfo.map.boundingBox.min.z
        
        mapInfo.map.removeFromParentNode()
        mapInfo.map.position = SCNVector3(currentTransform[3][0]-width/4, currentTransform[3][1], currentTransform[3][2]-height/4)
        arView.scene.rootNode.addChildNode(mapInfo.map)
    }
    
    var currentTransform : simd_float4x4?
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        // Do something with the new transform
        currentTransform = frame.camera.transform
    }
    
    var eventLoopTime : TimeInterval = 0
    var eventLoopTimeInterval : TimeInterval = 0.1
    var previousTime : TimeInterval?
    
    let speed = 5.0
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        
        let deltaTime = time - (previousTime ?? time)
        previousTime = time
        
        if !isReplayPause {
            while (events[currentEventIndex]._D < eventLoopTime) {
                processEvent(event: events[currentEventIndex])
                currentEventIndex+=1
                if (currentEventIndex >= events.count) {
                    isReplayPause = true
                    break;
                }
            }
        }
    
        eventLoopTime += deltaTime * speed
    }
    
    @IBAction func drop(_ sender: Any) {

    }
    
    var isReplayPause = true
    @IBAction func play(_ sender: Any) {
        isReplayPause = false
    }
    
    var players : Set<SCNNode> = []
    var blueZone : SCNNode?
    var redZone  : SCNNode?
    
    var blueZoneOptions : [BlueZoneCustomOption] = []
    
    private let movingActionKey = "movingActionKey"
}

extension ARReplay {
    func processEvent(event : Event) {
        guard let eventType = EventType(rawValue: event._T) else {
            return
        }
        
        switch eventType {
        case .LogMatchStart:
            self.matchStart(event: event as! LogMatchStart)
        case .LogPlayerPosition:
            playerEventPosition(event: event as! LogPlayerPosition)
        case .LogPlayerTakeDamage:
            self.playerTakeDamage(event: event as! LogPlayerTakeDamage)
        case .LogPlayerLogin:
            self.playerLogin(event: event as! LogPlayerLogin)
        case .LogPlayerLogout:
            self.playerLogout(event: event as! LogPlayerLogout)
        case .LogPlayerCreate:
            self.playerCreated(event: event as! LogPLayerCreate)
        case .LogVehicleRide:
            self.vehicleRide(event: event as! LogVehicleRide)
        case .LogPlayerMakeGroggy:
            self.playerMakeGroggy(event: event as! LogPlayerMakeGroggy)
        case .LogPlayerKill:
            self.playerKill(event: event as! LogPllayerKill)
        case .LogArmorDestroy:
            self.armorDestry(event: event as! Logarmordestroy)
        case .LogPlayerAttack:
            self.logPlayyerAttack(event: event as! LogPLayerAttack)
        case .LogPlayerRevive:
            self.playerRevive(event: event as! LogPlayerRevive)
        case .LogHeal:
            self.heal(event: event as! LogHeal)
        case .LogGameStatePeriodic:
            self.gameStatePeriodic(event: event as! LogGameStatePeriodoc)
        default:
            return
        }
    }

    func processEventInFuture(time : TimeInterval = 10 ,execute : @escaping () -> Void) {
        arView.scene.rootNode.runAction(
            SCNAction.sequence([
                SCNAction.wait(duration: time/speed),
                SCNAction.run({ (_) in
                    execute()
                })
            ])
        )
    }
    
    func firstFutureEvent(in duration : TimeInterval, compare : (Event) -> Bool) -> Event? {
        
        var ind = currentEventIndex + 1
        if (ind >= events.count) { return nil }
        
        while events[ind]._D < eventLoopTime + duration {
            
            let nextEvent = events[ind]
            
            if (compare(nextEvent)) {
                return nextEvent
            } else {
                ind+=1
                if (ind >= events.count) { return nil }
            }
            
        }
        
        return nil
    }
    
    func matchStart(event : LogMatchStart) {
        self.blueZoneOptions = event.blueZoneCustomOptions
    }
    
    func gameStatePeriodic(event : LogGameStatePeriodoc) {
        
        //blue zone
        let blueZonePosition = locationToVector(location: event.gameStates.safetyZonePosition)
        let radius = event.gameStates.safetyZoneRadius/Float(mapRealSize(map: map).width)
 
        blueZone?.removeFromParentNode()
        blueZone = drawZone(position: blueZonePosition, radius: CGFloat(radius), color: UIColor(red: 0.1882, green: 0, blue: 0.8078, alpha: 0.4))
        blueZone?.position = blueZonePosition
        mapInfo.map.addChildNode(blueZone!)
        
        //red zone
        let redZonePosition = locationToVector(location: event.gameStates.redZonePosition)
        let redRadius = event.gameStates.redZoneRadius/Float(mapRealSize(map: map).width)
        
        redZone?.removeFromParentNode()
        redZone = drawZone(position: redZonePosition, radius: CGFloat(redRadius), color: UIColor(red: 1, green: 0, blue: 0, alpha: 0.4))
        redZone?.position = redZonePosition
        mapInfo.map.addChildNode(redZone!)
        
    }
    
    
    func heal(event : LogHeal) {
        _ = getPlayer(character: event.character)
    }
    
    func itemUse(event : LogItemUse) {
        _ = getPlayer(character: event.character)
    }
    
    func playerRevive(event : LogPlayerRevive) {
        _ = getPlayer(character: event.reviver)
    }
    
    func logPlayyerAttack(event : LogPLayerAttack) {
        let nextEvent = firstFutureEvent(in: 50, compare: { (future) -> Bool in
            
            if let makeGroggy = future as? LogPlayerMakeGroggy {
                return makeGroggy.attackId == event.attackId
            }
            
            if let takeDamage = future as? LogPlayerTakeDamage {
                return takeDamage.attackId == event.attackId
            }
            
            if let armorDestroy = future as? Logarmordestroy {
                return armorDestroy.attackId == event.attackId
            }
            
            if let kill = future as? LogPllayerKill {
                return kill.attackId == event.attackId
            }
            
            return false
        })
        
        if let future = nextEvent as? LogPllayerKill {
            playerKill(event: future, repeatAnimation: event.fireWeaponStackCount)
        }
        
        //TODO: remove
        if let future = nextEvent as? LogPlayerMakeGroggy {
            playerMakeGroggy(event: future, repeatAnimation: event.fireWeaponStackCount)
        }
        
        //TODO: remove
        if let future = nextEvent as? LogPlayerTakeDamage {
            playerTakeDamage(event: future, repeatAnimation: event.fireWeaponStackCount)
        }
        
        if let future = nextEvent as? Logarmordestroy {
            armorDestry(event: future, repeatAnimation: event.fireWeaponStackCount)
        }
    }
    
    func armorDestry(event : Logarmordestroy, repeatAnimation : Int = 1) {
        guard let attackerNode = getPlayer(character: event.attacker) else { return }
        guard let victimNode = getPlayer(character: event.victim) else { return }
        
        var from = attackerNode.position
        var to   = victimNode.position
        
        from.y += 0.002
        to.y   += 0.002
        
        drawLine(from: from, to: to, duration: 1)
    }
    
    func playerKill(event : LogPllayerKill, repeatAnimation : Int = 1) {
        guard let attackerNode = getPlayer(character: event.killer) else { return }
        guard let victimNode = getPlayer(character: event.victim) else { return }
        
        var from = attackerNode.position
        var to   = victimNode.position
        
        from.y += 0.002
        to.y   += 0.002
        
        drawLine(from: from, to: to, duration: 1)
        victimNode.runAction(SCNAction.sequence([
            SCNAction.run({ (node) in
                node.addParticleSystem(self.assetPreload.smoke)
            }),
            SCNAction.wait(duration: 3),
            SCNAction.removeFromParentNode()
            ]))
    }
    
    func playerMakeGroggy(event : LogPlayerMakeGroggy, repeatAnimation : Int = 1) {
        guard let attackerNode = getPlayer(character: event.attacker) else { return }
        guard let victimNode = getPlayer(character: event.victim) else { return }
        
        var from = attackerNode.position
        var to   = victimNode.position
        
        from.y += 0.002
        to.y   += 0.002
        
        drawLine(from: from, to: to, duration: 1)
    }
    
    
    func playerTakeDamage(event : LogPlayerTakeDamage, repeatAnimation : Int = 1) {
        guard let attacker = event.attacker else { return }
        //        guard let victim  = event.victim else { return }
        
        guard let attackerNode = getPlayer(character: attacker) else { return }
        guard let victimNode = getPlayer(character: event.victim) else { return }
        
        var from = attackerNode.position
        var to   = victimNode.position
        
        from.y += 0.002
        to.y   += 0.002
        
        drawLine(from: from, to: to, duration: 1)
    }
    
    func vehicleRide(event : LogVehicleRide) {
        guard let node = getPlayer(character: event.attacker) else { return }
        
        let newLocation = locationToVector(location: event.attacker.location)
        node.removeAction(forKey: movingActionKey)
        node.position = newLocation
    }
    
    func playerCreated(event : LogPLayerCreate) {
        let node = getPlayerNodeOrCreated(character: event.character)
        mapInfo.map.addChildNode(node)
        
        node.removeAction(forKey: movingActionKey)
        let newLocation = locationToVector(location: event.character.location)
        node.position = newLocation
    }
    
    func playerLogin(event : LogPlayerLogin) {
        if let node = getPlayer(id: event.accountId) {
            mapInfo.map.addChildNode(node)
        }
    }
    
    func playerLogout(event : LogPlayerLogout) {
        if let node = getPlayer(id: event.accountId) {
            node.removeFromParentNode()
        }
    }
   
    func playerEventPosition(event : LogPlayerPosition) {
        guard let node = getPlayer(character: event.character) else { return }
        let newLocation = locationToVector(location: event.character.location)

        if let nextEvent = firstFutureEvent(in: 11, compare: { (futureEvent) -> Bool in
            guard let futureEvent = futureEvent as? LogPlayerPosition else { return false }
            return futureEvent.character.accountId == event.character.accountId
        }) as? LogPlayerPosition {
            node.position = newLocation
            let nexLocation = locationToVector(location: nextEvent.character.location)
            node.runAction(SCNAction.move(to: nexLocation, duration: 10/speed),forKey: movingActionKey)
        }
        
    }
    
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
            let node = assetPreload.playerNode.clone()
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
        
        
        let textHP = SCNText(string: "\(Int(character.health)) HP", extrusionDepth: 1)
        let materialHP = SCNMaterial()
        if (character.health < 20) {
            materialHP.diffuse.contents = UIColor.red
        } else {
            materialHP.diffuse.contents = UIColor.green
        }
        materialHP.lightingModel = .blinn
        textHP.firstMaterial = materialHP
        
        let nodeTextHP = SCNNode(geometry: textHP)
        nodeTextHP.position = SCNVector3(0.1, 0.0, 0)
        nodeTextHP.scale = SCNVector3(0.01, 0.01, 0.01)
        node.addChildNode(nodeTextHP)
    }
}

extension ARReplay {
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
}

extension ARReplay {
    func drawLine(from : SCNVector3, to : SCNVector3, repeaterAnimation : Int = 1, duration : TimeInterval) {
        let line = SCNGeometry.lineThrough(points: [from,to], width: 25, closed: false, color: UIColor.green.cgColor)
        
        let node = SCNNode(geometry: line)
        mapInfo.map.addChildNode(node)
        node.runAction(SCNAction.sequence([
            
            SCNAction.repeat(SCNAction.sequence([
                SCNAction.unhide(),
                SCNAction.wait(duration: 0.1),
                SCNAction.hide()
                ]), count: repeaterAnimation),
            
            SCNAction.wait(duration: duration),
            SCNAction.removeFromParentNode()
            ]))
    }
}

