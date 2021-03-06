//
//  ViewController.swift
//  HeightMapAR
//
//  Created by Tran Giang Long on 05.06.19.
//  Copyright © 2019 Tran Giang Long. All rights reserved.
//

import UIKit

import ARKit

struct PhysicsBody {
    static let Map = 0x1 << 1
    static let Airdrop = 0x1 << 2
}

class ARView: UIViewController, ARSCNViewDelegate, ARSessionDelegate {
    
    var map : Map = .sanhok
    var mapDataSource : MapDataSource!
    
    @IBOutlet weak var arView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapDataSource = MapFactory.map(map: map)
        
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
        //configuration.planeDetection = .horizontal
        
        //arView.showsStatistics = true
        //arView.debugOptions = [ARSCNDebugOptions.showFeaturePoints,
        //                          ARSCNDebugOptions.showWorldOrigin]
        
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
    
    @IBAction func showMap(_ sender: Any) {
        guard let currentTransform = currentTransform else {
            return
        }
        
        let width = mapDataSource.node.boundingBox.max.x - mapDataSource.node.boundingBox.min.x
        let height = mapDataSource.node.boundingBox.max.z - mapDataSource.node.boundingBox.min.z
        
        mapDataSource.node.removeFromParentNode()
        mapDataSource.node.position = SCNVector3(currentTransform[3][0]-width/4, currentTransform[3][1], currentTransform[3][2]-height/4)
        arView.scene.rootNode.addChildNode(mapDataSource.node)
        

    }
    
    var currentTransform : simd_float4x4?
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        // Do something with the new transform
        currentTransform = frame.camera.transform
    }
    
}

extension float4x4 {
    var translation: float3 {
        let translation = self.columns.0
        return float3(translation.x, translation.y, translation.z)
    }
}
