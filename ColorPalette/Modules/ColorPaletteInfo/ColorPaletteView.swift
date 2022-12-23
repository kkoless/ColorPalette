//
//  ColorPaletteView.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 22.12.2022.
//

import SwiftUI

protocol Colorable {
    func prepareColors(from palette: ColorPalette) -> [UIColor]
    func getInfo(type: ColorType, color: UIColor) -> String
}

extension Colorable {
    func prepareColors(from palette: ColorPalette) -> [UIColor] {
        return palette.colors.map {
            UIColor(red: $0.r, green: $0.g, blue: $0.b, alpha: $0.alpha)
        }
    }
    
    func getInfo(type: ColorType, color: UIColor) -> String {
        switch type {
            case .HEX: return color.hexValue
            case .RGB: return color.rgbDescription()
            case .HSB: return color.hsbDescription()
            case .CMYK: return color.cmykDescription()
        }
    }
}

struct ColorPaletteView: View {
    let palette: ColorPalette
    @State var selectedType: ColorType = .RGB
    
    var body: some View {
        VStack {
            VStack(spacing: 0) {
                ForEach(prepareColors(from: palette)) { color in
                    ZStack {
                        Color(color)
                        getColorInfo(color: color)
                    }
                }
            }
            
            ColorTypePickerView(selectedType: $selectedType)
        }
    }
}

private extension ColorPaletteView {
    @ViewBuilder
    func getColorInfo(color: UIColor) -> some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(selectedType.rawValue)
                        .font(.title2)
                        .bold()
                    Text(getInfo(type: selectedType, color: color))
                        .font(.title3)
                }
                .padding()
                .foregroundColor(.white)
                
                Spacer()
            }
            .padding(.all)
            
            Spacer()
        }
    }
}

extension ColorPaletteView: Colorable {}

struct ColorPaletteView_Previews: PreviewProvider {
    static var previews: some View {
        ColorPaletteView(palette: ColorPalette.getTestPalettes(size: 1)[0])
    }
}
