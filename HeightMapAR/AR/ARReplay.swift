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
    
    let speed = 1.0
    
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
    
    private let movingActionKey = "movingActionKey"
}

extension ARReplay {
    func processEvent(event : Event) {
        guard let eventType = EventType(rawValue: event._T) else {
            return
        }
        
        switch eventType {
        case .LogPlayerPosition:
            playerEventPosition(event: event as! LogPlayerPosition)
        case .LogPlayerTakeDamage:
            processEventInFuture {
                self.playerTakeDamage(event: event as! LogPlayerTakeDamage)
            }
        case .LogPlayerLogin:
            processEventInFuture {
            self.playerLogin(event: event as! LogPlayerLogin)
            }
        case .LogPlayerLogout:
            processEventInFuture {
            self.playerLogout(event: event as! LogPlayerLogout)
            }
        case .LogPlayerCreate:
            processEventInFuture {
            self.playerCreated(event: event as! LogPLayerCreate)
            }
        case .LogVehicleRide:
            processEventInFuture {
            self.vehicleRide(event: event as! LogVehicleRide)
            }
        case .LogPlayerMakeGroggy:
            processEventInFuture {
                self.playerMakeGroggy(event: event as! LogPlayerMakeGroggy)
            }
        default:
            return
        }
        
    }
    
    func processEventInFuture( execute : @escaping () -> Void) {
        arView.scene.rootNode.runAction(
            SCNAction.sequence([
                SCNAction.wait(duration: 10/speed),
                SCNAction.run({ (_) in
                    execute()
                })
            ])
        )
    }
    
    func playerMakeGroggy(event : LogPlayerMakeGroggy) {
        guard let attackerNode = getPlayer(id: event.attacker.accountId) else { return }
        guard let victimNode = getPlayer(id: event.victim.accountId) else { return }
        
        var from = attackerNode.position
        var to   = victimNode.position
        
        from.y += 0.002
        to.y   += 0.002
        
        drawLine(from: from, to: to, duration: 2)
    }
    
    
    func playerTakeDamage(event : LogPlayerTakeDamage) {
        guard let attacker = event.attacker else { return }
        //        guard let victim  = event.victim else { return }
        
        guard let attackerNode = getPlayer(id: attacker.accountId) else { return }
        guard let victimNode = getPlayer(id: event.victim.accountId) else { return }
        
        var from = attackerNode.position
        var to   = victimNode.position
        
        from.y += 0.002
        to.y   += 0.002
        
        drawLine(from: from, to: to, duration: 2)
    }
    
    func vehicleRide(event : LogVehicleRide) {
        guard let node = getPlayer(id: event.attacker.accountId) else { return }
        
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
        //let node = getPlayerNodeOrCreated(character: event.accountId)
        //mapInfo.map.addChildNode(node)
    }
    
    func playerLogout(event : LogPlayerLogout) {
        //let node = getPlayerNodeOrCreated(character: event.accountId)
        //node.removeFromParentNode()
    }
   
    func playerEventPosition(event : LogPlayerPosition) {
        guard let node = getPlayer(id: event.character.accountId) else { return }
        let newLocation = locationToVector(location: event.character.location)

        
        node.runAction(SCNAction.move(to: newLocation, duration: 10/speed),forKey: movingActionKey)
    }
    
    func getPlayer(id : String) -> SCNNode? {
        if let node = players.first(where: { (node) -> Bool in
            return node.name == id
        }) {
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
            
            node.name = character.accountId
            players.insert(node)
            
            let text = SCNText(string: character.name, extrusionDepth: 1)
            let material = SCNMaterial()
            material.diffuse.contents = UIColor.blue
            material.lightingModel = .blinn
            text.firstMaterial = material
            
            let nodeText = SCNNode(geometry: text)
            nodeText.position = SCNVector3(0, 0.01, 0)
            nodeText.scale = SCNVector3(0.01, 0.01, 0.01)
            node.addChildNode(nodeText)
            
            return node
        }
    }
}

extension ARReplay {
    func locationToVector(location : Location) -> SCNVector3 {
        let xPos = (location.x)/Float(mapRealSize(map: map).width)
        let yPos = (location.y)/Float(mapRealSize(map: map).height)
        let zPos = ((location.z)/Float(mapRealSize(map: map).height)) + 0.05
        
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

extension ARReplay {
    func drawLine(from : SCNVector3, to : SCNVector3, duration : TimeInterval) {
        let line = SCNGeometry.lineThrough(points: [from,to], width: 50, closed: false, color: UIColor.green.cgColor)
        
        let node = SCNNode(geometry: line)
        mapInfo.map.addChildNode(node)
        node.runAction(SCNAction.sequence([
            SCNAction.wait(duration: duration),
            SCNAction.removeFromParentNode()
            ]))
    }
}
