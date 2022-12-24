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
                    getColorBlock(appColor: color)
                }
            }
            .onTapGesture { showInfo.toggle() }
            
            ColorTypePickerView(selectedType: $selectedType)
        }
    }
}

private extension ColorPaletteView {
    @ViewBuilder
    func getColorBlock(appColor: AppColor) -> some View {
        let color = UIColor(hexString: appColor.hex)
        
        ZStack {
            Color(color)
            if showInfo {
                getColorInfo(color: color)
            }
        }
    }
    
    @ViewBuilder
    private func getColorInfo(color: UIColor) -> some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(selectedType.rawValue)
                        .font(.title2)
                        .bold()
                    Text(color.getTypeInfo(type: selectedType, isExtended: true))
                        .font(.title3)
                }
                .foregroundColor(Color(color.invertColor()))
                
                Spacer()
            }
            .padding(.all)
            
            Spacer()
        }
    }
}

struct ColorPaletteView_Previews: PreviewProvider {
    static var previews: some View {
        ColorPaletteView(palette: ColorPalette.getTestPalettes()[0])
    }
}
