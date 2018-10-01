//
//  CGRect+extension.swift
//  ChatApp
//
//  Created by Antonio Ivcec on 24/9/18.
//  Copyright © 2018 Antonio Ivcec. All rights reserved.
//

import UIKit

extension CGRect {
    
    static func estimatedFrameForText(text: String, withFont font: UIFont = UIFont.systemFont(ofSize: 16)) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        return text.boundingRect(with: size, options: options, attributes: [.font: font], context: nil)
    }
}
