//
//  Color+Extensions.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 21.12.2022.
//

import Foundation
import SwiftUI
import UIKit

extension UIColor {
    static var random: UIColor {
        return UIColor(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1),
            alpha: 1.0
        )
    }
}

extension UIColor {
    var hexValue: String {
        var color = self
        
        if color.cgColor.numberOfComponents < 4 {
            let c = color.cgColor.components!
            color = UIColor(red: c[0], green: c[0], blue: c[0], alpha: c[1])
        }
        if color.cgColor.colorSpace!.model != .rgb {
            return "#FFFFFF"
        }
        let c = color.cgColor.components!
        return String(format: "#%02X%02X%02X", Int(c[0]*255.0), Int(c[1]*255.0), Int(c[2]*255.0))
    }
    
    var hsbValue: (h: CGFloat, s: CGFloat, b: CGFloat, a: CGFloat) {
        var hsba: (h: CGFloat, s: CGFloat, b: CGFloat, a: CGFloat) = (0, 0, 0, 0)
        self.getHue(&(hsba.h), saturation: &(hsba.s), brightness: &(hsba.b), alpha: &(hsba.a))
        return hsba
      }
}

extension UIColor {
    func colorComponentsByMatchingToColorSpace(colorSpace: CGColorSpace?) -> (c: CGFloat, m: CGFloat, y: CGFloat, k: CGFloat) {
        guard let colorSpace = colorSpace else { fatalError("Couldn't get ColorSpace")  }
        let intent = CGColorRenderingIntent.perceptual
        guard let cmykColor = self.cgColor.converted(to: colorSpace, intent: intent, options: nil) else { fatalError("Couldn't convert color to CMYK.") }
        let c: CGFloat = (cmykColor.components?[0] ?? 0) * 100
        let m: CGFloat = (cmykColor.components?[1] ?? 0) * 100
        let y: CGFloat = (cmykColor.components?[2] ?? 0) * 100
        let k: CGFloat = (cmykColor.components?[3] ?? 0) * 100
        return (c,m,y,k)
    }
}

extension UIColor {
    func rgbDescription() -> String {
        let r = String(format: "%.2f", self.cgColor.components?[0] ?? 0.0)
        let g = String(format: "%.2f", self.cgColor.components?[1] ?? 0.0)
        let b = String(format: "%.2f", self.cgColor.components?[2] ?? 0.0)
        return "R: \(r)\nG: \(g)\nB: \(b)"
    }
    
    func hsbDescription() -> String {
        let h = String(format: "%.2f", self.hsbValue.h)
        let s = String(format: "%.2f", self.hsbValue.s)
        let b = String(format: "%.2f", self.hsbValue.b)
        return "H: \(h)\nS: \(s)\nB: \(b)"
    }
    
    func cmykDescription() -> String {
        let cmyk = self.colorComponentsByMatchingToColorSpace(colorSpace: self.cgColor.colorSpace)
        let c = String(format: "%.2f", cmyk.c)
        let m = String(format: "%.2f", cmyk.m)
        let y = String(format: "%.2f", cmyk.y)
        let k = String(format: "%.2f", cmyk.k)
        return "C: \(c)\nM: \(m)\nY: \(y)\nK: \(k)"
    }
}


extension Color: Identifiable {
    public var id: Int {
        return self.hashValue
    }
}

extension UIColor: Identifiable {
    public var id: Int {
        return self.hashValue
    }
}
