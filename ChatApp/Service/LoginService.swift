//
//  LoginService.swift
//  ChatApp
//
//  Created by Antonio Ivcec on 24/9/18.
//  Copyright © 2018 Antonio Ivcec. All rights reserved.
//

import UIKit

class LoginService: BaseService {
    
    func login(email: String, password: String, completion: @escaping EmptyCompletionBlock) {
        delegate?.serviceDidStartRequest(self, withIndicator: true)
        
        authRef.signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                self.delegate?.service(self, didFailWithErrorTitle: error.localizedDescription)
                return
            }
            
            self.delegate?.serviceDidSucceed(self)
            completion()
        }
    }
    
    func register(email: String, password: String, name: String, imageName: String, uploadData: Data, completion: @escaping EmptyCompletionBlock) {
        delegate?.serviceDidStartRequest(self, withIndicator: true)
        
        authRef.createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                self.delegate?.service(self, didFailWithErrorTitle: error.localizedDescription)
                return
            }
            
            guard let uid = result?.user.uid else {
                self.delegate?.service(self, didFailWithErrorTitle: "Problem fetching uid.")
                return
            }
            
            self.uploadImage(imageName: imageName, uploadData: uploadData) { url in
                let values: Parameters  = [
                    "name": name,
                    "email": email,
                    "profileImageUrl": url.absoluteString
                ]
                self.registerUserIntoDatabase(uid: uid, values: values, completion: completion)
            }
        }
    }
    
    private func uploadImage(imageName: String, uploadData: Data, completion: @escaping UrlCompletionBlock) {
        let ref = storageRef.child(Node.profileImages).child("\(imageName).png")
        
        ref.putData(uploadData, metadata: nil) { metadata, error in
            if let error = error {
                self.delegate?.service(self, didFailWithErrorTitle: error.localizedDescription)
                return
            }
            
            ref.downloadURL { url, error in
                if let error = error {
                    self.delegate?.service(self, didFailWithErrorTitle: error.localizedDescription)
                    return
                }
                
                if let url  = url {
                    completion(url)
                } else {
                    self.delegate?.service(self, didFailWithErrorTitle: "Problem fetching image url.")
                }
            }
        }
    }
    
    private func registerUserIntoDatabase(uid: String, values: [String: Any], completion: @escaping EmptyCompletionBlock) {
        let child = databaseRef.child(Node.users).child(uid)
        
        child.updateChildValues(values) { (error, ref) in
            if let error = error {
                self.delegate?.service(self, didFailWithErrorTitle: error.localizedDescription)
                return
            }
            
            self.delegate?.serviceDidSucceed(self)
            completion()
        }
    }
}
