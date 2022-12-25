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
    @EnvironmentObject var favoriteManager: FavoriteManager
    
    private var uiColor: UIColor {
        UIColor(selectedColor)
    }
    
    var body: some View {
        VStack(spacing: 20) {
            configureBlock
            if selectedColor != .clear {
                preview
            } else {
                Spacer()
            }
        }
        .padding()
        .toolbar {
            Button(action: { saveColor() }) {
                Image(systemName: "plus.circle")
                    .resizable()
            }
            .disabled(selectedColor == .clear)
        }
    }
}

private extension AddNewColorView {
    var configureBlock: some View {
        HStack(spacing: 15) {
            TextField("Color name", text: $colorName)
                .padding([.leading, .trailing])
                .padding([.bottom, .top], 10)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(.gray))
            
            ColorPicker("Here you can pick...", selection: $selectedColor)
                .font(.subheadline)
        }
    }
    
    var preview: some View {
        ColorInfoView(color: uiColor, colorName: $colorName)
            .cornerRadius(10)
    }
}

private extension AddNewColorView {
    func saveColor() {
        favoriteManager.addColor(newColor: AppColor(name: colorName, hex: UIColor(selectedColor).hexValue))
    }
}

struct AddNewColorView_Previews: PreviewProvider {
    static var previews: some View {
        AddNewColorView()
    }
}
