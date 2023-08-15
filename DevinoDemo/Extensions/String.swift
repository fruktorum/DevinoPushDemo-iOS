//
//  String+RegularExpression.swift
//  DevinoDemo
//
//  Created by Maria on 12.10.2019.
//  Copyright © 2019 Alexej Nenastev. All rights reserved.
//

import Foundation

extension String {
    
    var isValidEmail: Bool {
        guard self.contains("@"), self.contains(".") else { return false }
        return true
    }
    
    var isValidPhoneNumber: Bool {
        guard self.count == "+# ### ###-####".count else { return false }
        return true
    }
    
    var isValidPasswordCode: Bool {
        guard self.count > 5 && self.count < 21 && !self.isEmpty else { return false }
        return true
    }
    
    func applyPatternOnNumbers(pattern: String, replacmentCharacter: Character) -> String {
        var pureNumber = replacingOccurrences( of: "[^0-9]", with: "", options: .regularExpression)
        for index in 0 ..< pattern.count {
            guard index < pureNumber.count else { return pureNumber }
            let stringIndex = String.Index(encodedOffset: index)
            let patternCharacter = pattern[stringIndex]
            guard patternCharacter != replacmentCharacter else { continue }
            pureNumber.insert(patternCharacter, at: stringIndex)
        }
        return pureNumber
    }
}
