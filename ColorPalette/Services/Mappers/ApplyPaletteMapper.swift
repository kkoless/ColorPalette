//
//  ApplyPaletteMapper.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 19.05.2023.
//

import Foundation

final class ApplyPaletteMapper {
    static func toLocal(from: ApplyPaletteResponse) -> ([AppColor], Data) {
        let data = from.imgData ?? Data()
        var colors: [AppColor] = []
        
        from.fromColors?.forEach({
            colors.append(AppColor(r: $0[0], g: $0[1], b: $0[2]))
        })
        
        return (colors, data)
    }
}
