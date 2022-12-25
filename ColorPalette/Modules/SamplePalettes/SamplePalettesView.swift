//
//  SamplePalettesView.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 21.12.2022.
//

import SwiftUI

struct SamplePalettesView: View {
    weak var router: GeneralRoutable?
    @State private var palettes = ColorPalette.getTestPalettes(20)
    
    var body: some View {
        VStack {
            header
            
            List {
                cells
            }
        }
        .listStyle(.plain)
    }
}

private extension SamplePalettesView {
    var header: some View {
        HStack {
            Text("Sample Palettes")
                .font(.largeTitle)
                .bold()
                
            Spacer()
        }
        .padding()
    }
    
    var cells: some View {
        ForEach(palettes) { palette in
            ColorPaletteCell(palette: palette)
                .padding([.leading, .trailing])
                .listRowSeparator(.hidden)
                .listRowInsets(.init())
                .onTapGesture {
                    navigateToColorPaletteScreen(palette)
                }
        }
        .onDelete { indexSet in
            indexSet.forEach { palettes.remove(at: $0) }
        }
    }
}

private extension SamplePalettesView {
    func navigateToColorPaletteScreen(_ selectedPalette: ColorPalette) {
        router?.navigateToColorPalette(palette: selectedPalette)
    }
}

struct SamplePalettesView_Previews: PreviewProvider {
    static var previews: some View {
        SamplePalettesView()
    }
}
