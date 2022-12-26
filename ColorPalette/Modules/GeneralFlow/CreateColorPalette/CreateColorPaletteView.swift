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
    
    @State private var showAlert: Bool = false
    @State private var isSaved: Bool = false
    
    @StateObject private var templatePaletteManager: TemplatePaletteManager = .init()
    @EnvironmentObject private var paletteStorage: PaletteStorageManager
    
    weak var router: FavoritesRoutable?
    
    init(router: FavoritesRoutable? = nil) {
        self.router = router
    }
    
    var body: some View {
        VStack {
            navBar
            topButtons
            
            ScrollView {
                VStack {
                    palettePreview
                    
                    Spacer()
                    
                    bottomButtons
                    
                    ColorTypePickerView(selectedType: $selectedType)
                    
                }
                .padding()
            }
        }
        .alert(Text("Are you sure?"), isPresented: $showAlert, actions: {
            Button(role: .cancel, action: {}) {
                Text("Stay")
            }
            Button(role: .destructive, action: {
                isSaved = true
                router?.pop()
            }) {
                Text("Don't save")
            }
        }, message: {
            Text("Before you go, maybe you want save this template?")
        })
        .edgesIgnoringSafeArea(.top)
        
    }
}

private extension CreateColorPaletteView {
    var navBar: some View {
        CustomNavigationBarView(backAction: { pop() })
            .padding(.top, Consts.Constraints.top)
    }
    
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
    func pop() {
        if !isSaved {
            showAlert.toggle()
        } else {
            router?.pop()
        }
    }
}

private extension CreateColorPaletteView {
    func savePalette() {
        let pallete = templatePaletteManager.createPalette()
        paletteStorage.addPallete(pallete)
        
        isSaved = true
        
        if isSaved {
            router?.pop()
        }
    }
}

struct CreateColorPaletteView_Previews: PreviewProvider {
    static var previews: some View {
        CreateColorPaletteView()
            .environmentObject(PaletteStorageManager.shared)
    }
}
