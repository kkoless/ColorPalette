//
//  FavoriteManager.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 24.12.2022.
//

import Foundation
import CoreData

final class FavoriteManager: ObservableObject {
    @Published private(set) var colors: [AppColor] = []
    @Published private(set) var palettes: [ColorPalette] = []
    
    private let isGuest = CredentialsManager.shared.isGuest
    private let coreDataManager: CoreDataManager = .init()
    static let shared = FavoriteManager()
    
    private init() {        
        if isGuest {
            self.colors = self.coreDataManager.getColors()
            self.palettes = self.coreDataManager.getPalettes()
        } else {
            // Server
        }
        
        print("\(self) INIT")
    }
    
    deinit {
        print("\(self) DEINIT")
    }
}

extension FavoriteManager {
    func addColor(_ newColor: AppColor) {
        if isGuest {
            coreDataManager.addColor(newColor)
        } else {
            // Server
        }
        
        colors.append(newColor)
    }
    
    func addPalette(_ newPalette: ColorPalette) {
        if isGuest {
            coreDataManager.addPalette(newPalette)
        } else {
            // Server
        }
        
        palettes.append(newPalette)
    }
    
    func removeColor(_ color: AppColor) {
        if let index = colors.firstIndex(where: { $0 == color })  {
            if isGuest {
                coreDataManager.removeColor(color)
            } else {
                // Server
            }
            
            colors.remove(at: index)
        }
    }
    
    func removePalette(_ palette: ColorPalette) {
        if let index = palettes.firstIndex(where: { $0 == palette })  {
            if isGuest {
                coreDataManager.removePalette(palette)
            } else {
                // Server
            }
            
            palettes.remove(at: index)
        }
    }
}
