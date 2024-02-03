//
//  LocalizationService.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 11.02.2023.
//

import Foundation
import Combine

final class LocalizationService: ObservableObject {
  @Published var language: Language {
    didSet {
      UserDefaults.standard.setValue(language.rawValue, forKey: UserDefaultsKey.language.rawValue)
    }
  }
  
  static let shared: LocalizationService = .init()
  
  private init() {
    if let languageString = UserDefaults.standard.string(forKey: UserDefaultsKey.language.rawValue) {
      self.language = Language(rawValue: languageString) ?? .russian
    } else {
      self.language = Language(rawValue: Locale.current.languageCode ?? "en") ?? .russian
    }
    
    print("\(self) INIT")
  }
}
