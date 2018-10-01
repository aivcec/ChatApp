//
//  MessagesVM.swift
//  ChatApp
//
//  Created by Antonio Ivcec on 14/9/18.
//  Copyright © 2018 Antonio Ivcec. All rights reserved.
//

class MessagesVM: MessagesVMType {
    
    // MARK: - Delegates / Services
    
    private let service: MessagesService
    private weak var coordinatorDelegate: MessagesVMCoordinatorDelegate?
    weak var viewDelegate: MessagesVMViewDelegate? {
        didSet {
            checkIfLoggedIn()
        }
    }
    
    // MARK: - Properties
    
    var messagesData: [UserCellData] = []
    private var messagesDictionary = [String: UserCellData]()
    private var timer: Timer?
    
    // MARK: - Init
    
    init(delegate: MessagesVMCoordinatorDelegate, service: MessagesService) {
        self.coordinatorDelegate = delegate
        self.service = service        
    }
    
    // MARK: - Actions
    
    func checkIfLoggedIn() {
        if service.isUserLoggedIn  {
            setupUser()
        } else {
            coordinatorDelegate?.navigate(to: .login)
        }
    }
    
    func handleLogout() {
        service.logout {
            self.coordinatorDelegate?.navigate(to: .login)
        }
    }
    
    func handleNewMessage() {
        coordinatorDelegate?.navigate(to: .newMessage)
    }
    
    func attemptTableReload() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReload), userInfo: nil, repeats: false)
    }
    
    @objc func handleReload() {
        messagesData = Array(messagesDictionary.values)
        messagesData.sort { d1, d2 in
            guard let first = d1.message.timestamp?.intValue, let second = d2.message.timestamp?.intValue else { fatalError() }
            
            return first > second
        }
        
        self.viewDelegate?.reloadRequired()
    }
    
    func observeUserMessages() {
        
        service.observeMessageAdded { [weak self] message, user in
            guard let id = user.id else { return }
            
            self?.messagesDictionary[id] = UserCellData(message: message, user: user)
            self?.attemptTableReload()
        }
        
        service.observeMessageRemoved { [weak self] messageId in
            self?.messagesDictionary.removeValue(forKey: messageId)
            self?.handleReload()
        }
    }
    
    func handleDeleteAt(row: Int) {
        service.deleteMessage(message: messagesData[row].message)
    }
    
    func handleTapAt(row: Int) {
        guard let partnerId = messagesData[row].user.id else { return }
        
        service.fetchUser(id: partnerId) { user in
            self.coordinatorDelegate?.navigate(to: .chat(user))
        }
    }
    
    func setupUser() {
        service.fetchCurrentUser { user in
            self.setupWithUser(user)
        }
    }
    
    func setupWithUser(_ user: User) {
        observeUserMessages()
        viewDelegate?.setupWithUser(user)
    }
}

// MARK: - UserDelegate

extension MessagesVM: UserDelegate {
    
    func didAuthorizeUser() {
        messagesData.removeAll()
        messagesDictionary.removeAll()
        viewDelegate?.reloadRequired()
        
        service.fetchCurrentUser { user in
            self.setupWithUser(user)
        }
    }
}
