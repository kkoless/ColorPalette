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
    private let showInfoButton: Bool
    
    @EnvironmentObject private var viewModel: SampleColorsViewModel
    
    init(appColor: AppColor, type: ColorType, showInfoButton: Bool = true) {
        self.uiColor = UIColor(hexString: appColor.hex)
        self.colorName = appColor.name
        self.type = type
        self.showInfoButton = showInfoButton
    }
    
    var body: some View {
        HStack() {
            colorPreview
            
            colorInfo
            
            Spacer()
            
            if showInfoButton {
                infoButton
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private extension ColorRowView {
    var colorPreview: some View {
        Color(uiColor)
            .frame(width: 80, height: 80)
            .cornerRadius(10)
    }
    
    var colorInfo: some View {
        VStack(alignment: .leading) {
            Text(colorName)
                .font(.headline)
                .bold()
            
            Text(uiColor.getTypeInfo(type: type, isExtended: false))
                .font(.subheadline)
        }
    }
    
    var infoButton: some View {
        Button(action: { infoTap() }) {
            Image(systemName: "info.circle")
                .resizable()
                .frame(width: 20, height: 20)
        }
        .foregroundColor(.gray)
    }
}

private extension ColorRowView {
    func infoTap() {
        viewModel.input.infoTap.send(AppColor(uiColor: uiColor))
    }
}

struct ColorRowView_Previews: PreviewProvider {
    static var previews: some View {
        ColorRowView(appColor: AppColor(name: "African Violet", hex: "#B284BE"),
                     type: .RGB)
    }
}
