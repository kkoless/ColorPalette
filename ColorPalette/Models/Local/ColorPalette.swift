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
    
    static func getTestPalettes(_ size: UInt) -> [ColorPalette] {
        var result = [ColorPalette]()
        
        for _ in 0...size {
            result.append(ColorPalette(colors: [
                AppColor.getRandomColor(),
                AppColor.getRandomColor(),
                AppColor.getRandomColor(),
                AppColor.getRandomColor()]
                                      ))
        }
        
        return result
    }
}
