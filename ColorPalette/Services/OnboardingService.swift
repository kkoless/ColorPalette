//
//  OnboardingService.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 01.12.2022.
//

import Foundation

final class OnboardingService {
    static let instance: OnboardingService = .init()
    
    private let defaults = UserDefaults.standard
    private let customQueue = DispatchQueue(label: "com.onboardingService.queue",
                                            attributes: .concurrent)
    
    private init() {}
    
    var isOnboarding: Bool {
        get {
            customQueue.sync {
                defaults.bool(forKey: UserDefaultsKey.isOnboarding.rawValue)
            }
        }
        set {
            customQueue.async(flags: .barrier) { [weak self] in
                self?.defaults.setValue(newValue, forKey: .isOnboarding)
            }
        }
    }
}
