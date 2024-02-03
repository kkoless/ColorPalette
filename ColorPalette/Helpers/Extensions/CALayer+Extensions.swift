//
//  CALayer+Extensions.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 12.11.2022.
//

import Foundation
import UIKit

extension CALayer {
  func pickColor(at position: CGPoint) -> UIColor? {
    // Used to store target pixel values
    var pixel = [UInt8](repeatElement(0, count: 4))
    // The color space is RGB, which determines whether the encoding of the output color is RGB or something else (such as YUV).
    let colorSpace = CGColorSpaceCreateDeviceRGB()
    // Set the bitmap color distribution to RGBA
    let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue

    guard let context = CGContext(data: &pixel, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: bitmapInfo) else { return nil }
    // Set context origin offset to all coordinates of the target position.
    context.translateBy(x: -position.x, y: -position.y)
    // Render images into context
    render(in: context)

    return UIColor(
      red: CGFloat(pixel[0]) / 255.0,
      green: CGFloat(pixel[1]) / 255.0,
      blue: CGFloat(pixel[2]) / 255.0,
      alpha: CGFloat(pixel[3]) / 255.0
    )
  }
}
