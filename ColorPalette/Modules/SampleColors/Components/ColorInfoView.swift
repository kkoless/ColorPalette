//
//  ColorInfoView.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 23.12.2022.
//

import SwiftUI

struct ColorInfoView: View {
    private let colorName: String
    private let color: UIColor
    private let type: ColorType
    
    init(appColor: AppColor, type: ColorType) {
        self.colorName = appColor.name
        self.color = UIColor(hexString: appColor.hex)
        self.type = type
    }
    
    var body: some View {
        HStack() {
            Color(color)
                .frame(width: 80, height: 80)
                .cornerRadius(10)
            
            VStack(alignment: .leading) {
                Text(colorName)
                    .font(.headline)
                    .bold()
                
                Text(color.getTypeInfo(type: type, isExtended: false))
                    .font(.subheadline)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct ColorInfoView_Previews: PreviewProvider {
    static var previews: some View {
        ColorInfoView(appColor: AppColor(name: "African Violet", hex: "#B284BE"), type: .RGB)
    }
}
