//
//  UIColor+extension.swift
//  ChatApp
//
//  Created by Antonio Ivcec on 20/8/18.
//  Copyright © 2018 Antonio Ivcec. All rights reserved.
//

import UIKit

extension UIColor {
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}
