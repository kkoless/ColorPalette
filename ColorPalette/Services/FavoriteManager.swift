//
//  FavoriteManager.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 24.12.2022.
//

import Foundation

final class FavoriteManager: ObservableObject {
    @Published private(set) var colors: [AppColor]
    @Published private(set) var palettes: [ColorPalette]
    
    static let shared = FavoriteManager()
    
    private init() {
        self.colors = []
        self.palettes = []
        print("\(self) INIT")
    }
    
    deinit {
        print("\(self) DEINIT")
    }
}

extension FavoriteManager {
    func addColor(_ newColor: AppColor) {
        colors.append(newColor)
    }
    
    func addPalette(_ newPalette: ColorPalette) {
        palettes.append(newPalette)
    }
    
    func removeColor(_ color: AppColor) {
        if let index = colors.firstIndex(where: { $0 == color })  {
            colors.remove(at: index)
        }
    }
    
    func removePalette(_ palette: ColorPalette) {
        if let index = palettes.firstIndex(where: { $0 == palette })  {
            palettes.remove(at: index)
        }
    }
}
