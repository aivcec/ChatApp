//
//  NewMessageService.swift
//  ChatApp
//
//  Created by Antonio Ivcec on 24/9/18.
//  Copyright © 2018 Antonio Ivcec. All rights reserved.
//

class NewMessageService: BaseService {
    
    func fetchUsers(onUserFetched: @escaping UserCompletionBlock) {
        databaseRef.child(Node.users).observe(.childAdded) { snapshot in
            if let dict = snapshot.value as? [String: Any] {
                let user = User()
                user.setValuesForKeys(dict)
                user.id = snapshot.key
                
                onUserFetched(user)
            }
        }
    }
}
