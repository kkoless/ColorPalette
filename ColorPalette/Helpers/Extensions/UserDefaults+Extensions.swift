//
//  UserDefaults+Extensions.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 01.12.2022.
//

import Foundation

enum UserDefaultsKey: String {
    case isOnboarding
}

extension UserDefaults {
    func setValue(_ value: Any, forKey: UserDefaultsKey) {
        self.setValue(value, forKey: forKey.rawValue)
    }
}
