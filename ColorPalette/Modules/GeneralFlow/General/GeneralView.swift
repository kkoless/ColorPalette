//
//  GeneralView.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 30.11.2022.
//

import SwiftUI

struct GeneralView: View {
    @StateObject var viewModel: GeneralViewModel
    @EnvironmentObject private var localizationService: LocalizationService
    
    var body: some View {
        VStack {
            header
            ScrollView {
                paletteCells
                colorsCells
            }
        }
        .onAppear(perform: onAppear)
        .padding([.top, .bottom])
    }
}

private extension GeneralView {
    var header: some View {
        HStack {
            Text(.general)
                .bold()
                .font(.largeTitle)
            Spacer()
        }
        .padding([.leading, .trailing])
    }
    
    var paletteCells: some View {
        VStack(spacing: 0) {
            HStack {
                Text(.palettes)
                    .font(.title3.bold())
                Spacer()
            }
            .padding(.bottom, 5)
            
            ForEach(viewModel.output.samplePalettes) { palette in
                ColorPaletteCell(palette: palette)
                    .onTapGesture { navigateToPaletteInfo(palette) }
            }
            Button(action: { navigateToSamplePalettes() }) {
                Text(.showMore)
            }
            .padding()
        }
        .padding([.leading, .trailing])
    }
    
    var colorsCells: some View {
        VStack(spacing: 0) {
            HStack {
                Text(.colors).font(.title3.bold())
                Spacer()
            }
            .padding(.bottom, 5)
            
            ForEach(viewModel.output.sampleColors) { color in
                Color(color)
                    .frame(height: 35)
                    .cornerRadius(7)
                    .padding([.top, .bottom], 10)
                    .onTapGesture { navigateToColorInfo(color) }
            }
            
            Button(action: { navigateToSampleColors() }) {
                Text(.showMore)
            }
            .padding()
        }
        .padding([.leading, .trailing])
    }
}

private extension GeneralView {
    func onAppear() {
        viewModel.input.onAppear.send()
    }
    
    func navigateToSamplePalettes() {
        viewModel.input.showMorePalettesTap.send()
    }
    
    func navigateToSampleColors() {
        viewModel.input.showMoreColorsTap.send()
    }
    
    func navigateToPaletteInfo(_ palette: ColorPalette) {
        viewModel.input.paletteTap.send(palette)
    }
    
    func navigateToColorInfo(_ color: AppColor) {
        viewModel.input.colorTap.send(color)
    }
}

struct GeneralView_Previews: PreviewProvider {
    static var previews: some View {
        GeneralView(viewModel: GeneralViewModel())
            .environmentObject(LocalizationService.shared)
    }
}
