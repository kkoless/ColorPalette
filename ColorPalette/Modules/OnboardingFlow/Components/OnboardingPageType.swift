//
//  OnboardingPageType.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 11.11.2022.
//

import UIKit

enum OnboardingPageType: CaseIterable, Hashable, Identifiable {
    case firstPage
    case secondPage
    case thirdPage
    
    var id: Int {
        switch self {
            case .firstPage:
                return 0
            case .secondPage:
                return 1
            case .thirdPage:
                return 2
        }
    }
    
}

extension OnboardingPageType {
    var text: String {
        switch self {
            case .firstPage:
                return String(.firstOnboardingText)
            case .secondPage:
                return String(.secondOnboardingText)
            case .thirdPage:
                return String(.thirdOnboardingText)
        }
    }
    
    var image: UIImage? {
        switch self {
            case .firstPage:
                return UIImage(named: "firstOnboarding")
            case .secondPage:
                return UIImage(named: "secondOnboarding")
            case .thirdPage:
                return UIImage(named: "thirdOnboarding")
        }
    }
    
    var foregroundColor: UIColor {
        switch self {
            case .firstPage:
                return .systemPink
            case .secondPage:
                return .systemRed
            case .thirdPage:
                return .systemBlue
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
