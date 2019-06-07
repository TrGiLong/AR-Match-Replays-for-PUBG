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

class ViewController: UIViewController, ARSCNViewDelegate, ARSessionDelegate ,SCNPhysicsContactDelegate{
    @IBOutlet weak var arView: ARSCNView!
    
    var mapObject : SCNNode!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        parseImage()
        
        arView.scene.physicsWorld.gravity = SCNVector3(0, -0.1, 0)
        arView.scene.physicsWorld.contactDelegate = self
        
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
                                  ARSCNDebugOptions.showWorldOrigin,
        .showPhysicsShapes]
        
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
        
        let geometry = SCNGeometry(sources: [geometrySource,uvSource], elements: [indicies])
        let node = SCNNode(geometry: geometry)
        
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "2a.png")
        material.isDoubleSided = true
        node.geometry?.firstMaterial = material
        node.name = "Map"
        
//        arView.scene.rootNode.addChildNode(node)
        mapObject = node;

        let shape = SCNPhysicsShape(node: mapObject, options:[SCNPhysicsShape.Option.type: SCNPhysicsShape.ShapeType.concavePolyhedron])
        let physics = SCNPhysicsBody(type: .static, shape: shape)
        physics.categoryBitMask = PhysicsBody.Map
        physics.contactTestBitMask = PhysicsBody.Airdrop
        physics.collisionBitMask = PhysicsBody.Airdrop
        mapObject.physicsBody = physics
        
        mapObject.scale = SCNVector3(x: 0.5, y: 0.5, z: 0.5)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        arView.session.pause()
    }
    
    @IBAction func reset(_ sender: Any) {
        
    }
    
    @IBAction func loadImage(_ sender: Any) {
        guard let currentTransform = currentTransform else {
            return
        }
        
        let width = mapObject.boundingBox.max.x - mapObject.boundingBox.min.x
        let height = mapObject.boundingBox.max.z - mapObject.boundingBox.min.z
        
        mapObject.removeFromParentNode()
        mapObject.position = SCNVector3(currentTransform[3][0]-width/4, currentTransform[3][1], currentTransform[3][2]-height/4)
        arView.scene.rootNode.addChildNode(mapObject)
    }
    
    var currentTransform : simd_float4x4?
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        // Do something with the new transform
        currentTransform = frame.camera.transform

    }
    
    @IBAction func drop(_ sender: Any) {
        guard let currentTransform = currentTransform else {
            return
        }
        
        let cube = SCNScene(named: "airdrop.dae")
        let cubeNode = SCNNode()
        
        guard let cubeNodes = cube?.rootNode.childNodes else {
            return
        }
        
        for n in cubeNodes {
            cubeNode.addChildNode(n)
        }
        
        let shape = SCNPhysicsShape(node: cubeNode, options: [:])
        let physhic = SCNPhysicsBody(type: .dynamic, shape: shape)
        physhic.categoryBitMask = PhysicsBody.Airdrop
        physhic.contactTestBitMask = PhysicsBody.Map
        physhic.collisionBitMask = PhysicsBody.Map
        cubeNode.physicsBody = physhic
        
        
        cubeNode.scale = SCNVector3(0.005, 0.005, 0.005)
        cubeNode.position = SCNVector3(currentTransform[3][0], currentTransform[3][1], currentTransform[3][2])
        arView.scene.rootNode.addChildNode(cubeNode)
        
    }

    
}

extension float4x4 {
    var translation: float3 {
        let translation = self.columns.0
        return float3(translation.x, translation.y, translation.z)
    }
}
