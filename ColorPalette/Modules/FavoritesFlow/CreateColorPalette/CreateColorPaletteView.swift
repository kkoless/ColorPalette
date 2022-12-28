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
    @State private var showAddColor: Bool = false
    
    @ObservedObject var viewModel : CreateColorPaletteViewModel
    
    var body: some View {
        VStack {
            navBar
            
            topButtons
            
            ColorTypePickerView(selectedType: $selectedType)
            
            ScrollView {
                palettePreview
                    .padding()
            }
        }
        .alert(Text("Are you sure?"), isPresented: $viewModel.output.showSaveAlert, actions: {
            Button(role: .cancel, action: { stayAlertTap() }) {
                Text("Stay")
            }
            Button(role: .destructive, action: { backAlertTap() }) {
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
        CustomNavigationBarView(backAction: viewModel.input.backTap)
            .padding(.top, Consts.Constraints.top)
    }
    
    var topButtons: some View {
        HStack {
            Button(action: { addColorTap() }) {
                Text("Add custom color")
            }
            
            Spacer()
            
            if !viewModel.output.colors.isEmpty {
                Button(action: { savePaletteTap() }) {
                    Text("Save palette")
                }
            }
        }
        .padding()
    }
    
    var palettePreview: some View {
        VStack(spacing: 0) {
            ForEach(viewModel.output.colors) { color in
                ColorPaletteRowView(appColor: color, type: selectedType, showInfo: showColorInfo)
            }
        }
        .cornerRadius(10)
    }
}

private extension CreateColorPaletteView {
    func savePaletteTap() {
        viewModel.input.saveTap.send()
    }
    
    func addColorTap() {
        viewModel.input.addTaps.addColorTap.send()
    }
    
    func stayAlertTap() {
        viewModel.input.alertTaps.stayTap.send()
    }
    
    func backAlertTap() {
        viewModel.input.alertTaps.backTap.send()
    }
}

struct CreateColorPaletteView_Previews: PreviewProvider {
    static var previews: some View {
        CreateColorPaletteView(viewModel: CreateColorPaletteViewModel())
    }
}
