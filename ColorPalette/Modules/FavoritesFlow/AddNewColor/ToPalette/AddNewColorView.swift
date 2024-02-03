//
//  AddNewColorToPaletteView.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 24.12.2022.
//

import SwiftUI
import Combine

struct AddNewColorToPaletteView: View {
  @StateObject var viewModel: AddNewColorToPaletteViewModel

  @State private var colorName = ""
  @State private var selectedColor: Color = .primary

  var body: some View {
    VStack(spacing: 20) {
      configureBlock
      if selectedColor != .primary {
        preview
        buttons
      } else {
        Spacer()
      }
    }
    .foregroundColor(.primary)
    .padding()
  }
}

private extension AddNewColorToPaletteView {
  var configureBlock: some View {
    HStack(spacing: 15) {
      AddColorTextField(text: $colorName)
        .environmentObject(LocalizationService.shared)
        .padding([.bottom, .top], 10)
        .onChange(of: colorName) { newValue in
          viewModel.input.colorName.send(newValue)
        }

      ColorPicker("", selection: $selectedColor)
        .onChange(of: selectedColor) { newValue in
          let appColor = AppColor(uiColor: newValue.uiColor)
          viewModel.input.selectedColor.send(appColor)
        }
        .frame(width: 50, height: 40, alignment: .center)
    }
  }

  var preview: some View {
    ColorPreview(color: viewModel.output.color)
      .cornerRadius(10)
  }

  var buttons: some View {
    HStack(alignment: .center) {
      Spacer()

      Button(action: { viewModel.input.addTap.send() }) {
        Text(.addColor)
      }

      Spacer()
    }
  }
}

struct AddNewColorToPaletteView_Previews: PreviewProvider {
  static var previews: some View {
    AddNewColorToPaletteView(viewModel: AddNewColorToPaletteViewModel(templatePaletteManager: TemplatePaletteManager()))
  }
}
