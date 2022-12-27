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
    @State private var showInfo = true
    
    init(color: AppColor) {
        self.color = UIColor(hexString: color.hex)
        self.colorName = color.name.isEmpty ? " " : color.name
    }
    
    init(color: UIColor, colorName: Binding<String>) {
        self.color = color
        self.colorName = colorName.wrappedValue.isEmpty ? color.accessibilityName : colorName.wrappedValue
    }
    
    var body: some View {
        VStack {
            navBar
            
            ZStack(alignment: .top) {
                Color(color)
                if showInfo {
                    infoBlock
                }
            }
            .onTapGesture { showInfo.toggle() }
        }
        .edgesIgnoringSafeArea(.top)
    }
}

private extension ColorInfoView {
    var navBar: some View {
        CustomNavigationBarView()
            .padding(.top, Consts.Constraints.top)
    }
    
    var infoBlock: some View {
        VStack(alignment: .leading) {
            Text(colorName)
                .font(.title2)
                .bold()
                .padding([.leading, .trailing])
                .padding(.top, 30)
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

struct ColorInfoView_Previews: PreviewProvider {
    static var previews: some View {
        let appColor = AppColor(name: "African Violet", hex: "#B284BE")
        ColorInfoView(color: appColor)
    }
}
