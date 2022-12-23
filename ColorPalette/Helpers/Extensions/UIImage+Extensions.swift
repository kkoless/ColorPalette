//
//  UIImage+Extensions.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 22.12.2022.
//

import Foundation
import UIKit

extension UIImage {
    subscript (x: Int, y: Int) -> UIColor? {
        let width = Int(size.width)
        let height = Int(size.height)
        
        if x < 0 || x > width || y < 0 || y > height { return nil }
        
        guard let cgImage = self.cgImage else { return nil }
        guard let provider = cgImage.dataProvider else { return nil }
        guard let providerData = provider.data else { return nil }
        
        let data = CFDataGetBytePtr(providerData)

        let numberOfComponents = 4
        let pixelData = ((width * y) + x) * numberOfComponents

        let r = CGFloat(data![pixelData]) / 255.0
        let g = CGFloat(data![pixelData + 1]) / 255.0
        let b = CGFloat(data![pixelData + 2]) / 255.0
        let a = CGFloat(data![pixelData + 3]) / 255.0

        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
}

extension UIImage {
    var averageColor: UIColor? {
        guard let inputImage = CIImage(image: self) else { return nil }
        let extentVector = CIVector(x: inputImage.extent.origin.x, y: inputImage.extent.origin.y, z: inputImage.extent.size.width, w: inputImage.extent.size.height)
        
        guard let filter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: extentVector]) else { return nil }
        guard let outputImage = filter.outputImage else { return nil }
        
        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: nil)
        context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: .RGBA8, colorSpace: nil)
        
        return UIColor(red: CGFloat(bitmap[0]) / 255, green: CGFloat(bitmap[1]) / 255, blue: CGFloat(bitmap[2]) / 255, alpha: CGFloat(bitmap[3]) / 255)
    }
}

extension UIImage {
    var colors: [UIColor]? {
        var colors = [UIColor]()
        let width = Int(size.width)
        let height = Int(size.height)
        
        for x in 0..<width {
            for y in 0..<height {
                if let color = self[x,y] {
                    colors.append(color)
                }
            }
        }
        
        return colors
    }
}


