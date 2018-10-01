//
//  NewMessageInterfaces.swift
//  ChatApp
//
//  Created by Antonio Ivcec on 28/9/18.
//  Copyright © 2018 Antonio Ivcec. All rights reserved.
//

import Foundation

enum NewMessageNavigationOption {
    case chat(User)
    case messages
}

protocol NewMessageVMCoordinatorDelegate: class {
    func navigate(to option: NewMessageNavigationOption)
}

protocol NewMessageVMType: class {
    var viewDelegate: NewMessageVMViewDelegate? { get set }
    var users: [User] { get }
    
    func handleTapAt(row: Int)
    func handleCancel()
}

protocol NewMessageVMViewDelegate: class {
    func reloadRequired()
}
