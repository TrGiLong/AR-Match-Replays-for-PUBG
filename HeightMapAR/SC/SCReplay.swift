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
    
    @IBOutlet weak var sceneView: SCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = SCNScene()
        sceneView.scene = scene
        sceneView.allowsCameraControl = true
        sceneView.backgroundColor = UIColor.black
        sceneView.delegate = self
        sceneView.isPlaying = true
        
        mapInfo = MapFactory.map(map: map)
        scene.rootNode.addChildNode(mapInfo.map)
        
        replay = Replay(mapInfo,map,events)
    
    }
    
    @IBAction func play(_ sender: Any) {
        replay.isReplayPause = false
    }
    
}

extension SCReplay : SCNSceneRendererDelegate {
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        replay.renderer(renderer, updateAtTime: time)
    }
}
