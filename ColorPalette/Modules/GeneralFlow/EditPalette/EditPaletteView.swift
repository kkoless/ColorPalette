//
//  EditPaletteView.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 16.01.2023.
//

import SwiftUI

struct EditPaletteView: View {
    @StateObject var viewModel: EditPaletteViewModel
    
    @State private var draggedColor: AppColor?
    @State private var hueValue: CGFloat = 0
    @State private var saturationValue: CGFloat = 0
    @State private var brightnessValue: CGFloat = 0
    
    let initPalette: ColorPalette
    
    var body: some View {
        VStack {
            navigationBarView
            palettesPreview
            slidersBlock
            buttonsBlock
        }
        .edgesIgnoringSafeArea(.top)
        .foregroundColor(.primary)
    }
}

private extension EditPaletteView {
    var navigationBarView: some View {
        CustomNavigationBarView(
            backAction: { backTap() },
            titleText: .paletteEditor
        )
    }
    
    var palettesPreview: some View {
        HStack(spacing: 0) {
            initPalettePreview
            resultPalettePreview
        }
        .cornerRadius(10)
        .padding()
    }
    
    var initPalettePreview: some View {
        VStack(spacing: 0) {
            ForEach(initPalette.colors) { color in
                ZStack {
                    Color(color).opacity(color.alpha)
                    Text(color.hex)
                        .foregroundColor(Color(color.uiColor.invertColor()).opacity(1))
                        .font(.title3)
                        .bold()
                }
            }
        }
    }
    
    var resultPalettePreview: some View {
        VStack(spacing: 0) {
            ForEach(viewModel.output.resultPaletteColors) { color in
                ZStack {
                    Color(color).opacity(color.alpha)
                    Text(color.hex)
                        .foregroundColor(Color(color.uiColor.invertColor()).opacity(1))
                        .font(.title3)
                        .bold()
                }
                .onDrag({ drugAction(color) }, preview: {
                    EmptyView()
                })
                .onDrop(of: [.text],
                        delegate: DropViewDelegate(destinationItem: color, initColors: $viewModel.output.initPaletteColors, resultColors: $viewModel.output.resultPaletteColors, draggedItem: $draggedColor)
                    )
            }
        }
    }
}

private extension EditPaletteView {
    var slidersBlock: some View {
        VStack(spacing: 15) {
            hueSliderBlock
            saturationSliderBlock
            brightnessSliderBlock
        }
        .padding()
    }
    
    var hueSliderBlock: some View {
        VStack {
            HStack {
                Text(.hue).bold()
               Spacer()
                Text("\(Int(hueValue))").bold()
                    .padding(.trailing)
                
                HStack {
                    Button(action: { buttonChangeValue(hueValue + 1, type: .hue) }) {
                        Image(systemName: "plus")
                    }
                    
                    Button(action: { buttonChangeValue(hueValue - 1, type: .hue) }) {
                        Image(systemName: "minus")
                    }
                }
            }
            
            Slider(value: $hueValue, in: -180...180, step: 1)
                .onChange(of: hueValue) { newValue in
                    viewModel.sliderChangeHSB(hue: newValue, saturation: saturationValue, brightness: brightnessValue)
                }
        }
    }
    
    var saturationSliderBlock: some View {
        VStack {
            HStack {
                Text(.saturation).bold()
               Spacer()
                Text("\(Int(saturationValue))")
                    .bold()
                    .padding(.trailing)
                
                HStack {
                    Button(action: {
                        buttonChangeValue(saturationValue + 1, type: .saturation)
                    }) {
                        Image(systemName: "plus")
                    }
                    
                    Button(action: { buttonChangeValue(saturationValue - 1, type: .saturation) }) {
                        Image(systemName: "minus")
                    }
                }
            }
            
            Slider(value: $saturationValue, in: -100...100, step: 1)
                .onChange(of: saturationValue) { newValue in
                    viewModel.sliderChangeHSB(hue: hueValue, saturation: newValue, brightness: brightnessValue)
                }
        }
    }
    
    var brightnessSliderBlock: some View {
        VStack {
            HStack {
                Text(.brightness).bold()
               Spacer()
                Text("\(Int(brightnessValue))")
                    .bold()
                    .padding(.trailing)
                
                HStack {
                    Button(action: { buttonChangeValue(brightnessValue + 1, type: .brightness) }) {
                        Image(systemName: "plus")
                    }
                    
                    Button(action: { buttonChangeValue(brightnessValue - 1, type: .brightness) }) {
                        Image(systemName: "minus")
                    }
                }
            }
            
            Slider(value: $brightnessValue, in: -100...100, step: 1)
                .onChange(of: brightnessValue) { newValue in
                    viewModel.sliderChangeHSB(hue: hueValue, saturation: saturationValue, brightness: newValue)
                }
        }
    }
}

private extension EditPaletteView {
    var buttonsBlock: some View {
        HStack {
            Spacer()
            Button(action: { resetValues() }) { Text(.reset) }
            Spacer()
            Button(action: { applyTap() }) { Text(.apply) }
            Spacer()
        }
        .padding()
    }
}

private extension EditPaletteView {
    func backTap() {
        viewModel.input.backTap.send()
    }
    
    func applyTap() {
        viewModel.input.updateTap.send()
    }
    
    func buttonChangeValue(_ newValue: CGFloat, type: ColorPropertyType) {
        var check = false
        switch type {
            case .hue:
                check = newValue >= -180 && newValue <= 180 ? true : false
                if check {
                    hueValue = newValue
                    viewModel.sliderChangeHSB(hue: newValue, saturation: saturationValue, brightness: brightnessValue)
                }
                
            case .saturation:
                check = newValue >= -100 && newValue <= 100 ? true : false
                if check {
                    saturationValue = newValue
                    viewModel.sliderChangeHSB(hue: hueValue, saturation: newValue, brightness: brightnessValue)
                }
            case .brightness:
                check = newValue >= -100 && newValue <= 100 ? true : false
                if check {
                    brightnessValue = newValue
                    viewModel.sliderChangeHSB(hue: hueValue, saturation: saturationValue, brightness: newValue)
                }
        }
    }
    
    func drugAction(_ color: AppColor) -> NSItemProvider {
        self.draggedColor = color
        return NSItemProvider()
    }
    
    func resetValues() {
        withAnimation {
            hueValue = 0
            saturationValue = 0
            brightnessValue = 0
        }
        viewModel.input.resetTap.send()
    }
}

private extension EditPaletteView {
    struct DropViewDelegate: DropDelegate {
        let destinationItem: AppColor
        
        @Binding var initColors: [AppColor]
        @Binding var resultColors: [AppColor]
        @Binding var draggedItem: AppColor?
        
        func dropUpdated(info: DropInfo) -> DropProposal? {
            return DropProposal(operation: .move)
        }
        
        func performDrop(info: DropInfo) -> Bool {
            draggedItem = nil
            return true
        }
        
        func dropEntered(info: DropInfo) {
            if let draggedItem {
                let fromIndex = resultColors.firstIndex(of: draggedItem)
                if let fromIndex {
                    let toIndex = resultColors.firstIndex(of: destinationItem)
                    if let toIndex, fromIndex != toIndex {
                        withAnimation {
                            self.resultColors.move(fromOffsets: IndexSet(integer: fromIndex), toOffset: (toIndex > fromIndex ? (toIndex + 1) : toIndex))
                        }
                        self.initColors = resultColors
                    }
                }
            }
        }
    }
    
    enum ColorPropertyType {
        case hue
        case saturation
        case brightness
    }
}

struct EditPaletteView_Previews: PreviewProvider {
    static var previews: some View {
        let palette = PopularPalettesManager.shared.palettes[0]
        EditPaletteView(viewModel: EditPaletteViewModel(palette: palette), initPalette: palette)
    }
}
