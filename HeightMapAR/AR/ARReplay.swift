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
    
    @IBOutlet weak var arView: ARSCNView!
    
    var replay : Replay!
    
    var mapInfo : MapInfo!
    var ui : UIController!
    
    var mainPlayer : Player!
    
    var speed : Double = 1.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapInfo = MapFactory.map(map: map)
        
        ui = UIController(size: arView.frame.size)
        arView.overlaySKScene = ui.scene
        
        let data = mainPlayer.data.first!
        replay = Replay(mapInfo,map,events,ui, data.id)
        replay.speed = speed
        
        arView.delegate = self
        
        let qaText = SCNText(string: "Yêu Quỳnh Anh", extrusionDepth: 3)
        qaText.font = UIFont.boldSystemFont(ofSize: 10)
        qaText.firstMaterial?.diffuse.contents = UIColor.black
        let qaNode = SCNNode(geometry: qaText)
        qaNode.position = SCNVector3(0, 0, -4)
        qaNode.scale = SCNVector3(0.001, 0.001, 0.001)
        arView.scene.rootNode.addChildNode(qaNode)

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.isLightEstimationEnabled = true;
//        configuration.planeDetection = .horizontal
        
        arView.showsStatistics = true
        arView.debugOptions = [
            ARSCNDebugOptions.showFeaturePoints,
            ARSCNDebugOptions.showWorldOrigin
        ]
        
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
    
    @IBAction func showMap(_ sender: Any) {
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
        
        
        let rootNode = arView.scene.rootNode
        replay.cameraEulerAngles = frame.camera.eulerAngles
    }

    @IBAction func pause(_ sender: Any) {
        replay.pause()
        arView.scene.isPaused = true
    }
    
    @IBAction func play(_ sender: Any) {
        replay.play()
        arView.scene.isPaused = false
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        replay.renderer(renderer, updateAtTime: time)
    }
    
}

