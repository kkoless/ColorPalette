//
//  FavoritesView.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 25.12.2022.
//

import SwiftUI

struct FavoritesView: View {
    @ObservedObject var viewModel: FavoriteViewModel
    
    var body: some View {
        VStack {
            header
            
            if !viewModel.output.palettes.isEmpty {
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
        Button(action: { viewModel.input.addPaletteTap.send() }) {
            if viewModel.output.palettes.isEmpty {
                Text("Add palette")
            } else {
                Image(systemName: "plus.circle")
            }
        }
    }
    
    var paletteCells: some View {
        ForEach(viewModel.output.palettes) { palette in
            ColorPaletteCell(palette: palette)
                .padding([.leading, .trailing])
                .listRowSeparator(.hidden)
                .listRowInsets(.init())
        }
        .onDelete { indexSet in
            indexSet.forEach { viewModel.removePalette(from: $0) }
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

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView(viewModel: FavoriteViewModel())
    }
}
