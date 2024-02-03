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

  @State private var isEdit: Bool = false

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
    .foregroundColor(.primary)
    .onAppear(perform: onAppear)
  }
}

private extension FavoritesView {
  private var header: some View {
    HStack(alignment: .center) {
      Text(.favorites)
        .font(.largeTitle)
        .bold()
      Spacer()
    }
    .padding([.leading, .trailing])
  }

  private var addButtons: some View {
    HStack {
      paletteMenu
      Spacer()
      colorMenu
    }
    .padding()
  }

  private var paletteMenu: some View {
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
    .foregroundColor(viewModel.output.palettesLimit ? .gray : .primary)
  }

  private var colorMenu: some View {
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
    .foregroundColor(viewModel.output.colorsLimit ? .gray : .primary)
  }

  private var favoriteList: some View {
    List {
      palettesBlock
      colorsBlock
    }
    .listStyle(.plain)
    .listSectionSeparator(.hidden)
  }

  private func getHeaderText(text: Strings) -> some View {
    Text(text)
      .font(.title3.bold())
  }
}

private extension FavoritesView {
  @ViewBuilder
  private var palettesBlock: some View {
    if !viewModel.output.palettes.isEmpty {
      HStack {
        getHeaderText(text: .palettes)

        Spacer()

        Button(action: { editStateTap() }) {
          Text(!isEdit ? .edit : .cancel)
        }
        .buttonStyle(.plain)
        .foregroundColor(isEdit ? Color.red : Color.primary)
      }

      paletteCells
    }
  }

  @ViewBuilder
  private var colorsBlock: some View {
    if !viewModel.output.colors.isEmpty {
      HStack {
        getHeaderText(text: .colors)
        Spacer()
      }
      .padding(.top, 20)

      colorCells
    }
  }

  @ViewBuilder
  private var paletteCells: some View {
    ForEach(viewModel.output.palettes) { palette in
      HStack(alignment: .center) {
        ColorPaletteCell(palette: palette)
          .padding(.trailing, 5)
          .onTapGesture { showPaletteInfoTap(palette) }

        if isEdit {
          Button(action: { editPalette(palette) }) {
            Image(systemName: "slider.horizontal.3")
              .resizable()
              .frame(width: 18, height: 18)
          }
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

  private var colorCells: some View {
    ForEach(viewModel.output.colors) { color in
      Color(color)
        .opacity(color.alpha)
        .frame(height: 35)
        .cornerRadius(10)
        .listRowSeparator(.hidden)
        .listRowInsets(.init())
        .padding([.top, .bottom], 10)
        .padding([.leading, .trailing])
        .onTapGesture { showColorInfoTap(color) }
    }
    .onDelete { indexSet in
      indexSet.forEach { viewModel.removeColor(from: $0) }
    }
  }

  private var emptyState: some View {
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
  private func onAppear() {
    viewModel.input.onAppear.send(())
  }

  private func editStateTap() {
    withAnimation {
      isEdit.toggle()
    }
  }

  private func addPaletteTap(_ type: FavoriteAddType) {
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

  private func addColorTap(_ type: FavoriteAddType) {
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

  private func showColorInfoTap(_ appColor: AppColor) {
    viewModel.input.showTaps.showColorInfoTap.send(appColor)
  }

  private func showPaletteInfoTap(_ palette: ColorPalette) {
    viewModel.input.showTaps.showPaletteInfoTap.send(palette)
  }

  private func editPalette(_ palette: ColorPalette) {
    viewModel.input.editPaletteTap.send(palette)
  }
}

struct FavoritesView_Previews: PreviewProvider {
  static var previews: some View {
    FavoritesView(viewModel: FavoriteViewModel())
      .environmentObject(LocalizationService.shared)
  }
}
