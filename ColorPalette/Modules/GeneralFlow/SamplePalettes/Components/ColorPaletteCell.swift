//
//  ColorPaletteCell.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 21.12.2022.
//

import SwiftUI

struct ColorPaletteCell: View {
    let palette: ColorPalette
    
    var body: some View {
        HStack(spacing: .zero) {
            ForEach(palette.colors) { color in
                Color(color)
            }
        }
        .frame(height: 35)
        .cornerRadius(7)
        .padding([.top, .bottom], 10)
    }
}

struct ColorPaletteCell_Previews: PreviewProvider {
    static var previews: some View {
        ColorPaletteCell(palette: ColorPalette.getTestPalettes(20)[0])
    }
}
