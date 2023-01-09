//
//  ColorPaletteRowView.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 25.12.2022.
//

import SwiftUI

struct ColorPaletteRowView: View {
    let appColor: AppColor
    let type: ColorType
    let showInfo: Bool
    
    var body: some View {
        ZStack {
            Color(appColor)
            if showInfo {
                getColorInfo(color: appColor.uiColor)
            }
        }
    }
}

private extension ColorPaletteRowView {
    @ViewBuilder
    private func getColorInfo(color: UIColor) -> some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(type.rawValue)
                        .font(.title2)
                        .bold()
                    Text(color.getTypeInfo(type: type, isExtended: true))
                        .font(.title3)
                }
                .foregroundColor(Color(color.invertColor()))
                .minimumScaleFactor(0.1)
                
                Spacer()
            }
            .padding(.all)
            
            Spacer()
        }
    }
}

struct ColorPaletteRowView_Previews: PreviewProvider {
    static var previews: some View {
        ColorPaletteRowView(appColor: AppColor.getRandomColor(), type: .RGB, showInfo: true)
    }
}
