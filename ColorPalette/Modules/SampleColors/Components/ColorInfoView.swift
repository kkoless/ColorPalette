//
//  ColorInfoView.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 24.12.2022.
//

import SwiftUI

struct ColorInfoView: View {
    private let color: UIColor
    private let colorName: String
    
    init(color: AppColor) {
        self.color = UIColor(hexString: color.hex)
        self.colorName = color.name
    }
    
    var body: some View {
        ZStack(alignment: .leading) {
            Color(color)
            infoBlock
        }
    }
}

private extension ColorInfoView {
    var infoBlock: some View {
        VStack(alignment: .leading) {
            Text(colorName)
                .font(.title)
                .bold()
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
            Group {
                hexInfo
                rgbInfo
                hsvInfo
                cmykInfo
            }
            .padding([.leading, .trailing])
            .padding([.top, .bottom], 10)
        }
        .foregroundColor(Color(color.invertColor()))
    }
    
    var hexInfo: some View {
        VStack(alignment: .leading) {
            Text("HEX")
                .font(.title2)
                .bold()
            Text(color.hexValue)
                .font(.title3)
        }
    }
    
    var rgbInfo: some View {
        VStack(alignment: .leading) {
            Text("RGB")
                .font(.title2)
                .bold()
            Text(color.rgbDescription(isExtended: true))
                .font(.title3)
        }
    }
    
    var hsvInfo: some View {
        VStack(alignment: .leading) {
            Text("HSV")
                .font(.title2)
                .bold()
            Text(color.hsvDescription(isExtended: true))
                .font(.title3)
        }
    }
    
    var cmykInfo: some View {
        VStack(alignment: .leading) {
            Text("CMYK")
                .font(.title2)
                .bold()
            Text(color.cmykDescription(isExtended: true))
                .font(.title3)
        }
    }
}

struct ColorInfoView_Previews: PreviewProvider {
    static var previews: some View {
        let appColor = AppColor(name: "African Violet", hex: "#B284BE")
        ColorInfoView(color: appColor)
    }
}
