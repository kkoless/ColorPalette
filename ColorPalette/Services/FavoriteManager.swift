//
//  FavoriteManager.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 24.12.2022.
//

import Foundation
import CoreData
import Combine

final class FavoriteManager: ObservableObject {
    @Published private(set) var colors: [AppColor] = []
    @Published private(set) var palettes: [ColorPalette] = []
    
    @Published private(set) var isColorsLimit: Bool = false
    @Published private(set) var isPalettesLimit: Bool = false
    
    private let coreDataManager: CoreDataManager = .init()
    private let profileManager: ProfileManager = .shared
    static let shared = FavoriteManager()
    
    private var cancellable: Set<AnyCancellable> = .init()
    
    private init() {        
        if CredentialsManager.shared.isGuest {
            self.colors = self.coreDataManager.getColors()
            self.palettes = self.coreDataManager.getPalettes()
        } else {
            // Server
        }
        
        checkColorsLimit()
        checkPalettesLimit()
        
        bindProfile()
        
        print("\(self) INIT")
    }
    
    deinit {
        print("\(self) DEINIT")
        
        cancellable.forEach { $0.cancel() }
        cancellable.removeAll()
    }
}

private extension FavoriteManager {
    func bindProfile() {
        profileManager.$profile
            .sink { [weak self] _ in
                guard let self = self else { return }
                
                if CredentialsManager.shared.isGuest {
                    self.colors = self.coreDataManager.getColors()
                    self.palettes = self.coreDataManager.getPalettes()
                }
                else {
                    self.colors = [] // fetch from server
                    self.palettes = [] // fetch from server
                }
                
                self.checkColorsLimit(forceReload: true)
                self.checkPalettesLimit(forceReload: true)
            }
            .store(in: &cancellable)
    }
}

extension FavoriteManager {
    func addColor(_ newColor: AppColor) {
        if CredentialsManager.shared.isGuest {
            coreDataManager.addColor(newColor)
        } else {
            // Server
        }
        
        colors.append(newColor)
        checkColorsLimit()
    }
    
    func addPalette(_ newPalette: ColorPalette) {
        if CredentialsManager.shared.isGuest {
            coreDataManager.addPalette(newPalette)
        } else {
            // Server
        }
        
        palettes.append(newPalette)
        checkPalettesLimit()
    }
    
    func removeColor(_ color: AppColor) {
        if let index = colors.firstIndex(where: { $0 == color })  {
            if CredentialsManager.shared.isGuest {
                coreDataManager.removeColor(color)
            } else {
                // Server
            }
            
            colors.remove(at: index)
            checkColorsLimit()
        }
    }
    
    func removePalette(_ palette: ColorPalette) {
        if let index = palettes.firstIndex(where: { $0 == palette })  {
            if CredentialsManager.shared.isGuest {
                coreDataManager.removePalette(palette)
            } else {
                // Server
            }
            
            palettes.remove(at: index)
            checkPalettesLimit()
        }
    }
}

private extension FavoriteManager {
    func checkColorsLimit(forceReload: Bool = false) {
        let firstCondition = CredentialsManager.shared.isGuest && colors.count == 5
        let secondCondition = (profileManager.profile?.isFree ?? false) && colors.count == 5
        
        let newValue = firstCondition || secondCondition ? true : false
        
        if forceReload {
            isColorsLimit = newValue
        }
        else if isColorsLimit != newValue {
            isColorsLimit = newValue
        }
    }
    
    func checkPalettesLimit(forceReload: Bool = false) {
        let firstCondition = CredentialsManager.shared.isGuest && palettes.count == 5
        let secondCondition = (profileManager.profile?.isFree ?? false) && palettes.count == 5
        
        let newValue = firstCondition || secondCondition ? true : false
        
        if forceReload {
            isPalettesLimit = newValue
        }
        else if isPalettesLimit != newValue {
            isPalettesLimit = newValue
        }
    }
}
