//
//  SimpleVC.swift
//  HeightMapAR
//
//  Created by Tran Giang Long on 06.06.19.
//  Copyright © 2019 Tran Giang Long. All rights reserved.
//

import UIKit
import SceneKit

class SimpleVC: UIViewController {
    @IBOutlet weak var sceneView: SCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.scene = SCNScene()
        
 //       sceneView.backgroundColor = UIColor.black
        
        let omniLightNode = SCNNode()
        omniLightNode.light = SCNLight()
        omniLightNode.light!.type = SCNLight.LightType.omni
        omniLightNode.light!.color = UIColor.white
        omniLightNode.position = SCNVector3Make(0, 0.3, 0)
        sceneView.scene?.rootNode.addChildNode(omniLightNode)

        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = SCNLight.LightType.ambient
        ambientLightNode.light!.color = UIColor(white: 0.67, alpha: 1.0)
        ambientLightNode.position = SCNVector3Make(0, 0.3, 0)
        sceneView.scene?.rootNode.addChildNode(ambientLightNode)
        
//        sceneView.autoenablesDefaultLighting = true
        sceneView.allowsCameraControl = true
        sceneView.showsStatistics = true
        sceneView.backgroundColor = UIColor.darkGray
        
        //sceneView.scene?.rootNode.addChildNode(lightNode)
        
        parseImage()
        // Do any additional setup after loading the view.
    }
    
    func parseImage() {
        
        var sources : [SCNVector3] = [];
        let image = UIImage(named: "1.png")!
        print(Int(image.size.width * image.scale))
        
        var indices: [UInt32] = []
        
        guard let cgImage = image.cgImage, let pixelData = cgImage.dataProvider?.data else { return }
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        let bytesPerPixel = cgImage.bitsPerPixel / 8
        
        let delta = 10
        let k : Float = 1
        
        for x in stride(from: 0, through: Int(image.size.width * image.scale), by: delta) {
            for y in stride(from: 0, through: Int(image.size.height * image.scale), by: delta) {
                // adjust the pixels to constrain to be within the width/height of the image
                let y = y > 0 ? y - 1 : 0
                let x = x > 0 ? x - 1 : 0
                let pixelInfo = ((Int(image.size.width) * Int(y)) + Int(x)) * bytesPerPixel
                
                let r = CGFloat(data[pixelInfo]) / CGFloat(255.0)
                let g = CGFloat(data[pixelInfo+1]) / CGFloat(255.0)
                let b = CGFloat(data[pixelInfo+2]) / CGFloat(255.0)
                let a = CGFloat(data[pixelInfo+3]) / CGFloat(255.0)
                
                var height = Float(0.299 * r +  0.587 * g + 0.114 * b)
                
                height = Float(Float(g)/(k*5))
                let xPos = Float(Float(x)/Float(image.size.width * image.scale))/(k)
                let yPos = Float(Float(y)/Float(image.size.height * image.scale))/k
                
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
        node.position = SCNVector3(0, 0, 0)
        node.eulerAngles.y = -.pi / 2
        
//        let material = SCNMaterial()
//        material.diffuse.contents = UIColor.green
//        material.lightingModel = SCNMaterial.LightingModel.physicallyBased
////        material.diffuse.contents = UIImage(named: "2a.png")
//
////        print(node.geometry)
////        node.geometry?.firstMaterial = material
//        node.geometry?.materials = [material]
//
        node.name = "MEEE"
    
        sceneView.scene?.rootNode.addChildNode(node)
    }
}
