//
//  ImageColorDetectionManager.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 28.12.2022.
//

import Foundation
import UIKit

final class ImageColorDetectionManager: ObservableObject {
    @Published private(set) var palette: ColorPalette?
    
    init() {
        self.palette = nil
        print("\(self) INIT")
    }
    
    func generatePalette(from data: Data)  {
        let appColors = getColorsHex(from: data).map { AppColor(uiColor: UIColor(hexString: $0)) }
        self.palette = ColorPalette(colors: appColors)
    }
    
    deinit {
        print("\(self) DEINIT")
    }
}

private extension ImageColorDetectionManager {
    func getColorsHex(from data: Data) -> [String] {
        var colorsHex: [String] = .init()
        
        let image = UIImage(data: data) ?? UIImage()
        let imageColors = image.getColors()
        
        guard let _imageColors = imageColors else { return colorsHex }
        
        colorsHex.append(_imageColors.background.hexValue)
        colorsHex.append(_imageColors.primary.hexValue)
        colorsHex.append(_imageColors.secondary.hexValue)
        colorsHex.append(_imageColors.detail.hexValue)
        
        return colorsHex
    }
}
