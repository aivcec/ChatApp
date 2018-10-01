//
//  BaseService.swift
//  ChatApp
//
//  Created by Antonio Ivcec on 26/9/18.
//  Copyright © 2018 Antonio Ivcec. All rights reserved.
//

import Firebase

typealias MessageUserCompletionBlock =  (Message, User) -> ()
typealias MessageCompletionBlock =  (Message) -> ()
typealias UserCompletionBlock =  (User) -> ()
typealias StringCompletionBlock =  (String) -> ()
typealias UrlCompletionBlock =  (URL) -> ()
typealias EmptyCompletionBlock = () -> ()

typealias Parameters = [String: Any]

class BaseService: Service {
    weak var delegate: ServiceDelegateProtocol?
    
    lazy var databaseRef = Database.database().reference()
    lazy var storageRef = Storage.storage().reference()
    lazy var authRef = Auth.auth()
    
    init(delegate: ServiceDelegateProtocol) {
        self.delegate = delegate
    }
}
