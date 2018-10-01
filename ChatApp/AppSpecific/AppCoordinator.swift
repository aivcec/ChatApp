//
//  AppCoordinator.swift
//  ChatApp
//
//  Created by Antonio Ivcec on 14/9/18.
//  Copyright © 2018 Antonio Ivcec. All rights reserved.
//

import UIKit

class AppCoordinator: BaseCoordinator {
    
    let window: UIWindow?
    
    init(window: UIWindow?) {
        self.window = window
        
        super.init(rootNC: UINavigationController())
    }
    
    override func start() {
        guard let window = window else { return }
        
        window.makeKeyAndVisible()
        window.rootViewController = rootNC
        
        startMessagesCoordinator()
    }
    
    private func startMessagesCoordinator() {
        let messagesCoordinator = MessagesCoordinator(rootNC: rootNC)
        addChildCoordinator(messagesCoordinator)
        messagesCoordinator.start()
    }
    
    override func finish() {
    
    }
}
