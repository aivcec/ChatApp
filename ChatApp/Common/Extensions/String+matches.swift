//
//  String+matches.swift
//  ChatApp
//
//  Created by Antonio Ivcec on 5/10/18.
//  Copyright © 2018 Antonio Ivcec. All rights reserved.
//

extension String {
    
    func matches(regex: String) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex
                .matches(in: self, range: NSRange(self.startIndex..., in: self))
            return results.count > 0 ? true : false
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return false
        }
    }
}
