//
//  Text+Extensions.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 11.02.2023.
//

import SwiftUI

extension Text {
    init(_ text: Strings) {
        self.init(text.rawValue.localized(LocalizationService.shared.language))
    }
}
