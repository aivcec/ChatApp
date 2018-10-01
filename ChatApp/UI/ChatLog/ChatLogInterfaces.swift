//
//  ChatLogInterfaces.swift
//  ChatApp
//
//  Created by Antonio Ivcec on 28/9/18.
//  Copyright © 2018 Antonio Ivcec. All rights reserved.
//

import Foundation

protocol ChatLogVMType: class {
    var viewDelegate: ChatLogVMViewDelegate? { get set }
    var user: User { get }
    var messageData: [ChatMessageCellData] { get }
    
    func sendMessageWith(text: String?)
    func sendMessageWith(image: UIImage?)
    func sendMessageWith(videoUrl: URL)
}

protocol ChatLogVMViewDelegate: class {
    func messageSent()
    func messageArrived()
    func setNavigationTitle(_ title: String?)
}
