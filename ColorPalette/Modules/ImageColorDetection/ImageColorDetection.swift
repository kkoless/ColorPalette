//
//  ImageColorDetection.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 22.12.2022.
//

import SwiftUI

struct ImageColorDetection: View {
    @State var isSet: Bool = false
    @State var selection: UIImage = .init()
    
    @State var averageColor: Color = .clear
    @State var colorPalette: ColorPalette?
    
    @State private var showPopover = false
    
    var body: some View {
        ScrollView {
            VStack {
                selectedImage
                    .frame(width: 300, height: 300)
                    .cornerRadius(15)
                    .shadow(radius: 40)
                    .padding()
                
                Spacer()
                
                Group {
                    palette
                    averageColorBlock
                }
                
                Spacer()
                
                actionButtons
            }
        }
    }
}

private extension ImageColorDetection {
    @ViewBuilder
    var selectedImage: some View {
        if isSet {
            Image(uiImage: selection)
                .resizable()
                
        } else {
            Color.gray
        }
    }
    
    var averageColorBlock: some View {
        HStack {
            Text("Average:")
            averageColor
                .frame(height: 30)
                .cornerRadius(10)
        }
        .padding()
    }
    
    @ViewBuilder
    var palette: some View {
        if let palette = colorPalette {
            ColorPaletteCell(palette: palette)
                .padding()
        }
    }
    
    var actionButtons: some View {
        Group {
            Button(action: { showPopover.toggle() }) {
                Text("Choose image")
            }
            .popover(isPresented: $showPopover) {
                ImagePicker(selectedImage: $selection, didSet: $isSet)
            }
            
            if isSet {
                Button(action: { setAverageColor() }) {
                    Text("Get average color")
                }
                
                Button(action: { generatePalette()  }) {
                    Text("Get palette")
                }
            }
        }
        .padding()
    }
}

private extension ImageColorDetection {
    func setAverageColor() {
        DispatchQueue.global().async {
            if let _averageColor = selection.averageColor {
                averageColor = Color(_averageColor)
            }
        }
    }
    
    func getColors() -> [UIColor] {
        var colors = [UIColor]()
        
        let tmpColors = selection.getColors()
        guard let _tmpColors = tmpColors else { return colors }
        
        colors.append(_tmpColors.background)
        colors.append(_tmpColors.primary)
        colors.append(_tmpColors.secondary)
        colors.append(_tmpColors.detail)
        
        return colors
    }
    
    func generatePalette()  {
        let resColors = getColors()
            .map {
                AppColor(name: $0.accessibilityName,
                         hex: $0.hexValue)
            }
        
        colorPalette = ColorPalette(colors: resColors)
    }
}

struct ImageColorDetection_Previews: PreviewProvider {
    static var previews: some View {
        ImageColorDetection(isSet: false, selection: UIImage())
    }
}
