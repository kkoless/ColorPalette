//
//  ColorManager.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 23.12.2022.
//

import Foundation

final class ColorManager {
    let colors: [AppColor]
    static let shared = ColorManager()
    
    private init() {
        colors = ([AppColor].parse(jsonFile: "colors") ?? []).removingDuplicates(byKey: { $0.hex })
        print("\(self) INIT")
    }
    
    deinit {
        print("\(self) DEINIT")
    }
}

