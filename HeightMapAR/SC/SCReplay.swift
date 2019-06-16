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
    var ui : UIControllerJoystik!
    
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
        
        ui = UIControllerJoystik(size: sceneView.frame.size)
        ui.leftJoytick.on(.move) { [unowned self] (joystik) in
            let pVelocity = joystik.velocity;
            let speed = CGFloat(0.001)
            let userVector = self.getUserVector()
            print(userVector)
            self.sceneView.defaultCameraController.translateInCameraSpaceBy(x: Float(pVelocity.x*speed), y: userVector.0.y*Float(speed*pVelocity.y), z: userVector.0.z*Float(speed*pVelocity.y))
        }
        ui.enableJoystik()
        
        sceneView.overlaySKScene = ui.scene
        
        let data = mainPlayer.data.first!
        replay = Replay(mapInfo,map,events,ui,data.id)
        replay.speed = speed
        
        //setup joystik
    }
    
    // Credit to https://github.com/farice/ARShooter
    func getUserVector() -> (SCNVector3, SCNVector3) { // (direction, position)
        if let mat = self.sceneView.defaultCameraController.pointOfView?.transform {
//            let mat = SCNMatrix4(transform) // 4x4 transform matrix describing camera in world space
            let dir = SCNVector3(-1 * mat.m31, -1 * mat.m32, -1 * mat.m33) // orientation of camera in world space
            let pos = SCNVector3(mat.m41, mat.m42, mat.m43) // location of camera in world space
            
            return (dir, pos)
        }
        return (SCNVector3(0, 0, -1), SCNVector3(0, 0, -0.2))
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
