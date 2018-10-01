//
//  LoginVM.swift
//  ChatApp
//
//  Created by Antonio Ivcec on 24/9/18.
//  Copyright © 2018 Antonio Ivcec. All rights reserved.
//

class LoginVM: LoginVMType {
    
    // MARK: - Delegates / Services
    
    weak var coordinatorDelegate: LoginVMCoordinatorDelegate?
    private let service: LoginService
    
    // MARK: - Init
    
    init(delegate: LoginVMCoordinatorDelegate, service: LoginService) {
        self.coordinatorDelegate = delegate
        self.service = service
    }
    
    // MARK: - Actions
    
    func register(email: String?, password: String?, name: String?, image: UIImage?) {
        guard let email = email, let password = password, let name = name, let image = image else {
            print("Form is not valid")
            return
        }
        
        let imageName = NSUUID().uuidString
        if let uploadData = image.jpegData(compressionQuality: 0.1) {
            service.register(email: email, password: password, name: name, imageName: imageName, uploadData: uploadData) {
                self.coordinatorDelegate?.navigate(to: .login)
            }
        }
    }
    
    func login(email: String?, password: String?) {
        guard let email = email, let password = password else {
            print("Form is not valid")
            return
        }
        
        service.login(email: email, password: password) {
            self.coordinatorDelegate?.navigate(to: .login)
        }
    }
}
