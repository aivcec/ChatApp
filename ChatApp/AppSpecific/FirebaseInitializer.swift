//
//  FirebaseInitializer.swift
//  ChatApp
//
//  Created by Antonio Ivcec on 28/9/18.
//  Copyright © 2018 Antonio Ivcec. All rights reserved.
//

import Firebase

class FirebaseInitializer: Initializable {
    
    func initialize() {
        if let filePath = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist"),
            let options = FirebaseOptions(contentsOfFile: filePath) {
            
            FirebaseApp.configure(options: options)
        }
    }
}
