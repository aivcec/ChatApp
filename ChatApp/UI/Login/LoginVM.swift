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
    
    // MARK: - Validators
    
    private let nameValidator: StringValidator
    private let emailValidator: StringValidator
    private let passValidator: StringValidator

    // MARK: - Init
    
    init(delegate: LoginVMCoordinatorDelegate, service: LoginService) {
        self.coordinatorDelegate = delegate
        self.service = service
        
        self.nameValidator = LengthValidator(minLength: 3)
        self.emailValidator = EmailValidator()
        self.passValidator = LengthValidator(minLength: 6)
    }
    
    // MARK: - Actions
    
    func register(email: String?, password: String?, name: String?, image: UIImage?) {
        guard let email = email, let password = password, let name = name, let image = image else {
            showRegisterInfoMissingError()
            return
        }
        
        if !nameValidator.isValid(name) {
            showNameValidationError()
            return
        }
        
        if !emailValidator.isValid(email) {
            showEmailValidationError()
            return
        }
        
        if !passValidator.isValid(password) {
            showPassValidationError()
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
            showLoginInfoMissingError()
            return
        }
        
        if !emailValidator.isValid(email) {
            showEmailValidationError()
            return
        }
        
        if !passValidator.isValid(password) {
            showPassValidationError()
            return
        }
        
        service.login(email: email, password: password) {
            self.coordinatorDelegate?.navigate(to: .login)
        }
    }
    
    // MARK: - Alerts
    
    private func showLoginInfoMissingError() {
        coordinatorDelegate?.showAlert(title: "Error", message: "Please enter email and pasword")
    }
    
    private func showRegisterInfoMissingError() {
        coordinatorDelegate?.showAlert(title: "Error", message: "Please add name, email, pasword and profile image")
    }
    
    private func showNameValidationError() {
        coordinatorDelegate?.showAlert(title: "Error", message: "Name should be at least 3 characters long")
    }
    
    private func showEmailValidationError() {
        coordinatorDelegate?.showAlert(title: "Error", message: "Please enter a valid email")
    }
    
    private func showPassValidationError() {
        coordinatorDelegate?.showAlert(title: "Error", message: "Password should be at least 6 characters long")
    }
}
