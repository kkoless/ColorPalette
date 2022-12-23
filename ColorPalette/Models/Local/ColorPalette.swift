//
//  ColorPalette.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 22.12.2022.
//

import Foundation

struct ColorPalette: Identifiable {
    let id: UUID = .init()
    let colors: [AppColor]
    
    static func getTestPalettes() -> [ColorPalette] {
        var result = [ColorPalette]()
        
        for _ in 0...20 {
            result.append(ColorPalette(colors: AppColor.getTestColors().shuffled()))
        }
        
        return result
    }
}
