//
//  View+Extensions.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 27.12.2022.
//

import SwiftUI

extension View {
    func eraseToAnyView() -> AnyView {
        AnyView(self)
    }
}

extension View {
    func setCustomNavigationBarAppearance() -> some View {
        modifier(CustomNavigationBarAppearance())
    }
    
    func setCustomNavigationBarTitleAppearance(font: Font = .headline, isBold: Bool = true, opacity: Double = 1) -> some View {
         modifier(CustomNavigationBarTitleAppearance(font: font, isBold: isBold, opacity: opacity))
     }
}
