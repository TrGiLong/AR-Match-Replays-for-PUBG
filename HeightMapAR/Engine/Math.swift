//
//  Math.swift
//  HeightMapAR
//
//  Created by Tran Giang Long on 18.06.19.
//  Copyright © 2019 Tran Giang Long. All rights reserved.
//

import SceneKit

extension BinaryInteger {
    var degreesToRadians: CGFloat { return CGFloat(self) * .pi / 180 }
}

extension FloatingPoint {
    var degreesToRadians: Self { return self * .pi / 180 }
    var radiansToDegrees: Self { return self * 180 / .pi }
}
