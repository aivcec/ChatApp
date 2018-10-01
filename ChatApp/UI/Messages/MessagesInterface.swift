//
//  MessagesInterface.swift
//  ChatApp
//
//  Created by Antonio Ivcec on 28/9/18.
//  Copyright © 2018 Antonio Ivcec. All rights reserved.
//

import Foundation

enum MessagesNavigationOption {
    case chat(User)
    case login
    case newMessage
}

protocol MessagesVMCoordinatorDelegate: class {
    func navigate(to option: MessagesNavigationOption)
}

protocol MessagesVMType: class {
    var viewDelegate: MessagesVMViewDelegate? { get set }
    var messagesData: [UserCellData] { get }
        
    func handleDeleteAt(row: Int)
    func handleTapAt(row: Int)
    func handleLogout()
    func handleNewMessage()
}

protocol MessagesVMViewDelegate: class {
    func reloadRequired()
    func setupWithUser(_ user: User)
}
