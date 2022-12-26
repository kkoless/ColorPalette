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
            
            if !paletteStorage.palettes.isEmpty {
                List {
                    Section("Palettes") {
                        paletteCells
                        addPaletteButton
                            .frame(maxWidth: .infinity, alignment: .center)
                            .foregroundColor(.blue)
                    }
                }
                .listStyle(.plain)
            } else {
                emptyState
            }
        }
    }
}

private extension FavoritesView {
    var header: some View {
        HStack {
            Text("Favorites")
                .font(.largeTitle)
            .bold()
            
            Spacer()
        }
        .padding([.leading, .trailing])
    }
    
    var addPaletteButton: some View {
        Button(action: { navigateToCreatePalette() }) {
            if paletteStorage.palettes.isEmpty {
                Text("Add palette")
            } else {
                Image(systemName: "plus.circle")
            }
        }
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
    
    var emptyState: some View {
        VStack(spacing: 15) {
            Spacer()
            Text("So empty here...")
                .font(.headline)
                .bold()
                .frame(alignment: .center)
            
            addPaletteButton
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding([.leading, .trailing])
    }
}

private extension FavoritesView {
    func navigateToColorPaletteScreen(_ palette: ColorPalette) {
        router?.navigateToColorPalette(palette: palette)
    }
    
    func navigateToCreatePalette() {
        router?.navigateToCreatePalette()
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
            .environmentObject(PaletteStorageManager.shared)
    }
}
