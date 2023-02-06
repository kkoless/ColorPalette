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
            Button(action: { addPaletteTap(.customPalette) }) {
                Text("Create palette")
            }
            Button(action: { addPaletteTap(.libraryPalette) }) {
                Text("Choose from library")
            }
            Button(action: { addPaletteTap(.paletteFromImage) }) {
                Text("Generate from image")
            }
        } label: {
            Text("Add palette")
        }
        .disabled(viewModel.output.palettesLimit)
    }
    
    var colorMenu: some View {
        Menu {
            Button(action: { addColorTap(.customColor) }) {
                Text("Create color")
            }
            Button(action: { addColorTap(.libraryColor) }) {
                Text("Choose from library")
            }
            Button(action: { addColorTap(.colorFromCamera) }) {
                Text("Choose from Camera")
            }
        } label: {
            Text("Add color")
        }
        .disabled(viewModel.output.colorsLimit)
    }
    
    var favoriteList: some View {
        List {
            palettesBlock
            colorsBlock
        }
        .listStyle(.plain)
    }
    
    func getHeaderText(text: String) -> some View {
        Text(text)
            .font(.title3)
            .bold()
    }
}

private extension FavoritesView {
    @ViewBuilder
    var palettesBlock: some View {
        if !viewModel.output.palettes.isEmpty {
            HStack {
                getHeaderText(text: "Palettes")
                Spacer()
            }
            
            paletteCells
        }
    }
    
    @ViewBuilder
    var colorsBlock: some View {
        if !viewModel.output.colors.isEmpty {
            HStack {
                getHeaderText(text: "Colors")
                Spacer()
            }
            .padding(.top, 20)
            
            colorCells
        }
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
    func addPaletteTap(_ type: FavoriteAddType) {
        switch type {
            case .customPalette:
                viewModel.input.addTaps.createPaletteTap.send()
            case .libraryPalette:
                viewModel.input.addTaps.choosePaletteTap.send()
            case .paletteFromImage:
                viewModel.input.addTaps.generatePaletteFromImageTap.send()
            default:
                return
        }
    }
    
    func addColorTap(_ type: FavoriteAddType) {
        switch type {
            case .customColor:
                viewModel.input.addTaps.createColorTap.send()
            case .libraryColor:
                viewModel.input.addTaps.chooseColorTap.send()
            case .colorFromCamera:
                viewModel.input.addTaps.generateColorFromCameraTap.send()
            default:
                return
        }
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
