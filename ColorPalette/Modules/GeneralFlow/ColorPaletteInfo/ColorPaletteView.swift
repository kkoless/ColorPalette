//
//  ColorPaletteView.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 22.12.2022.
//

import SwiftUI

struct ColorPaletteView: View {
    @State var selectedType: ColorType = .CMYK
    @State var showInfo: Bool = true
    let palette: ColorPalette
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                ForEach(palette.colors) { color in
                    ColorPaletteRowView(appColor: color, type: selectedType, showInfo: showInfo)
                }
            }
            .onTapGesture { showInfo.toggle() }
            
            ColorTypePickerView(selectedType: $selectedType)
        }
    }
}

struct ColorPaletteView_Previews: PreviewProvider {
    static var previews: some View {
        ColorPaletteView(palette: ColorPalette.getTestPalettes(20)[0])
    }
}
