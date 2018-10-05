//
//  LengthValidator.swift
//  ChatApp
//
//  Created by Antonio Ivcec on 5/10/18.
//  Copyright © 2018 Antonio Ivcec. All rights reserved.
//

class LengthValidator: StringValidator {
    
    private let minLength: UInt
    
    init(minLength: UInt) {
        self.minLength =  minLength
    }
    
    func isValid(_ value: String) -> Bool {
        return value.count >= minLength
    }
}
