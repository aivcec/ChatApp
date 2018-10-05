//
//  MessagesService.swift
//  ChatApp
//
//  Created by Antonio Ivcec on 24/9/18.
//  Copyright © 2018 Antonio Ivcec. All rights reserved.
//

class MessagesService: BaseService {
    
    var isUserLoggedIn: Bool {
        get {
            return authRef.currentUser != nil
        }
    }
    
    func logout(completion: @escaping EmptyCompletionBlock) {
        do {
            try authRef.signOut()
            completion()
        } catch let logoutError {
            delegate?.service(self, didFailWithErrorTitle: logoutError.localizedDescription)
        }
    }
    
    func observeMessageAdded(_ onMessageReceived: @escaping MessageUserCompletionBlock) {
        guard let userId = authRef.currentUser?.uid else { return }
        
        let ref = databaseRef.child(Node.userMessages).child(userId)
        ref.observe(.childAdded, with: { snapshot in
            let partnerId = snapshot.key
            self.databaseRef.child(Node.userMessages).child(userId).child(partnerId).observe(.childAdded) { snapshot in
                let messageId = snapshot.key
                self.fetchMesageWithId(messageId, completion: onMessageReceived)
            }
        })
    }
    
    func observeMessageRemoved(_ onMessageDeleted: @escaping StringCompletionBlock) {
        guard let userId = authRef.currentUser?.uid else { return }
        
        let ref = databaseRef.child(Node.userMessages).child(userId)
        ref.observe(.childRemoved) { snapshot in
            onMessageDeleted(snapshot.key)
        }
    }
    
    func fetchCurrentUser(completion: @escaping UserCompletionBlock) {
        if let uid = authRef.currentUser?.uid {
            fetchUser(id: uid, completion: completion)
        }
    }
    
    func fetchUser(id: String, completion: @escaping UserCompletionBlock) {
        let ref = databaseRef.child(Node.users).child(id)
        ref.observeSingleEvent(of: .value) { snapshot in
            
            if let dictionary = snapshot.value as? [String: Any] {
                
                let user = User()
                user.id = snapshot.key
                user.setValuesForKeys(dictionary)
                
                completion(user)
            }
        }
    }
    
    func fetchMesageWithId(_ id: String, completion: @escaping MessageUserCompletionBlock) {
        databaseRef.child(Node.messages).child(id).observeSingleEvent(of: .value) { snapshot in
            if let dictionary = snapshot.value as? [String : AnyObject] {
                let message = Message()
                message.setValuesForKeys(dictionary)
                
                if let partnerId = self.chatPartnerId(for: message) {
                    self.fetchUser(id: partnerId) { user in
                        completion(message, user)
                    }
                }
            }
        }
    }
    
    func deleteMessage(message: Message) {
        guard let uid = authRef.currentUser?.uid, let partnerId = chatPartnerId(for: message) else { return }
        
        databaseRef.child(Node.userMessages).child(uid).child(partnerId).removeValue { error, ref in
            if let error = error {
                self.delegate?.service(self, didFailWithErrorTitle: error.localizedDescription)
            }
        }
    }
    
    private func chatPartnerId(for message: Message) -> String? {
        if message.fromId == authRef.currentUser?.uid {
            return message.toId
        } else {
            return message.fromId
        }
    }
}
