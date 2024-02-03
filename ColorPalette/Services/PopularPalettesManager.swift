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
    let popularPalettes = PopularPaletteJSON
      .parse(jsonFile: "popular_color_pallets")?.data ?? []
      .removingDuplicates(byKey: { $0.colors })

    self.palettes = popularPalettes
      .filter { $0.colors.count <= 5 }
      .map { $0.colorPalette }

    print("\(self) INIT")
  }

  deinit {
    print("\(self) DEINIT")
  }
}
