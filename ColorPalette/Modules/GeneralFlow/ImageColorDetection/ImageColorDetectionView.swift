//
//  ImageColorDetectionView.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 22.12.2022.
//

import SwiftUI

struct ImageColorDetectionView: View {
    @State private var isSet: Bool = false
    @State private var selection: UIImage = .init()
    @State private var averageColor: Color = .clear
    @State private var colorPalette: ColorPalette?
    @State private var showPopover = false
    
    weak private var router: GeneralRoutable?
    
    init(router: GeneralRoutable? = nil) {
        self.router = router
    }
    
    var body: some View {
        VStack {
            navBar
            
            selectedImage
                .frame(width: 300, height: 300)
                .cornerRadius(15)
                .shadow(radius: 20)
                .padding()
            
            Spacer()
            
            actionButtons
            
            ScrollView {
                VStack {
                    Group {
                        palette
                        averageColorBlock
                    }
                }
            }
            
        }
        .edgesIgnoringSafeArea(.top)
    }
}

private extension ImageColorDetectionView {
    var navBar: some View {
        CustomNavigationBarView()
            .padding(.top, Consts.Constraints.top)
    }
    
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
        averageColor
            .frame(height: 30)
            .cornerRadius(10)
            .padding([.leading, .trailing])
    }
    
    @ViewBuilder
    var palette: some View {
        if let palette = colorPalette {
            ColorPaletteCell(palette: palette)
                .padding([.leading, .trailing])
        }
    }
    
    var actionButtons: some View {
        HStack {
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

private extension ImageColorDetectionView {
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
            .map { AppColor(uiColor: $0) }
        
        colorPalette = ColorPalette(colors: resColors)
    }
}

struct ImageColorDetectionView_Previews: PreviewProvider {
    static var previews: some View {
        ImageColorDetectionView()
    }
}
