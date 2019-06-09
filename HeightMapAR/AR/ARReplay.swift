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
    var eventLoopTimeInterval : TimeInterval = 0.0001
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        
        if !isReplayPause {
            if time > eventLoopTime {
                processEvent(event: events[currentEventIndex])
                currentEventIndex+=1
                eventLoopTime = time + eventLoopTimeInterval
            }
        }
    
    }
    
    @IBAction func drop(_ sender: Any) {

    }
    
    var isReplayPause = true
    @IBAction func play(_ sender: Any) {
        isReplayPause = false
    }
    
    var players : Set<SCNNode> = []
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
            playerTakeDamage(event: event as! LogPlayerTakeDamage)
        case .LogPlayerLogin:
            playerLogin(event: event as! LogPlayerLogin)
        case .LogPlayerLogout:
            playerLogout(event: event as! LogPlayerLogout)
        case .LogPlayerCreate:
            playerCreated(event: event as! LogPLayerCreate)
        default:
            return
        }
    }
    
    func playerCreated(event : LogPLayerCreate) {
        let node = getPlayerNodeOrCreated(id: event.character.accountId)
        mapInfo.map.addChildNode(node)
        
        let newLocation = locationToVector(location: event.character.location)
        node.position = newLocation
    }
    
    func playerLogin(event : LogPlayerLogin) {
        let node = getPlayerNodeOrCreated(id: event.accountId)
        mapInfo.map.addChildNode(node)
    }
    
    func playerLogout(event : LogPlayerLogout) {
        let node = getPlayerNodeOrCreated(id: event.accountId)
        node.removeFromParentNode()
    }
    
    func playerTakeDamage(event : LogPlayerTakeDamage) {
        guard let attacker = event.attacker else { return }
//        guard let victim  = event.victim else { return }
        
        let from = locationToVector(location: attacker.location)
        let to = locationToVector(location: event.victim.location)
        
        let geometry = SCNGeometry.lineThrough(points: [from,to], width: 10, closed: false, color: UIColor.green.cgColor)
        let line = SCNNode(geometry: geometry)
        line.name = "line"
        mapInfo.map.addChildNode(line)
        
        line.runAction(SCNAction.sequence([
            SCNAction.wait(duration: 2),
            SCNAction.removeFromParentNode()
            ]))
    }
    
    func playerEventPosition(event : LogPlayerPosition) {
        let node = getPlayerNodeOrCreated(id: event.character.accountId)
        let newLocation = locationToVector(location: event.character.location)
        let movingActionKey = "movingActionKey"
        
        

        node.runAction(SCNAction.move(to: newLocation, duration: 3),forKey: movingActionKey)
    }
    
    func getPlayer(id : String) -> SCNNode? {
        if let node = players.first(where: { (node) -> Bool in
            return node.name == id
        }) {
            return node
        }
        return nil
    }
    
    func getPlayerNodeOrCreated(id : String) -> SCNNode {
        if let node = players.first(where: { (node) -> Bool in
            return node.name == id
        }) {
            return node
        } else {
            let node = assetPreload.playerNode.clone()
            node.name = id
            players.insert(node)
            return node
        }
    }
}

extension ARReplay {
    func locationToVector(location : Location) -> SCNVector3 {
        let xPos = (location.x)/Float(mapRealSize(map: map).width)
        let yPos = (location.y)/Float(mapRealSize(map: map).height)
        let zPos = ((location.z)/Float(mapRealSize(map: map).height)) + 0.044
        
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
