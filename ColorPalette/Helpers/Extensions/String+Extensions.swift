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
