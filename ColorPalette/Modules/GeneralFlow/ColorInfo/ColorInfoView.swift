//
//  ColorInfoView.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 27.12.2022.
//

import SwiftUI

struct ColorInfoView: View {
    let appColor: AppColor
    @State var isFavorite: Bool = false
    
    @EnvironmentObject var favoriteManager: FavoriteManager
    
    var body: some View {
        VStack {
            navBar
            ColorPreview(color: appColor)
        }
        .onAppear { onAppear() }
    }
}

private extension ColorInfoView {
    var navBar: some View {
        let buttons: [Button<AnyView>] = [
            Button(action: { changeFavoriteState() }, label: {
                Image(systemName: isFavorite ? "heart.fill" : "heart")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(isFavorite ? .red : .black)
                    .eraseToAnyView()
            })
        ]
        return CustomNavigationBarView(trailingItems: buttons)
    }
}

private extension ColorInfoView {
    func onAppear() {
        self.isFavorite = favoriteManager
            .colors
            .contains(where: { $0 == appColor })
    }
    
    func changeFavoriteState() {
        if isFavorite {
            favoriteManager.removeColor(appColor)
        } else {
            favoriteManager.addColor(appColor)
        }
        
        isFavorite.toggle()
    }
}

struct ColorInfoView_Previews: PreviewProvider {
    static var previews: some View {
        ColorInfoView(appColor: AppColor.getRandomColor())
            .environmentObject(FavoriteManager.shared)
    }
}
