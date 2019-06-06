//
//  ViewController.swift
//  HeightMapAR
//
//  Created by Tran Giang Long on 05.06.19.
//  Copyright © 2019 Tran Giang Long. All rights reserved.
//

import UIKit

import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    @IBOutlet weak var arView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        let light = SCNLight()
        light.type = .omni
        let lightNode = SCNNode()
        lightNode.light = light
        arView.pointOfView?.addChildNode(lightNode)
        
        //parseImage()
    }
    
    func parseImage() {
        

        
        var sources : [SCNVector3] = [];
        let image = UIImage(named: "1.png")!
        print(Int(image.size.width * image.scale))
        
        var indices: [UInt32] = []

        guard let cgImage = image.cgImage, let pixelData = cgImage.dataProvider?.data else { return }
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        let bytesPerPixel = cgImage.bitsPerPixel / 8
        
        let delta = 100
        
        for x in stride(from: 0, through: Int(image.size.width * image.scale), by: delta) {
            for y in stride(from: 0, through: Int(image.size.height * image.scale), by: delta) {
                // adjust the pixels to constrain to be within the width/height of the image
                let y = y > 0 ? y - 1 : 0
                let x = x > 0 ? x - 1 : 0
                let pixelInfo = ((Int(image.size.width) * Int(y)) + Int(x)) * bytesPerPixel
                
                let height = (Float(data[pixelInfo])/Float(255.0))
                let xPos = Float(Float(x)/Float(image.size.width * image.scale))
                let yPos = Float(Float(y)/Float(image.size.height * image.scale))
                
                sources.append(SCNVector3(x: xPos, y: height+0.05, z: yPos));

            }
        }
        
        let yLength = (Int(image.size.height * image.scale)/delta)+1
        let xLength = (Int(image.size.width * image.scale)/delta)+1
        for y in 0..<yLength-1 {
            indices.append(UInt32(yLength*y))
            
            for x in 0..<xLength {
                indices.append(UInt32(yLength*y)+UInt32(x))
                indices.append(UInt32(yLength*(y+1))+UInt32(x))
            }
            
            if y < yLength-2 {
                indices.append(UInt32(yLength*(y+1))+UInt32(xLength-1))
            }
            
        }
        
        let node = SCNNode(geometry: SCNGeometry(sources: [SCNGeometrySource(vertices: sources)], elements: [SCNGeometryElement(indices: indices, primitiveType: .triangleStrip)]))
        
        arView.scene.rootNode.addChildNode(node);
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        arView.session.pause()
    }
    
    @IBAction func reset(_ sender: Any) {
        arView.session.pause()
        arView.scene.rootNode.enumerateChildNodes { (node, stop) in
            node.removeFromParentNode()
        }
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.isLightEstimationEnabled = true;
        
        arView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        
        let light = SCNLight()
        light.type = .omni
        let lightNode = SCNNode()
        lightNode.light = light
        arView.pointOfView?.addChildNode(lightNode)
    }
    
    @IBAction func loadImage(_ sender: Any) {
        parseImage()
    }
}

extension float4x4 {
    var translation: float3 {
        let translation = self.columns.0
        return float3(translation.x, translation.y, translation.z)
    }
}
