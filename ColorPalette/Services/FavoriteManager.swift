//
//  FavoriteManager.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 24.12.2022.
//

import Foundation

final class FavoriteManager: ObservableObject {
    @Published private(set) var items: Set<AppColor>
    
    init() {
        self.items = []
        print("\(self) INIT")
    }
    
    func addColor(newColor: AppColor) {
        items.insert(newColor)
        print(items.count)
    }
    
    func removeColor(color: AppColor) {
        if items.contains(color) {
            items.remove(color)
        }
    }
    
    deinit {
        print("\(self) DEINIT")
    }
}
