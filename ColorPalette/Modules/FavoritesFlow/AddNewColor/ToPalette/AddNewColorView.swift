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
    @State private var selectedColor: Color = .clear
    
    var body: some View {
        VStack(spacing: 20) {
            configureBlock
            if selectedColor != .clear {
                preview
                buttons
            } else {
                Spacer()
            }
        }
        .padding()
    }
}

private extension AddNewColorToPaletteView {
    var configureBlock: some View {
        HStack(spacing: 15) {
            TextField("Color name", text: $colorName)
                .padding([.leading, .trailing])
                .padding([.bottom, .top], 10)
                .textFieldStyle(.plain)
                .onChange(of: colorName) { newValue in
                    viewModel.input.colorName.send(newValue)
                }
            
            ColorPicker("Here you can pick...", selection: $selectedColor)
                .font(.subheadline)
                .onChange(of: selectedColor) { newValue in
                    let appColor = AppColor(uiColor: newValue.uiColor)
                    viewModel.input.selectedColor.send(appColor)
                }
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
                Text("Add color")
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
