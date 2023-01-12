//
//  PopularPalettesManager.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 09.01.2023.
//

import Foundation

final class PopularPalettesManager {
    let palettes: [ColorPalette]
    static let shared = PopularPalettesManager()
    
    private init() {
        let popularPalettes = PopularPaletteJSON.parse(jsonFile: "popular_color_pallets")?.data ?? []
        self.palettes = popularPalettes
            .sorted(by: { $0.saves > $1.saves })
            .map { $0.colorPalette }
        
        print("\(self) INIT")
    }
    
    deinit {
        print("\(self) DEINIT")
    }
}
