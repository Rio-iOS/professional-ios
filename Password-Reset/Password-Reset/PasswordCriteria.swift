//
//  PasswordCriteria.swift
//  Password-Reset
//
//  Created by 藤門莉生 on 2024/06/30.
//

import Foundation

struct PasswordCriteria {
    static func lengthCriteriaMet(_ text: String) -> Bool {
        text.count >= 8 && text.count <= 32
    }
    
    static func noSpaceCriteriaMet(_ text: String) -> Bool {
        text.rangeOfCharacter(from: NSCharacterSet.whitespaces) == nil
    }
    
    static func lengthAndNoSpaceMet(_ text: String) -> Bool {
        lengthCriteriaMet(text) && noSpaceCriteriaMet(text)
    }
    
    static func uppercaseMet(_ text: String) -> Bool {
        text.range(of: "[A-Z]+", options: .regularExpression) != nil
    }
    
    static func lowercaseMet(_ text: String) -> Bool {
        text.range(of: "[a-z]+", options: .regularExpression) != nil
    }
   
    // \\d = [0-9]
    static func digitMet(_ text: String) -> Bool {
        text.range(of: "\\d+", options: .regularExpression) != nil
    }
   
    // regex escaped @:?!()$#,.\/
    static func specialCharacterMet(_ text: String) -> Bool {
        text.range(of: "[@:?!()$#,.\\\\/]+", options: .regularExpression) != nil
    }
}
