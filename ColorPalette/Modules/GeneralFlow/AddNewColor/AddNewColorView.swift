//
//  AddNewColorView.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 24.12.2022.
//

import SwiftUI

struct AddNewColorView: View {
    @State private var colorName = ""
    @State private var selectedColor: Color = .clear
    @Binding private var showAsPopover: Bool
    
    @EnvironmentObject var templatePaletteManager: TemplatePaletteManager
    
    init(showAsPopover: Binding<Bool>? = nil) {
        self._showAsPopover = showAsPopover ?? .constant(false)
    }
    
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

private extension AddNewColorView {
    var configureBlock: some View {
        HStack(spacing: 15) {
            TextField("Color name", text: $colorName)
                .padding([.leading, .trailing])
                .padding([.bottom, .top], 10)
                .textFieldStyle(.plain)
            
            ColorPicker("Here you can pick...", selection: $selectedColor)
                .font(.subheadline)
        }
    }
    
    var preview: some View {
        ColorInfoView(color: selectedColor.uiColor, colorName: $colorName)
            .cornerRadius(10)
    }
    
    var buttons: some View {
        HStack(alignment: .center) {
            Spacer()
            
            Button(action: { addColor() }) {
                Text("Add color")
            }
            .disabled(selectedColor == .clear)
            
            Spacer()
            
            Button(action: { saveColor() }) {
                Text("Save color")
            }
            .disabled(selectedColor == .clear)
            
            Spacer()
        }
    }
}

private extension AddNewColorView {
    func saveColor() {
        
    }
    
    func addColor() {
        templatePaletteManager.addColor(AppColor(name: colorName, hex: selectedColor.uiColor.hexValue))
        showAsPopover.toggle()
    }
}

struct AddNewColorView_Previews: PreviewProvider {
    static var previews: some View {
        AddNewColorView()
            .environmentObject(TemplatePaletteManager())
    }
}
