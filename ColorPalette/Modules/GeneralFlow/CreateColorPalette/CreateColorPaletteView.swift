//
//  CreateColorPaletteView.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 25.12.2022.
//

import SwiftUI

struct CreateColorPaletteView: View {
    @State private var selectedType: ColorType = .HEX
    @State private var showColorInfo: Bool = true
    @State private var showColorLibrary: Bool = false
    @State private var showAddColor: Bool = false
    
    @StateObject private var templatePaletteManager: TemplatePaletteManager = .init()
    @EnvironmentObject private var paletteStorage: PaletteStorageManager
    
    weak var router: FavoritesRoutable?
    
    init(router: FavoritesRoutable? = nil) {
        self.router = router
    }
    
    var body: some View {
        ScrollView {
            VStack {
                topButtons
                
                Spacer()
                
                palettePreview
                
                Spacer()
                
                bottomButtons
                
                ColorTypePickerView(selectedType: $selectedType)
                
            }
            .padding()
        }
    }
}

private extension CreateColorPaletteView {
    var topButtons: some View {
        HStack {
            Button(action: { showAddColor.toggle() }) {
                Text("Add custom color")
            }
            .popover(isPresented: $showAddColor) {
                AddNewColorView(showAsPopover: $showAddColor)
                    .environmentObject(templatePaletteManager)
            }
            
            Spacer()
            
            Button(action: { showColorLibrary.toggle() }) {
                Text("Choose color from library")
            }
            .popover(isPresented: $showColorLibrary) {
                SampleColorsView(showColorLibrary: $showColorLibrary)
                    .environmentObject(templatePaletteManager)
            }
        }
        .padding()
    }
    
    var palettePreview: some View {
        VStack(spacing: 0) {
            ForEach(templatePaletteManager.colors) { color in
                ColorPaletteRowView(appColor: color, type: selectedType, showInfo: showColorInfo)
            }
        }
        .cornerRadius(10)
    }
    
    var bottomButtons: some View {
        Button(action: { savePalette() }) {
            Text("Save palette")
        }
        .disabled(templatePaletteManager.colors.isEmpty)
        .padding()
    }
}

private extension CreateColorPaletteView {
    func savePalette() {
        let pallete = templatePaletteManager.createPalette()
        paletteStorage.addPallete(pallete)
        router?.pop()
    }
}

struct CreateColorPaletteView_Previews: PreviewProvider {
    static var previews: some View {
        CreateColorPaletteView()
            .environmentObject(PaletteStorageManager.shared)
    }
}
