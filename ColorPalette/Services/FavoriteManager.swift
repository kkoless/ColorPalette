//
//  FavoriteManager.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 24.12.2022.
//

import Foundation

final class FavoriteManager: ObservableObject {
    @Published private(set) var items: [AppColor]
    
    static let shared = FavoriteManager()
    
    private init() {
        self.items = []
        print("\(self) INIT")
    }
    
    deinit {
        print("\(self) DEINIT")
    }
}

extension FavoriteManager {
    func addColor(newColor: AppColor) {
        items.append(newColor)
    }
    
    func removeColor(color: AppColor) {
        if let index = items.firstIndex(where: { $0 == color }) {
            items.remove(at: index)
        }
    }
}
