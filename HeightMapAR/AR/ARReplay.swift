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

class ARReplay: ARView {
    
    var events : [Event]!
    var replay : Replay!
    var ui : UIController!
    var mainPlayer : Player!
    
    var speed : Double = 1.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ui = UIController(size: arView.bounds.size)

        let data = mainPlayer.data.first!
        replay = Replay(mapDataSource,map,events,ui, data.id)
        replay.speed = speed
        
        arView.overlaySKScene = ui.scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        arView.session.pause()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        ui.scene.size = arView.frame.size
    }
   

    override func session(_ session: ARSession, didUpdate frame: ARFrame) {
        super.session(session, didUpdate: frame)
        
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

