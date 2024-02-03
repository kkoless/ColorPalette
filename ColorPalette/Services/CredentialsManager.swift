//
//  CredentialsManager.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 01.12.2022.
//

import Foundation

final class CredentialsManager {
  static let shared = CredentialsManager()
  
  private init() {}
  
  var token: String? {
    get { UserDefaults.standard.string(forKey: UserDefaultsKey.token.rawValue) }
    set { UserDefaults.standard.setValue(newValue, forKey: UserDefaultsKey.token.rawValue)}
  }
  
  var isGuest: Bool {
    get { UserDefaults.standard.bool(forKey: UserDefaultsKey.isGuest.rawValue) }
    set { UserDefaults.standard.setValue(newValue, forKey: UserDefaultsKey.isGuest.rawValue)}
  }
}
