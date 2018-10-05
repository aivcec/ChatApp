//
//  EmailValidator.swift
//  ChatApp
//
//  Created by Antonio Ivcec on 5/10/18.
//  Copyright © 2018 Antonio Ivcec. All rights reserved.
//

class EmailValidator: StringValidator {
    
    func isValid(_ value: String) -> Bool {
        return value.matches(regex:"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}")
    }
}
