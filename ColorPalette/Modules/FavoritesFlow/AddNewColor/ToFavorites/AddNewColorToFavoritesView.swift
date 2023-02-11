//
//  AddNewColorToFavoritesView.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 11.02.2023.
//

import SwiftUI

struct AddNewColorToFavoritesView: View {
    @StateObject var viewModel: AddNewColorToFavoritesViewModel
    
    @State private var colorName = ""
    @State private var selectedColor: Color = .primary
    
    var body: some View {
        VStack(spacing: 15) {
            navigationBarView
            configureBlock
            if selectedColor != .primary {
                preview
            }
            Spacer()
        }
        .edgesIgnoringSafeArea(.top)
    }
}

private extension AddNewColorToFavoritesView {
    var navigationBarView: some View {
        CustomNavigationBarView(backAction: { backTap() })
            .trailingItems {
                Button(action: { addToFavorites() }) {
                    Image(systemName: "checkmark")
                        .resizable()
                        .frame(width: 20, height: 20)
                }
                .disabled(viewModel.output.isFavorite)
                .foregroundColor(viewModel.output.isFavorite ? .gray : .primary)
            }
    }
    
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
        .padding([.leading, .trailing])
    }
    
    var preview: some View {
        ColorPreview(color: viewModel.output.color)
            .cornerRadius(10)
            .padding([.leading, .trailing])
    }
}

private extension AddNewColorToFavoritesView {
    func addToFavorites() {
        viewModel.input.addTap.send()
    }
    
    func backTap() {
        viewModel.input.backTap.send()
    }
}

struct AddNewColorToFavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        AddNewColorToFavoritesView(viewModel: AddNewColorToFavoritesViewModel())
    }
}
