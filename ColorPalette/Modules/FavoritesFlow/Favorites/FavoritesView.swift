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
        VStack(spacing: 10) {
            header
            
            addButtons
            
            if viewModel.output.palettes.isEmpty && viewModel.output.colors.isEmpty {
                emptyState
            }
            else {
                favoriteList
            }
        }
    }
}

private extension FavoritesView {
    var header: some View {
        HStack(alignment: .center) {
            Text("Favorites")
                .font(.largeTitle)
            .bold()
            Spacer()
        }
        .padding([.leading, .trailing])
    }
    
    var addButtons: some View {
        HStack {
            paletteMenu
            Spacer()
            colorMenu
        }
        .padding()
    }
    
    var paletteMenu: some View {
        Menu {
            Button(action: { createPaletteTap() }) {
                Text("Create palette")
            }
            Button(action: { choosePaletteTap() }) {
                Text("Choose from library")
            }
            Button(action: { generatePaletteFromImageTap() }) {
                Text("Generate from image")
            }
        } label: {
            Text("Add palette")
        }
    }
    
    var colorMenu: some View {
        Menu {
            Button(action: { createColorTap() }) {
                Text("Create color")
            }
            Button(action: { chooseColorTap() }) {
                Text("Choose from library")
            }
        } label: {
            Text("Add color")
        }
    }
    
    var favoriteList: some View {
        List {
            if !viewModel.output.palettes.isEmpty {
                Section("Palettes") {
                    paletteCells
                }
            }
            
            if !viewModel.output.colors.isEmpty {
                Section("Colors") {
                    colorCells
                }
            }
        }
        .listStyle(.plain)
    }
    
    var paletteCells: some View {
        ForEach(viewModel.output.palettes) { palette in
            ColorPaletteCell(palette: palette)
                .padding([.leading, .trailing])
                .listRowSeparator(.hidden)
                .listRowInsets(.init())
                .onTapGesture { showPaletteInfoTap(palette) }
        }
        .onDelete { indexSet in
            indexSet.forEach { viewModel.removePalette(from: $0) }
        }
    }
    
    var colorCells: some View {
        ForEach(viewModel.output.colors) { color in
            Color(color)
                .listRowSeparator(.hidden)
                .cornerRadius(10)
                .onTapGesture { showColorInfoTap(color) }
        }
        .onDelete { indexSet in
            indexSet.forEach { viewModel.removeColor(from: $0) }
        }
    }
    
    var emptyState: some View {
        VStack(spacing: 15) {
            Spacer()
            Text("So empty here...")
                .font(.headline)
                .bold()
                .frame(alignment: .center)
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding([.leading, .trailing])
    }
}

private extension FavoritesView {
    func createColorTap() {
        viewModel.input.addTaps.createColorTap.send()
    }
    
    func chooseColorTap() {
        viewModel.input.addTaps.chooseColorTap.send()
    }
    
    func createPaletteTap() {
        viewModel.input.addTaps.createPaletteTap.send()
    }
    
    func choosePaletteTap() {
        viewModel.input.addTaps.choosePaletteTap.send()
    }
    
    func generatePaletteFromImageTap() {
        viewModel.input.addTaps.generatePaletteFromImageTap.send()
    }
    
    func showColorInfoTap(_ appColor: AppColor) {
        viewModel.input.showTaps.showColorInfoTap.send(appColor)
    }
    
    func showPaletteInfoTap(_ palette: ColorPalette) {
        viewModel.input.showTaps.showPaletteInfoTap.send(palette)
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView(viewModel: FavoriteViewModel())
    }
}
