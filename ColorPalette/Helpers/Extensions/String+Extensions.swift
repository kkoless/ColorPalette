//
//  String+Extensions.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 11.11.2022.
//

import Foundation

extension String {
    enum Strings: String {
        case firstOnboardingText
        case secondOnboardingText
        case thirdOnboardingText
    }
    
    func localized() -> String {
        return NSLocalizedString(self, comment: "")
    }
    
    init(_ localized: Strings) {
        self.init(localized.rawValue.localized())
    }
}

extension String {
    func customHash() -> UInt64 {
        var result = UInt64(5381)
        let buf = [UInt8](self.utf8)
        for b in buf {
            result = 127 * (result & 0x00ffffffffffffff) + UInt64(b)
        }
        return result
    }
}
