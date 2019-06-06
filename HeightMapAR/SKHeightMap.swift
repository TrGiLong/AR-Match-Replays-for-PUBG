//
//  SKHeightMap.swift
//  HeightMapAR
//
//  Created by Tran Giang Long on 05.06.19.
//  Copyright © 2019 Tran Giang Long. All rights reserved.
//

import Foundation
import SceneKit.SCNGeometry

extension SCNGeometry {
    static func Box(width: CGFloat, height: CGFloat, length: CGFloat) -> SCNGeometry {
        let w = width / 2
        let h = height / 2
        let l = length / 2
        let src = SCNGeometrySource(vertices: [
            // bottom 4 vertices
            SCNVector3(-w, -h, -l),
            SCNVector3(w, -h, -l),
            SCNVector3(w, -h, l),
            SCNVector3(-w, -h, l),
            
            // top 4 vertices
            SCNVector3(-w, h, -l),
            SCNVector3(w, h, -l),
            SCNVector3(w, h, l),
            SCNVector3(-w, h, l),
            ])
        let indices: [UInt32] = [
            // bottom face
            0, 1, 3,
            3, 1, 2,
            // left face
            0, 3, 4,
            4, 3, 7,
            // right face
            1, 5, 2,
            2, 5, 6,
            // top face
            4, 7, 5,
            5, 7, 6,
            // front face
            3, 2, 7,
            7, 2, 6,
            // back face
            0, 4, 1,
            1, 4, 5,
        ]
        let inds = SCNGeometryElement(indices: indices, primitiveType: .polygon)
        return SCNGeometry.init(sources: [src], elements: [inds])
    }
}
