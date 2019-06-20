//
//  SceneViewController.swift
//  HeightMapAR
//
//  Created by Tran Giang Long on 11.06.19.
//  Copyright © 2019 Tran Giang Long. All rights reserved.
//

import UIKit
import SceneKit

class SCReplay: SCMap {

    var replay : Replay!
    var events : [Event]!
    var speed : Double = 1.0
    var mainPlayer : Player!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let data = mainPlayer.data.first!
        replay = Replay(mapInfo,map,events,ui,data.id)
        replay.speed = speed

        sceneView.delegate = self
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
