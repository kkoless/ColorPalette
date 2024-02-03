//
//  OnboardingService.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 01.12.2022.
//

import Foundation

final class OnboardingManager {
  static let shared: OnboardingManager = .init()
  
  private init() {}
  
  var isOnboarding: Bool {
    get { UserDefaults.standard.bool(forKey: UserDefaultsKey.isOnboarding.rawValue) }
    set { UserDefaults.standard.setValue(newValue, forKey: UserDefaultsKey.isOnboarding.rawValue) }
  }
}
