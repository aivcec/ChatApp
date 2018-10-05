//
//  UserCellData.swift
//  ChatApp
//
//  Created by Antonio Ivcec on 28/9/18.
//  Copyright © 2018 Antonio Ivcec. All rights reserved.
//

struct UserCellData {
    let message: Message
    let user: User
    
    func displayText() -> String {
        if let text = message.text {
            return text
        } else if message.videoUrl != nil {
            return "Video message"
        } else {
            return "Image message"
        }
    }
}
