//
//  TemplatePaletteManager.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 25.12.2022.
//

import Foundation

final class TemplatePaletteManager: ObservableObject {
    @Published private(set) var colors: [AppColor] = .init()
    @Published private(set) var isLimit: Bool = false
    
    init() {
        print("\(self) INIT")
    }
    
    deinit {
        print("\(self) DEINIT")
    }
}

extension TemplatePaletteManager {
    func addColor(_ newColor: AppColor) {
        colors.append(newColor)
        checkLimit()
    }
    
    func deleteColor(_ colorForDelete: AppColor) {
        if let index = colors.firstIndex(where: { $0 == colorForDelete }) {
            colors.remove(at: index)
            checkLimit()
        }
    }
    
    func createPalette() -> ColorPalette {
        ColorPalette(colors: colors)
    }
    
    func replaceColors(fromOffsets: IndexSet, toOffset: Int) {
        colors.move(fromOffsets: fromOffsets, toOffset: toOffset)
    }
}

private extension TemplatePaletteManager {
    func checkLimit() {
        let firstCondition = CredentialsManager.shared.isGuest && colors.count == 3
        
        guard let profileRole = ProfileManager.shared.profile?.role.boolValue, profileRole == false else {
            if isLimit != firstCondition { isLimit = firstCondition }
            return
        }
        
        let secondCondition = profileRole && colors.count == 3
        let thirdCondition = !profileRole && colors.count == 5
        
        let newValue = firstCondition || secondCondition || thirdCondition ? true : false
        
        if isLimit != newValue {
            isLimit = newValue
        }
    }
}
