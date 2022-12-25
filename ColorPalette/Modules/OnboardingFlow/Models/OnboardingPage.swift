//
//  OnboardingPage.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 11.11.2022.
//

import Combine

struct OnboardingPage {
    let pageType: OnboardingPageType
    let tap: PassthroughSubject<Void, Never>
}
