//
//  TemplatePaletteManager.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 25.12.2022.
//

import Foundation

final class TemplatePaletteManager: ObservableObject {
    @Published private(set) var colors: [AppColor]
    
    init() {
        self.colors = []
        print("\(self) INIT")
    }
    
    deinit {
        print("\(self) DEINIT")
    }
}

extension TemplatePaletteManager {
    func addColor(_ newColor: AppColor) {
        colors.append(newColor)
    }
    
    func deleteColor(_ colorForDelete: AppColor) {
        if let index = colors.firstIndex(where: { $0 == colorForDelete }) {
            colors.remove(at: index)
        }
    }
    
    func createPalette() -> ColorPalette {
        ColorPalette(colors: colors)
    }
}
