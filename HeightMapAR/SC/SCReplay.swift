//
//  SceneViewController.swift
//  HeightMapAR
//
//  Created by Tran Giang Long on 11.06.19.
//  Copyright © 2019 Tran Giang Long. All rights reserved.
//

import UIKit
import SceneKit

class SCReplay: UIViewController {
    
    var map : Map = .sanhok
    var mapInfo : MapInfo!
    var replay : Replay!
    var events : [Event]!
    var ui : UIController!
    
    var speed : Double = 1.0
    
    var mainPlayer : Player!
    
    @IBOutlet weak var sceneView: SCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = SCNScene()
        sceneView.scene = scene
        sceneView.allowsCameraControl = true
        sceneView.backgroundColor = UIColor.black
        sceneView.delegate = self
        
        mapInfo = MapFactory.map(map: map)
        scene.rootNode.addChildNode(mapInfo.map)
        
        ui = UIController(size: sceneView.frame.size)
        sceneView.overlaySKScene = ui.scene
        
        let data = mainPlayer.data.first!
        replay = Replay(mapInfo,map,events,ui,data.id)
        replay.speed = speed
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        ui.scene.size = sceneView.frame.size
    }
    
    @IBAction func play(_ sender: Any) {
        replay.isReplayPause = false
        sceneView.isPlaying = true
        sceneView.scene?.isPaused = false
    }
    
    @IBAction func pause(_ sender: Any) {
        replay.isReplayPause = true
        sceneView.isPlaying = false
        sceneView.scene?.isPaused = true
    }
}

extension SCReplay : SCNSceneRendererDelegate {
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        replay.renderer(renderer, updateAtTime: time)
    }
}
