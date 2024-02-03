//
//  SamplePalettesView.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 21.12.2022.
//

import SwiftUI

struct SamplePalettesView: View {
  @ObservedObject var viewModel: SamplePalettesViewModel
  @EnvironmentObject private var localizationService: LocalizationService
  
  var body: some View {
    VStack {
      navBar
      
      header
      
      List {
        cells
      }
      .listStyle(.plain)
    }
    .edgesIgnoringSafeArea(.top)
    .onAppear { onAppear() }
  }
}

private extension SamplePalettesView {
  var navBar: some View {
    CustomNavigationBarView(backAction: { viewModel.input.backTap.send() })
  }
  
  var header: some View {
    HStack {
      Text(.palettes)
        .font(.largeTitle)
        .bold()
      
      Spacer()
    }
    .padding([.leading, .trailing])
  }
  
  var cells: some View {
    ForEach(viewModel.output.palettes) { palette in
      ColorPaletteCell(palette: palette)
        .padding([.leading, .trailing])
        .listRowSeparator(.hidden)
        .listRowInsets(.init())
        .onTapGesture {
          navigateToColorPaletteScreen(palette)
        }
    }
  }
}

private extension SamplePalettesView {
  func onAppear() {
    viewModel.input.onAppear.send()
  }
  
  func navigateToColorPaletteScreen(_ selectedPalette: ColorPalette) {
    viewModel.input.paletteTap.send(selectedPalette)
  }
}

struct SamplePalettesView_Previews: PreviewProvider {
  static var previews: some View {
    SamplePalettesView(viewModel: SamplePalettesViewModel())
      .environmentObject(LocalizationService.shared)
  }
}
