//
//  ColorRowView.swift
//  ColorPalette
//
//  Created by Kolesnikov Kirill on 23.12.2022.
//

import SwiftUI

struct ColorRowView: View {
    let appColor: AppColor
    let type: ColorType
    
    @EnvironmentObject private var viewModel: SampleColorsViewModel
    
    var body: some View {
        HStack() {
            ColorBlockView(appColor: appColor, type: type)
                .onTapGesture { previewTap() }
            
            infoButton
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private extension ColorRowView {
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
        viewModel.input.infoTap.send(appColor)
    }
    
    func previewTap() {
        viewModel.input.colorTap.send(appColor)
    }
}

struct ColorRowView_Previews: PreviewProvider {
    static var previews: some View {
        ColorRowView(appColor: AppColor(name: "African Violet", hex: "#B284BE"),
                     type: .RGB)
    }
}
