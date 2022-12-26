//
//  SamplePalettesView.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 21.12.2022.
//

import SwiftUI

struct SamplePalettesView: View {
    @State private var palettes = ColorPalette.getTestPalettes(20)
    weak private var router: GeneralRoutable?
    
    init(router: GeneralRoutable? = nil) {
        self.router = router
    }
    
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
    }
}

private extension SamplePalettesView {
    var navBar: some View {
        CustomNavigationBarView(backAction: { pop() })
            .padding(.top, Consts.Constraints.top)
    }
    
    var header: some View {
        HStack {
            Text("Sample Palettes")
                .font(.largeTitle)
                .bold()
                
            Spacer()
        }
        .padding([.leading, .trailing])
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
    
    func pop() {
        router?.pop()
    }
}

struct SamplePalettesView_Previews: PreviewProvider {
    static var previews: some View {
        SamplePalettesView()
    }
}
