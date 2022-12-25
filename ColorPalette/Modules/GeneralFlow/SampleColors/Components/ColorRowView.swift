//
//  ColorRowView.swift
//  ColorPalette
//
//  Created by Kolesnikov Kirill on 23.12.2022.
//

import SwiftUI

struct ColorRowView: View {
    private let uiColor: UIColor
    private let colorName: String
    private let type: ColorType
    
    init(appColor: AppColor, type: ColorType) {
        self.uiColor = UIColor(hexString: appColor.hex)
        self.colorName = appColor.name
        self.type = type
    }
    
    var body: some View {
        HStack() {
            Color(uiColor)
                .frame(width: 80, height: 80)
                .cornerRadius(10)
            
            VStack(alignment: .leading) {
                Text(colorName)
                    .font(.headline)
                    .bold()
                
                Text(uiColor.getTypeInfo(type: type, isExtended: false))
                    .font(.subheadline)
            }
            
            Spacer()
            
            Button(action: {}) {
                Image(systemName: "info.circle")
                    .resizable()
                    .frame(width: 20, height: 20)
            }
            .foregroundColor(.gray)
            
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct ColorRowView_Previews: PreviewProvider {
    static var previews: some View {
        ColorRowView(appColor: AppColor(name: "African Violet", hex: "#B284BE"),
                     type: .RGB)
    }
}
