//
//  UIControllerJoystik.swift
//  HeightMapAR
//
//  Created by Tran Giang Long on 16.06.19.
//  Copyright © 2019 Tran Giang Long. All rights reserved.
//

import SpriteKit

class UIControllerJoystik : UIController {
    
    var leftJoytick = TLAnalogJoystick(withDiameter: 100)
    let kLeftJoystikPosition = CGPoint(x: 60, y: 60)
    
    func enableJoystik() {
        
        if leftJoytick.parent == nil {
            leftJoytick.position = kLeftJoystikPosition
            scene.addChild(leftJoytick)
        }
    }
    
    func disableJoystik() {
        leftJoytick.removeFromParent()
    }

    deinit {
        leftJoytick.invalidate() // Memory leak in library. TODO: contact to author to fix this problem. (CADisplayLink)
    }
}
