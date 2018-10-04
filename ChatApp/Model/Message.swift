//
//  Message.swift
//  ChatApp
//
//  Created by Antonio Ivcec on 28/8/18.
//  Copyright © 2018 Antonio Ivcec. All rights reserved.
//

class Message: NSObject {
    @objc var fromId: String?
    @objc var toId: String?
    @objc var text: String?
    @objc var timestamp: NSNumber?
    @objc var imageUrl: String?
    @objc var imageWidth: NSNumber?
    @objc var imageHeight: NSNumber?
    @objc var videoUrl: String?
}
