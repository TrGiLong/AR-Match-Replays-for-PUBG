//
//  SKHeightMap.swift
//  HeightMapAR
//
//  Created by Tran Giang Long on 05.06.19.
//  Copyright © 2019 Tran Giang Long. All rights reserved.
//

import Foundation
import SceneKit.SCNGeometry

enum Map {
    case erangel
}

typealias  MapSize = (width : CGFloat, height : CGFloat)
typealias  MapCoordiante = (width : UInt32, height : UInt32)
typealias  MapInfo = (map : SCNNode, points : [SCNVector3], originSize : MapSize, size : MapCoordiante )

class MapFactory {
    static func name( map : Map ) -> MapInfo? {
        switch map {
        case .erangel:
            return MapFactory.erange()
        }
    }
    
    static private func erange() -> MapInfo? {
        let image = UIImage(named: "2.png")!
        
        var sources : [SCNVector3] = [];
        var indices: [UInt32] = []
        var uvList:[CGPoint] = []
        
        guard let cgImage = image.cgImage, let pixelData = cgImage.dataProvider?.data else { return nil }
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
        
        node.scale = SCNVector3(x: 0.5, y: 0.5, z: 0.5)
        
        return (node,
                sources,
                (image.size.width * image.scale,image.size.height * image.scale),
                (xLength, yLength)
        )
    }
}
