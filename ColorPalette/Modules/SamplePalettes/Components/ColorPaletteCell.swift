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
            ForEach(prepareColors(from: palette)) { color in
                Color(color)
            }
        }
        .frame(height: 35)
        .cornerRadius(7)
        .padding([.top, .bottom], 10)
    }
}

extension ColorPaletteCell: Colorable {}

struct ColorPaletteCell_Previews: PreviewProvider {
    static var previews: some View {
        ColorPaletteCell(palette: ColorPalette.getTestPalettes(size: 5)[0])
    }
}
