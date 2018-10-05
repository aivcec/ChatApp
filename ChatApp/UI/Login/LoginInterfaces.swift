//
//  LoginInterfaces.swift
//  ChatApp
//
//  Created by Antonio Ivcec on 28/9/18.
//  Copyright © 2018 Antonio Ivcec. All rights reserved.
//

import Foundation

enum LoginNavigationOption {
    case login
}

protocol LoginVMCoordinatorDelegate: VMCoordinatorDelegate {
    func navigate(to option: LoginNavigationOption)
}

protocol LoginVMType {
    func register(email: String?, password: String?, name: String?, image: UIImage?)
    func login(email: String?, password: String?)
}
