//
//  ColorManager.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 23.12.2022.
//

import Foundation

final class ColorManager {
    private(set) var colors: [AppColor]
    static let shared = ColorManager()
    
    private init() {
        colors = [AppColor].parse(jsonFile: "colors") ?? []
        print("\(self) INIT")
    }
    
    deinit {
        print("\(self) DEINIT")
    }
}

