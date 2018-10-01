//
//  MessagesCoordinator.swift
//  ChatApp
//
//  Created by Antonio Ivcec on 14/9/18.
//  Copyright © 2018 Antonio Ivcec. All rights reserved.
//

import UIKit

protocol UserDelegate: class {
    func didAuthorizeUser()
}

class MessagesCoordinator: BaseCoordinator {
    
    weak var userDelegate: UserDelegate?
    
    override func start() {
        showMessages()
    }
    
    override func finish() {
        
    }
    
    func showMessages() {
        let service = MessagesService(delegate: self)
        let vm = MessagesVM(delegate: self, service: service)
        userDelegate = vm
        let vc = MessagesVC(vm: vm)
        
        rootNC.setViewControllers([vc], animated: true)
    }
    
    func openChatLogForUser(_ user: User) {
        let service = ChatLogService(delegate: self)
        let vm = ChatLogVM(user: user, delegate: self, service: service)
        let vc = ChatLogVC(vm: vm)
        
        rootNC.pushViewController(vc, animated: true)
    }
    
    func showLogin() {
        let service = LoginService(delegate: self)
        let vm = LoginVM(delegate: self, service: service)
        let vc = LoginVC(vm: vm)
        
        rootNC.present(vc, animated: true)
    }
    
    func showNewMessage() {
        let service = NewMessageService(delegate: self)
        let vm = NewMessageVM(delegate: self, service: service)
        let vc = NewMessageVC(vm: vm)
        
        rootNC.present(UINavigationController(rootViewController: vc), animated: true)
    }
}

extension MessagesCoordinator: MessagesVMCoordinatorDelegate {
    
    func navigate(to option: MessagesNavigationOption) {
        switch option {
        case .chat(let user):
            openChatLogForUser(user)
        case .login:
            showLogin()
        case .newMessage:
            showNewMessage()
        }
    }
}

extension MessagesCoordinator: LoginVMCoordinatorDelegate {
    
    
    func navigate(to option: LoginNavigationOption) {
        userDelegate?.didAuthorizeUser()
        rootNC.dismiss(animated: true)
    }
}

extension MessagesCoordinator: NewMessageVMCoordinatorDelegate {
    
    func navigate(to option: NewMessageNavigationOption) {
        switch option {
        case .chat(let user):
            rootNC.dismiss(animated: true)
            openChatLogForUser(user)
        case .messages:
            rootNC.dismiss(animated: true)
        }
    }
}
