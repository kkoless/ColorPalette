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
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            if let appColors = self?.getColors(from: data).map({ AppColor(uiColor: UIColor(hexString: $0.hexValue, alpha: $0.alphaValue)) }) {
                DispatchQueue.main.async {
                    self?.palette = ColorPalette(colors: appColors)
                }
            }
        }
    }
    
    deinit {
        print("\(self) DEINIT")
    }
}

private extension ImageColorDetectionManager {
    func getColors(from data: Data) -> [UIColor] {
        var colors: [UIColor] = .init()
        
        let image = UIImage(data: data) ?? UIImage()
        let imageColors = image.getColors()
        
        guard let _imageColors = imageColors else { return colors }
        
        colors.append(_imageColors.background)
        colors.append(_imageColors.primary)
        colors.append(_imageColors.secondary)
        colors.append(_imageColors.detail)
        
        return colors
    }
}
