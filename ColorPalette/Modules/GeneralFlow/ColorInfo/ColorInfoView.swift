//
//  ColorInfoView.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 27.12.2022.
//

import SwiftUI

struct ColorInfoView: View {
    @EnvironmentObject var favoriteManager: FavoriteManager
    @State var isFavorite: Bool = false
    
    let appColor: AppColor
    var invertedColor: Color {
        return Color(UIColor(appColor).invertColor())
    }
    
    var body: some View {
        ZStack {
            ColorPreview(color: appColor)
            helpButtonsBlock
        }
        .edgesIgnoringSafeArea(.bottom)
        .onAppear { checkFavorite(color: appColor) }
        .onChange(of: appColor) { newValue in checkFavorite(color: newValue) }
    }
}

private extension ColorInfoView {
    var helpButtonsBlock: some View {
        GeometryReader { reader in
            HStack(spacing: 25) {
                copyButton
                favoriteButton
            }
            .padding()
            .frame(maxWidth: reader.size.width, alignment: .trailing)
        }
        .padding(.top, 15)
        .padding(.leading, Consts.Constraints.screenWidth / 2)
    }
    
    var favoriteButton: some View {
        Button(action: { changeFavoriteState() }, label: {
            Image(systemName: isFavorite ? "heart.fill" : "heart")
                .resizable()
                .frame(width: 25, height: 25)
                .foregroundColor(isFavorite ? .red : invertedColor)
        })
    }
    
    var copyButton: some View {
        Menu {
            Button(action: { copyColorInfo(.HEX) }, label: { Text("HEX") })
            Button(action: { copyColorInfo(.RGB) }, label: { Text("RGB") })
            Button(action: { copyColorInfo(.HSB) }, label: { Text("HSB") })
            Button(action: { copyColorInfo(.CMYK) }, label: { Text("CMYK") })
        } label: {
            Image(systemName: "clipboard")
                .resizable()
                .frame(width: 20, height: 25)
                .foregroundColor(invertedColor)
        }
    }
}

private extension ColorInfoView {
    func checkFavorite(color: AppColor) {
        self.isFavorite = favoriteManager
            .colors
            .contains(where: {
                $0.hex == color.hex &&
                $0.name == color.name
            })
    }
    
    func changeFavoriteState() {
        if isFavorite {
            favoriteManager.removeColor(appColor)
            isFavorite.toggle()
        }
        else {
            if !favoriteManager.isColorsLimit {
                favoriteManager.addColor(appColor)
                isFavorite.toggle()
            }
        }
    }
    
    func copyColorInfo(_ type: ColorType) {
        switch type {
            case .HEX:
                UIPasteboard.general.string = appColor.uiColor.hexValue
            case .RGB:
                UIPasteboard.general.string = appColor.uiColor.getRGBCopyInfo()
            case .HSB:
                UIPasteboard.general.string = appColor.uiColor.getHSBCopyInfo()
            case .CMYK:
                UIPasteboard.general.string = appColor.uiColor.getCMYKCopyInfo()
        }
    }
}

struct ColorInfoView_Previews: PreviewProvider {
    static var previews: some View {
        ColorInfoView(appColor: AppColor.getRandomColor())
            .environmentObject(FavoriteManager.shared)
    }
}
