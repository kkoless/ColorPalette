//
//  FavoritesView.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 25.12.2022.
//

import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject private var paletteStorage: PaletteStorageManager
    
    weak private var router: FavoritesRoutable?
    
    init(router: FavoritesRoutable? = nil) {
        self.router = router
    }
    
    var body: some View {
        VStack {
            header
            
            List {
                Section("Palettes") {
                    paletteCells
                }
            }
            .listStyle(.plain)
        }
    }
}

private extension FavoritesView {
    var header: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Favorites")
                    .font(.largeTitle)
                .bold()
                
                Spacer()
            }
            
            HStack {
                Button(action: { navigateToCreatePalette() }) {
                    Text("Add palette")
                }
                
                Spacer()
                
                Button(action: { navigateToCreateColor() }) {
                    Text("Add color")
                }
            }
        }
        .padding()
    }
    
    var paletteCells: some View {
        ForEach(paletteStorage.palettes) { palette in
            ColorPaletteCell(palette: palette)
                .padding([.leading, .trailing])
                .listRowSeparator(.hidden)
                .listRowInsets(.init())
                .onTapGesture {
                    navigateToColorPaletteScreen(palette)
                }
        }
        .onDelete { indexSet in
            indexSet.forEach { paletteStorage.removePalette(from: $0) }
        }
    }
}

private extension FavoritesView {
    func navigateToColorPaletteScreen(_ palette: ColorPalette) {
        router?.navigateToColorPalette(palette: palette)
    }
    
    func navigateToCreatePalette() {
        router?.navigateToCreatePalette()
    }
    
    func navigateToCreateColor() {
        router?.navigateToAddNewColor()
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
            .environmentObject(PaletteStorageManager.shared)
    }
}
