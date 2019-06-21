//
//  SceneViewController.swift
//  HeightMapAR
//
//  Created by Tran Giang Long on 11.06.19.
//  Copyright © 2019 Tran Giang Long. All rights reserved.
//

import UIKit
import SceneKit

class SCMap: UIViewController {

    var map : Map = .sanhok
    var mapDataSource : MapDataSource!
    var ui : UIControllerJoystik!
    
    let camera = SCNCamera()
    let cameraNode = SCNNode()
    
    @IBOutlet weak var sceneView: SCNView!
    
    var isMovingCamera = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let scene = SCNScene()
        sceneView.scene = scene
        sceneView.allowsCameraControl = false
        sceneView.backgroundColor = UIColor.black
        
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = UIColor(white: 0.70, alpha: 1.0)
        
        // Add ambient light to scene
        scene.rootNode.addChildNode(ambientLightNode)
        
        // Create directional light
        let directionalLight = SCNNode()
        directionalLight.light = SCNLight()
        directionalLight.light!.type = .directional
        directionalLight.light!.color = UIColor(white: 1.0, alpha: 1.0)
        directionalLight.eulerAngles = SCNVector3(x: 0, y: 0, z: 0)
        
        cameraNode.addChildNode(directionalLight)
        cameraNode.camera = camera;
        camera.zNear = 0
        sceneView.pointOfView = cameraNode;
        scene.rootNode.addChildNode(cameraNode)
        
        ui = UIControllerJoystik(size: sceneView.frame.size)
        
        ui.leftJoytick.on(.begin) { [unowned self](_) in
            self.isMovingCamera = true
        }
        
        ui.leftJoytick.on(.move) { [unowned self] (joystik) in
            let pVelocity = joystik.velocity;
            let speed = CGFloat(0.0001)

            let dx : Float = Float(pVelocity.x * speed)
            let dy : Float = -Float(pVelocity.y * speed)
            
            let cammat = self.cameraNode.transform
            let transmat = SCNMatrix4MakeTranslation(Float(dx), 0, Float(dy))
            
            self.cameraNode.transform = SCNMatrix4Mult(transmat, cammat)
        }
        
        ui.leftJoytick.on(.end) { [unowned self](_) in
            self.isMovingCamera = false
        }
        
        ui.enableJoystik()
        
        ui.setSceneTouchChanged { [unowned self](touches, event) in
            if (self.isMovingCamera) { return }
            guard let touch = touches.first else { return }
            let cur = touch.location(in: self.sceneView)
            let prev = touch.previousLocation(in: self.sceneView)

            let translation = CGPoint(x: cur.x - prev.x, y: cur.y - prev.y)
            
            let dx = translation.x * 0.25
            let dy = -translation.y * 0.25
            
            var degreesX = self.cameraNode.eulerAngles.x.radiansToDegrees + Float(dy)
            let degreesY = self.cameraNode.eulerAngles.y.radiansToDegrees + Float(dx)
            
            if (degreesX < -80) {
                degreesX = -80
            } else if (degreesX > -10) {
                degreesX = -10
            }
            
            print(degreesX)
            
            self.cameraNode.eulerAngles.x = degreesX.degreesToRadians
            self.cameraNode.eulerAngles.y = degreesY.degreesToRadians
            self.cameraNode.eulerAngles.z = 0
            
        }

        
        sceneView.overlaySKScene = ui.scene
        
        mapDataSource = MapFactory.map(map: map)
        scene.rootNode.addChildNode(mapDataSource.node)
        
        let map = mapDataSource.node
        cameraNode.position = SCNVector3((map.boundingBox.max.x)/4, 0.5, (map.boundingBox.max.z)/4)
        cameraNode.eulerAngles = SCNVector3Make(-Float.pi/3, 0, 0)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        ui.scene.size = sceneView.frame.size
    }
    
}
