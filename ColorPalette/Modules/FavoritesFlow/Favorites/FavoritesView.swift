//
//  FavoritesView.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 25.12.2022.
//

import SwiftUI

struct FavoritesView: View {
    @StateObject var viewModel: FavoriteViewModel
    @EnvironmentObject private var localizationService: LocalizationService
    
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
        .onAppear(perform: onAppear)
    }
}

private extension FavoritesView {
    var header: some View {
        HStack(alignment: .center) {
            Text(.favorites)
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
                Text(.createPalette)
            }
            Button(action: { addPaletteTap(.libraryPalette) }) {
                Text(.chooseFromLibrary)
            }
            Button(action: { addPaletteTap(.paletteFromImage) }) {
                Text(.generateFromImage)
            }
        } label: {
            Text(.addPalette)
        }
        .disabled(viewModel.output.palettesLimit)
    }
    
    var colorMenu: some View {
        Menu {
            Button(action: { addColorTap(.customColor) }) {
                Text(.createColor)
            }
            Button(action: { addColorTap(.libraryColor) }) {
                Text(.chooseFromLibrary)
            }
            Button(action: { addColorTap(.colorFromCamera) }) {
                Text(.generateFromCamera)
            }
        } label: {
            Text(.addColor)
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
    
    func getHeaderText(text: Strings) -> some View {
        Text(text)
            .font(.title3.bold())
    }
}

private extension FavoritesView {
    @ViewBuilder
    var palettesBlock: some View {
        if !viewModel.output.palettes.isEmpty {
            HStack {
                getHeaderText(text: .palettes)
                Spacer()
            }
            
            paletteCells
        }
    }
    
    @ViewBuilder
    var colorsBlock: some View {
        if !viewModel.output.colors.isEmpty {
            HStack {
                getHeaderText(text: .colors)
                Spacer()
            }
            .padding(.top, 20)
            
            colorCells
        }
    }
    
    var paletteCells: some View {
        ForEach(viewModel.output.palettes) { palette in
            HStack(alignment: .center) {
                ColorPaletteCell(palette: palette)
                    .padding(.trailing, 5)
                    .onTapGesture { showPaletteInfoTap(palette) }
                
                Button(action: { editPalette(palette) }) {
                    Image(systemName: "slider.horizontal.3")
                        .resizable()
                        .frame(width: 18, height: 18)
                        .foregroundColor(.primary)
                }
            }
            .padding([.leading, .trailing])
            .listRowSeparator(.hidden)
            .listRowInsets(.init())
        }
        .onDelete { indexSet in
            indexSet.forEach { viewModel.removePalette(from: $0) }
        }
        .buttonStyle(.plain)
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
            Text(.favoritesEmptyState)
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
    func onAppear() {
        viewModel.input.onAppear.send(())
    }
    
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
    
    func editPalette(_ palette: ColorPalette) {
        viewModel.input.editPaletteTap.send(palette)
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView(viewModel: FavoriteViewModel())
            .environmentObject(LocalizationService.shared)
    }
}
