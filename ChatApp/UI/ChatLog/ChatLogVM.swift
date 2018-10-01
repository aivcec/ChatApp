//
//  ChatLogVM.swift
//  ChatApp
//
//  Created by Antonio Ivcec on 24/9/18.
//  Copyright © 2018 Antonio Ivcec. All rights reserved.
//

import AVFoundation

class ChatLogVM: ChatLogVMType {
    
    // MARK: - Delegates / Service
    
    weak var viewDelegate: ChatLogVMViewDelegate? {
        didSet {
            observeMessages()
        }
    }
    private let service: ChatLogService
    
    // MARK: - Properties
    
    let user: User
    var messageData: [ChatMessageCellData] = [ChatMessageCellData]()
    
    // MARK: - Init
    
    init(user: User, delegate: ServiceDelegateProtocol, service: ChatLogService) {
        self.user = user
        self.service = service
    }
    
    // MARK: - Actions
    
    func observeMessages() {
        service.observeMessagesFor(id: user.id) { message in
            self.addCellData(message)
            self.viewDelegate?.messageArrived()
        }
    }
    
    private func addCellData(_ message: Message) {
        let isOutgoing = message.toId == user.id
        
        let cellData = ChatMessageCellData(message: message,
                                           isOutgoing: isOutgoing,
                                           profileImageUrl: isOutgoing ? nil : user.profileImageUrl)
        
        messageData.append(cellData)
    }
    
    func sendMessageWith(text: String?) {
        guard let message = text, !message.isEmpty else { return }
        
        service.sendMessageWithText(message, toId: user.id) {
            self.viewDelegate?.messageSent()
        }
    }
    
    func sendMessageWith(image: UIImage?) {
        guard let image = image, let toId = user.id else { return }
        
        service.sendMessageWithImage(image, toId: toId) {
            
        }
    }
    
    func sendMessageWith(videoUrl: URL) {
        guard let toId = user.id else { return }
        
        service.sendMessageWith(videoUrl: videoUrl, toId: toId, onUploadProgress: { progress in
            self.viewDelegate?.setNavigationTitle(progress)
        }, onUploadSuccess: {
            self.viewDelegate?.setNavigationTitle(self.user.name)
        })
    }
}
