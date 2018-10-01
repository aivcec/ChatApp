//
//  NSObject+className.swift
//  ChatApp
//
//  Created by Antonio Ivcec on 14/9/18.
//  Copyright © 2018 Antonio Ivcec. All rights reserved.
//

import Foundation

extension NSObject {
    
    var className: String {
        return String(describing: type(of: self))
    }
    
    class var className: String {
        return String(describing: self)
    }
}
