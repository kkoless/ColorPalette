//
//  ColorPaletteView.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 22.12.2022.
//

import SwiftUI

struct ColorPaletteView: View {
    @EnvironmentObject var favoriteManager: FavoriteManager
    @Environment(\.dismiss) private var dismiss: DismissAction
    
    @State var selectedType: ColorType = .HEX
    @State var showInfo: Bool = true
    @State var isFavorite: Bool = false
    
    let palette: ColorPalette
    
    var body: some View {
        VStack(spacing: 0) {
            topBar
            
            VStack(spacing: 0) {
                ForEach(palette.colors) { color in
                    ColorPaletteRowView(appColor: color, type: selectedType, showInfo: showInfo)
                }
            }
            .onTapGesture { showInfo.toggle() }
            .onAppear { checkFavorite(palette: palette) }
            
            ColorTypePickerView(selectedType: $selectedType)
        }
    }
}

private extension ColorPaletteView {
    var topBar: some View {
        ZStack {
            Color(palette.colors[0])
            HStack {
                backButton
                Spacer()
                favoriteButton
            }
            .padding(20)
        }
        .frame(height: 25)
        .padding(.top)
    }
    
    var backButton: some View {
        Button(action: { dismiss() }) {
            Image(systemName: "chevron.left")
                .resizable()
                .frame(width: 10, height: 20)
                .foregroundColor(Color(palette.colors[0].uiColor.invertColor()))
        }
    }
    
    var favoriteButton: some View {
        Button(action: { changeFavoriteState() }, label: {
            Image(systemName: isFavorite ? "heart.fill" : "heart")
                .resizable()
                .frame(width: 23, height: 23)
                .foregroundColor(isFavorite ? .red : Color(palette.colors[0].uiColor.invertColor()))
        })
    }
}

private extension ColorPaletteView {
    func checkFavorite(palette: ColorPalette) {
        self.isFavorite = favoriteManager
            .palettes
            .contains(where: { $0.hashValue == palette.hashValue })
    }
    
    func changeFavoriteState() {
        if isFavorite {
            favoriteManager.removePalette(palette)
            isFavorite.toggle()
        }
        else {
            if !favoriteManager.isColorsLimit {
                favoriteManager.addPalette(palette)
                isFavorite.toggle()
            }
        }
    }
}

struct ColorPaletteView_Previews: PreviewProvider {
    static var previews: some View {
        ColorPaletteView(palette: ColorPalette.getTestPalettes(20)[1])
            .environmentObject(FavoriteManager.shared)
    }
}
