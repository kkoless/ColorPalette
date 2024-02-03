//
//  OnboardingPageType.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 11.11.2022.
//

import UIKit

enum OnboardingPageType: Int, CaseIterable, Identifiable {
  case firstPage
  case secondPage
  case thirdPage
  
  var id: Int {
    switch self {
    case .firstPage: return 0
    case .secondPage: return 1
    case .thirdPage: return 2
    }
  }
}

extension OnboardingPageType {
  var text: Strings {
    switch self {
    case .firstPage: return .firstOnboardingText
    case .secondPage: return .secondOnboardingText
    case .thirdPage: return .thirdOnboardingText
    }
  }
  
  var image: UIImage {
    switch self {
    case .firstPage: return UIImage(named: "firstOnboarding")!
    case .secondPage: return UIImage(named: "secondOnboarding")!
    case .thirdPage: return UIImage(named: "thirdOnboarding")!
    }
  }
  
  var backgroundColor: UIColor {
    switch self {
    case .firstPage: return .onboardingColor1
    case .secondPage: return .onboardingColor2
    case .thirdPage: return .onboardingColor3
    }
  }
  
  var foregroundColor: UIColor {
    switch self {
    case .firstPage: return .onboardingColor1.invertColor()
    case .secondPage: return .onboardingColor2.invertColor()
    case .thirdPage: return .onboardingColor3.invertColor()
    }
  }
}

extension OnboardingPageType {
  var isLastPage: Bool {
    switch self {
    case .thirdPage: return true
    default: return false
    }
  }
}
