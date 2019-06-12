//
//  UIColor.swift
//  HeightMapAR
//
//  Created by Tran Giang Long on 10.06.19.
//  Copyright © 2019 Tran Giang Long. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    static func randomColor(seed: String) -> UIColor {
        
        var total: Int = 0
        for u in seed.unicodeScalars {
            total += Int(UInt32(u))
        }
        
        srand48(total * 200)
        let r = CGFloat(drand48())
        
        srand48(total)
        let g = CGFloat(drand48())
        
        srand48(total / 200)
        let b = CGFloat(drand48())
        
        return UIColor(red: r, green: g, blue: b, alpha: 1)
    }
}
