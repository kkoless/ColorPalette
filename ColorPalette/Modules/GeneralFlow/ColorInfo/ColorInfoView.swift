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
        Button(action: { copyColorInfo() }, label: {
            Image(systemName: "clipboard")
                .resizable()
                .frame(width: 20, height: 25)
                .foregroundColor(invertedColor)
        })
    }
}

private extension ColorInfoView {
    func checkFavorite(color: AppColor) {
        self.isFavorite = favoriteManager
            .colors
            .contains(where: { $0 == color })
    }
    
    func changeFavoriteState() {
        if isFavorite {
            favoriteManager.removeColor(appColor)
        } else {
            favoriteManager.addColor(appColor)
        }
        
        isFavorite.toggle()
    }
    
    func copyColorInfo() {
        UIPasteboard.general.string = appColor.hex
    }
}

struct ColorInfoView_Previews: PreviewProvider {
    static var previews: some View {
        ColorInfoView(appColor: AppColor.getRandomColor())
            .environmentObject(FavoriteManager.shared)
    }
}
