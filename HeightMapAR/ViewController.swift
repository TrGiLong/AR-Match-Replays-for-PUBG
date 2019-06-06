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
    
    var mapObject : SCNNode!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        parseImage()
        
        arView.delegate = self
        
        //let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(addMapObject(withGestureRecognizer:)))
        //arView.addGestureRecognizer(tapGestureRecognizer)

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
    
    var planes = [ARPlaneAnchor: SCNPlane]()
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        // 1
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        
        if (planes.count > 1) {
            return
        }
        // 2
        let width = CGFloat(planeAnchor.extent.x)
        let height = CGFloat(planeAnchor.extent.z)
        let plane = SCNPlane(width: width, height: height)
        
        planes[planeAnchor] = plane
        
        // 3
        plane.materials.first?.diffuse.contents = UIColor(red: 90/255, green: 200/255, blue: 250/255, alpha: 0.50)
        
        // 4
        let planeNode = SCNNode(geometry: plane)
        
        // 5
        let x = CGFloat(planeAnchor.center.x)
        let y = CGFloat(planeAnchor.center.y)
        let z = CGFloat(planeAnchor.center.z)
        planeNode.position = SCNVector3(x,y,z)
        planeNode.eulerAngles.x = -.pi / 2
        
        
        let clone = mapObject.clone()
        clone.eulerAngles.x = .pi / 2
        clone.position = SCNVector3(-planeAnchor.extent.x/2, -planeAnchor.extent.y/2, 0.1)
        planeNode.addChildNode(clone)
        
        var scaleFactor : CGFloat = 0
        
        if (width < height) {
            let widthClone = clone.boundingBox.max.x - clone.boundingBox.min.x
            scaleFactor = width/CGFloat(widthClone)
        } else {
            let heightClone = clone.boundingBox.max.z - clone.boundingBox.min.z
            scaleFactor = height/CGFloat(heightClone)
        }
        
        print(scaleFactor)
        clone.scale = SCNVector3(scaleFactor, scaleFactor, scaleFactor)
        // 6
        node.addChildNode(planeNode)
    }
    

    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as?  ARPlaneAnchor,
            let planeNode = node.childNodes.first,
            let plane = planeNode.geometry as? SCNPlane
            else { return }
        
        // 2
//        let width = CGFloat(planeAnchor.extent.x)
//        let height = CGFloat(planeAnchor.extent.z)
//        plane.width = width
//        plane.height = height
        
        // 3
        let x = CGFloat(planeAnchor.center.x)
        let y = CGFloat(planeAnchor.center.y)
        let z = CGFloat(planeAnchor.center.z)
        planeNode.position = SCNVector3(x, y, z)
        
//        let clone = planeNode.childNode(withName: "Map", recursively: false)!
//        let widthClone = clone.boundingBox.max.x - clone.boundingBox.min.x
//        let heightClone = clone.boundingBox.max.y - clone.boundingBox.min.y
//        let sClone = widthClone * heightClone
//        let sPlane = width * height
//        let scaleFactor = CGFloat(sClone)/sPlane
//
//        clone.scale = SCNVector3(scaleFactor, scaleFactor, scaleFactor)
    }
    
    func parseImage() {
        
        let image = UIImage(named: "2.png")!
        
        var sources : [SCNVector3] = [];
        var indices: [UInt32] = []
        var uvList:[CGPoint] = []

        guard let cgImage = image.cgImage, let pixelData = cgImage.dataProvider?.data else { return }
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        let bytesPerPixel = cgImage.bitsPerPixel / 8
        
        let delta = 16
        let k : Float = 1
        
        let minHeight : Float = 0.042
        
        let imageWidth = Int(image.size.width)
        
        for x in stride(from: 0, through: Int(image.size.width * image.scale), by: delta) {
            for y in stride(from: 0, through: Int(image.size.height * image.scale), by: delta) {
                let pixelInfo = ((imageWidth * y) + x) * bytesPerPixel
                
                //let r = CGFloat(data[pixelInfo]) / CGFloat(255.0)
                let g = CGFloat(data[pixelInfo+1]) / 255.0
                //let b = CGFloat(data[pixelInfo+2]) / CGFloat(255.0)
                //let a = CGFloat(data[pixelInfo+3]) / CGFloat(255.0)
            
                var height = Float(g)/(k*12)
                if (height < minHeight) {
                    height = minHeight
                }
                
                let xPos = (Float(x)/Float(image.size.width * image.scale))/k
                let yPos = (Float(y)/Float(image.size.height * image.scale))/k
    
                
                sources.append(SCNVector3(x: xPos, y: height, z: yPos));
                uvList.append(CGPoint(x: CGFloat(xPos), y: CGFloat(yPos)))
            }
        }
        
        let yLength = (UInt32(image.size.height * image.scale)/UInt32(delta))+1
        let xLength = (UInt32(image.size.width * image.scale)/UInt32(delta))+1
        for y in 0..<UInt32(yLength-1) {
            indices.append(yLength*y)
            
            for x in 0..<xLength {
                indices.append( (yLength*y)+x )
                indices.append( (yLength*(y+1))+x )
            }
            
            if y < yLength-2 {
                indices.append( (yLength*(y+1)) + (xLength-1) )
            }
            
        }
        
        let geometrySource = SCNGeometrySource(vertices: sources)
        let uvSource = SCNGeometrySource(textureCoordinates: uvList)
        let indicies = SCNGeometryElement(indices: indices, primitiveType: .triangleStrip)
        
        let node = SCNNode(geometry: SCNGeometry(sources: [geometrySource,uvSource], elements: [indicies]))
        
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "2a.png")
        material.isDoubleSided = true
        node.geometry?.firstMaterial = material
        node.name = "Map"
        
//        arView.scene.rootNode.addChildNode(node)
        mapObject = node;
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        arView.session.pause()
    }
    
    @IBAction func reset(_ sender: Any) {
        
    }
    
    @IBAction func loadImage(_ sender: Any) {
        
    }
    
    @objc func addMapObject(withGestureRecognizer recognizer: UIGestureRecognizer) {
        let tapLocation = recognizer.location(in: arView)
        let hitTestResults = arView.hitTest(tapLocation, types: .existingPlaneUsingExtent)
        
        guard let hitTestResult = hitTestResults.first else { return }
        let translation = hitTestResult.worldTransform.translation
        let x = translation.x
        let y = translation.y
        let z = translation.z
        
        let clone = mapObject.clone()
        clone.position = SCNVector3(x,y,z)

        arView.scene.rootNode.addChildNode(mapObject)
    }
}

extension float4x4 {
    var translation: float3 {
        let translation = self.columns.0
        return float3(translation.x, translation.y, translation.z)
    }
}
