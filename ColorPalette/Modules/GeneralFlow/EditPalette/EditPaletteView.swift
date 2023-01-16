//
//  EditPaletteView.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 16.01.2023.
//

import SwiftUI

struct EditPaletteView: View {
    let initPalette: ColorPalette
    
    @State private var resultPalette: ColorPalette
    @State private var hueValue: CGFloat = 0
    @State private var saturationValue: CGFloat = 0
    @State private var brightnessValue: CGFloat = 0
    
    init(initPalette: ColorPalette) {
        self.initPalette = initPalette
        self.resultPalette = initPalette
    }
    
    var body: some View {
        VStack {
            palettesPreview
            Spacer()
            slidersBlock
        }
    }
}

private extension EditPaletteView {
    var palettesPreview: some View {
        HStack(spacing: 0) {
            initPalettePreview
            resultPalettePreview
        }
    }
    
    var initPalettePreview: some View {
        VStack(spacing: 0) {
            ForEach(initPalette.colors) { color in
                ZStack {
                    Color(color)
                    Text(color.hex)
                        .foregroundColor(Color(color.uiColor.invertColor()))
                        .font(.title3)
                        .bold()
                }
            }
        }
    }
    
    var resultPalettePreview: some View {
        VStack(spacing: 0) {
            ForEach(resultPalette.colors) { color in
                ZStack {
                    Color(color)
                    Text(color.hex)
                        .foregroundColor(Color(color.uiColor.invertColor()))
                        .font(.title3)
                        .bold()
                }
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
            
            Button(action: { resetValues() }) {
                Text("Reset")
            }
        }
        .padding()
    }
    
    var hueSliderBlock: some View {
        VStack {
            HStack {
                Text("Hue")
               Spacer()
                Text("\(Int(hueValue))")
            }
            
            Slider(value: $hueValue, in: -180...180, step: 1)
                .onChange(of: hueValue) { newValue in
                    changeValue(newValue, type: .hue)
                }
        }
    }
    
    var saturationSliderBlock: some View {
        VStack {
            HStack {
                Text("Saturation")
               Spacer()
                Text("\(Int(saturationValue))")
            }
            
            Slider(value: $saturationValue, in: -100...100, step: 1)
                .onChange(of: saturationValue) { newValue in
                    changeValue(newValue, type: .saturation)
                }
        }
    }
    
    var brightnessSliderBlock: some View {
        VStack {
            HStack {
                Text("Brightness")
               Spacer()
                Text("\(Int(brightnessValue))")
            }
            
            Slider(value: $brightnessValue, in: -100...100, step: 1)
                .onChange(of: brightnessValue) { newValue in
                    changeValue(newValue, type: .brightness)
                }
        }
    }
}

private extension EditPaletteView {
    func changeValue(_ newValue: CGFloat, type: ColorPropertyType) {
        let colors = initPalette.colors.map { $0.uiColor }
        
        let newColors = colors.map {
            switch type {
                case .hue:
                    return AppColor(uiColor: $0.add(hue: newValue, saturation: saturationValue, brightness: brightnessValue))
                case .saturation:
                    return AppColor(uiColor: $0.add(hue: hueValue, saturation: newValue, brightness: brightnessValue))
                case .brightness:
                    return AppColor(uiColor: $0.add(hue: hueValue, saturation: saturationValue, brightness: newValue))
            }
        }
        
        resultPalette = ColorPalette(colors: newColors)
    }
    
    func resetValues() {
        hueValue = 0
        saturationValue = 0
        brightnessValue = 0
    }
    
    enum ColorPropertyType {
        case hue
        case saturation
        case brightness
    }
}

struct EditPaletteView_Previews: PreviewProvider {
    static var previews: some View {
        let colors: [AppColor] = [
            AppColor(hex: "#E59F71"),
            AppColor(hex: "#BA5A31"),
            AppColor(hex: "#0C0C0C"),
            AppColor(hex: "#69DC9E"),
            AppColor(hex: "#FFFFFF")
        ]
        let palette = ColorPalette(colors: colors)
        EditPaletteView(initPalette: palette)
    }
}
