//
//  UITextField+padding.swift
//  ChatApp
//
//  Created by Antonio Ivcec on 20/8/18.
//  Copyright © 2018 Antonio Ivcec. All rights reserved.
//

import UIKit

extension UITextField {
    
    func setLeftPadding(_ amount: CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPadding(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
