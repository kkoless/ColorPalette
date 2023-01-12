//
//  ColorPreview.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 24.12.2022.
//

import SwiftUI

struct ColorPreview: View {
    private let color: UIColor
    private let colorName: String
    
    init(color: AppColor) {
        self.color = color.uiColor
        self.colorName = color.name.isEmpty ? self.color.accessibilityName : color.name
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Color(color)
            infoBlock
        }
    }
}

private extension ColorPreview {
    var infoBlock: some View {
        VStack(alignment: .leading) {
            Text(colorName)
                .font(.title2)
                .bold()
                .padding(.top, 30)
                .frame(maxWidth: Consts.Constraints.screenWidth / 2, alignment: .leading)
            
            Group {
                hexInfo
                rgbInfo
                hsvInfo
                cmykInfo
            }
            .padding([.top, .bottom], 10)
        }
        .padding([.leading, .trailing])
        .foregroundColor(Color(color.invertColor()))
    }
    
    var hexInfo: some View {
        VStack(alignment: .leading) {
            Text("HEX")
                .font(.headline)
                .bold()
            Text(color.hexValue)
                .font(.subheadline)
        }
    }
    
    var rgbInfo: some View {
        VStack(alignment: .leading) {
            Text("RGB")
                .font(.headline)
                .bold()
            Text(color.rgbDescription(isExtended: true))
                .font(.subheadline)
        }
    }
    
    var hsvInfo: some View {
        VStack(alignment: .leading) {
            Text("HSV")
                .font(.headline)
                .bold()
            Text(color.hsvDescription(isExtended: true))
                .font(.subheadline)
        }
    }
    
    var cmykInfo: some View {
        VStack(alignment: .leading) {
            Text("CMYK")
                .font(.headline)
                .bold()
            Text(color.cmykDescription(isExtended: true))
                .font(.subheadline)
        }
    }
}

struct ColorPreview_Previews: PreviewProvider {
    static var previews: some View {
        let appColor = AppColor(name: "African Violet", hex: "#B284BE")
        ColorPreview(color: appColor)
    }
}
