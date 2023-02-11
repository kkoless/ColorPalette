//
//  ColorPaletteView.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 22.12.2022.
//

import SwiftUI

struct ColorPaletteView: View {
    @StateObject var viewModel: ColorPaletteInfoViewModel
    @Environment(\.dismiss) private var dismiss: DismissAction
    
    @State var selectedType: ColorType = .HEX
    @State var showInfo: Bool = true
    
    let palette: ColorPalette
    
    var body: some View {
        VStack(spacing: 0) {
            topBar
            
            VStack(spacing: 0) {
                ForEach(palette.colors) { color in
                    ColorPaletteRowView(appColor: color, type: selectedType, showInfo: showInfo)
                }
            }
            .onTapGesture { showInfo.toggle() }
            .onAppear(perform: onAppear)
            
            ColorTypePickerView(selectedType: $selectedType)
                .padding(.top, 10)
        }
    }
}

private extension ColorPaletteView {
    var topBar: some View {
        ZStack {
            Color(palette.colors[0])
            HStack {
                backButton
                Spacer()
                favoriteButton
            }
            .padding(20)
        }
        .frame(height: 25)
        .padding([.top, .bottom])
    }
    
    var backButton: some View {
        Button(action: { dismiss() }) {
            Image(systemName: "multiply")
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundColor(Color(palette.colors[0].uiColor.invertColor()))
        }
    }
    
    var favoriteButton: some View {
        Button(action: { changeFavoriteState() }, label: {
            Image(systemName: viewModel.output.isFavorite ? "heart.fill" : "heart")
                .resizable()
                .frame(width: 25, height: 25)
                .foregroundColor(viewModel.output.isFavorite ? .red : Color(palette.colors[0].uiColor.invertColor()))
        })
    }
}

private extension ColorPaletteView {
    func onAppear() {
        viewModel.input.onAppear.send()
    }
    
    func changeFavoriteState() {
        viewModel.input.favTap.send()
    }
}

struct ColorPaletteView_Previews: PreviewProvider {
    static var previews: some View {
        let palette = ColorPalette.getTestPalettes(20)[1]
        ColorPaletteView(viewModel: ColorPaletteInfoViewModel(palette: palette), palette: palette)
    }
}
