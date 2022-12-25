//
//  PaletteStorageManager.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 25.12.2022.
//

import Foundation

final class PaletteStorageManager: ObservableObject {
    @Published private(set) var palettes: [ColorPalette]
    
    static let shared: PaletteStorageManager = .init()
    
    private init() {
        self.palettes = []
        print("\(self) INIT")
    }
    
    deinit {
        print("\(self) DEINIT")
    }
}

extension PaletteStorageManager {
    func addPallete(_ newPalette: ColorPalette) {
        palettes.append(newPalette)
    }
    
    func removePalette(from index: Int) {
        palettes.remove(at: index)
    }
}
