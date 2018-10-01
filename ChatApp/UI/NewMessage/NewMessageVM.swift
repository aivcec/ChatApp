//
//  NewMessageVM.swift
//  ChatApp
//
//  Created by Antonio Ivcec on 24/9/18.
//  Copyright © 2018 Antonio Ivcec. All rights reserved.
//

class NewMessageVM: NewMessageVMType {

    // MARK: - Delegates / Service
    
    private let service: NewMessageService
    private weak var coordinatorDelegate: NewMessageVMCoordinatorDelegate?
    var viewDelegate: NewMessageVMViewDelegate? {
        didSet {
            fetchUsers()
        }
    }
    
    // MARK: - Properties
    
    var users: [User] = [User]()
    
    // MARK: - Init
    
    init(delegate: NewMessageVMCoordinatorDelegate, service: NewMessageService) {
        self.coordinatorDelegate = delegate
        self.service = service
    }
    
    // MARK: - Actions
    
    func fetchUsers() {
        service.fetchUsers { user in
            self.users.append(user)
            self.viewDelegate?.reloadRequired()
        }
    }
    
    func handleTapAt(row: Int) {
        coordinatorDelegate?.navigate(to: .chat(users[row]))
    }
    
    func handleCancel() {
        coordinatorDelegate?.navigate(to: .messages)
    }
}
