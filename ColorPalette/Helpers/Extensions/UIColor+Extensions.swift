//
//  UIColor+Extensions.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 21.12.2022.
//

import Foundation
import SwiftUI
import UIKit

extension UIColor {
    convenience init(hex: UInt, alpha: CGFloat = 1) {
        self.init(
            red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(hex & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
    
    convenience init(hexString: String, alpha: CGFloat = 1) {
        let chars = Array(hexString.dropFirst())
        self.init(red: .init(strtoul(String(chars[0...1]), nil, 16)) / 255,
                  green: .init(strtoul(String(chars[2...3]), nil, 16)) / 255,
                  blue: .init(strtoul(String(chars[4...5]), nil, 16)) / 255,
                  alpha: alpha)
        
    }
}

extension UIColor {
    func hsv(r: CGFloat, g: CGFloat, b: CGFloat) -> (h: CGFloat, s: CGFloat, v: CGFloat) {
        let min = min(min(r, g), b)
        let max = max(max(r, g), b)
        
        var v = max
        let delta = max - min
        
        guard delta > 0.00001 else { return (h: 0, s: 0, v: max) }
        guard max > 0 else { return (h: -1, s: 0, v: v) } // Undefined, achromatic grey
        let s = (delta / max) * 100 // In percents
        
        let hue: (CGFloat, CGFloat) -> CGFloat = { max, delta -> CGFloat in
            if r == max { return (g - b) / delta } // Between yellow & magenta
            else if g == max { return 2 + (b - r) / delta } // Between cyan & yellow
            else { return 4 + (r - g) / delta } // Between magenta & cyan
        }
        
        let h = hue(max, delta) * 60 // In degrees
        v = v / 255 * 100 // In percents
        
        return (h: (h < 0 ? h + 360 : h) , s: s, v: v)
    }
    
    func cmyk(r: CGFloat, g: CGFloat, b: CGFloat) -> (c: Int, m: Int, y: Int, k: Int) {
        var redC: CGFloat, greenC: CGFloat, blueC: CGFloat
        
        if (0...255 ~= r) { redC = (r / 255) * 100 }
        else { fatalError("Value is not between 0 and 255") }
        
        if (0...255 ~= g) { greenC = (g / 255) * 100 }
        else { fatalError("Value is not between 0 and 255") }
        
        if (0...255 ~= b) { blueC = (b / 255) * 100 }
        else { fatalError("Value is not between 0 and 255") }
        
        //k will be the largest value of either redC, greenC, or blueC.
        let k = 100 - max(max(redC, greenC), blueC)
        let kInt: Int
        
        if k == 100 {
            return (c: 0, m: 0, y: 0, k: 100)
        } else {
            kInt = Int(round(k))
        }
        
        let c = Int(round((100 - redC - k) / (100 - k) * 100))
        let m = Int(round((100 - greenC - k) / (100 - k) * 100))
        let y = Int(round((100 - blueC - k) / (100 - k) * 100))
        
        return (c: c, m: m, y: y, k: kInt)
    }
}

extension UIColor {
    var redValue: CGFloat {
        return (CIColor(color: self).red.rounded(toDecimalPlaces: 3) * 255).rounded()
    }
    
    var greenValue: CGFloat {
        return (CIColor(color: self).green.rounded(toDecimalPlaces: 3) * 255).rounded()
    }
    var blueValue: CGFloat {
        return (CIColor(color: self).blue.rounded(toDecimalPlaces: 3) * 255).rounded()
    }
    
    var hsvValue: (h: CGFloat, s: CGFloat, v: CGFloat) {
        return hsv(r: redValue, g: greenValue, b: blueValue)
    }
    
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
}

extension UIColor {
    var complement: UIColor {
        return self.withHueOffset(offset: 0.5)
    }
    
    func getSplitComplementColors() -> [UIColor] {
        return [self.withHueOffset(offset: 150 / 360),
                self.withHueOffset(offset: 210 / 360)]
    }
    
    func getTriadicColors() -> [UIColor] {
        return [self.withHueOffset(offset: 120 / 360),
                self.withHueOffset(offset: 240 / 360)]
    }
    
    func getTetradicColors() -> [UIColor] {
        return [self.withHueOffset(offset: 0.25),
                self.complement,
                self.withHueOffset(offset: 0.75)]
    }
    
    func getAnalagousColors() -> [UIColor] {
        return [self.withHueOffset(offset: -1 / 12),
                self.withHueOffset(offset: 1 / 12)]
    }
    
    private func withHueOffset(offset: CGFloat) -> UIColor {
        var h: CGFloat = 0
        var s: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        self.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return UIColor(hue: fmod(h + offset, 1), saturation: s, brightness: b, alpha: a)
    }
}

extension UIColor {
    func rgbDescription(isExtended: Bool = false) -> String {
        return isExtended ? "R: \(Int(redValue))\nG: \(Int(greenValue))\nB: \(Int(blueValue))" : "R:\(Int(redValue)) G:\(Int(greenValue)) B:\(Int(blueValue))"
    }
    
    func hsvDescription(isExtended: Bool = false) -> String {
        let h = hsvValue.h.rounded(toDecimalPlaces: 1)
        let s = hsvValue.s.rounded(toDecimalPlaces: 1)
        let v = hsvValue.v.rounded(toDecimalPlaces: 1)
        return isExtended ? "H: \(h)°\nS: \(s)%\nV: \(v)%" : "H:\(h)° S:\(s)% V:\(v)%"
    }
    
    func cmykDescription(isExtended: Bool = false) -> String {
        let cmyk = cmyk(r: redValue, g: greenValue, b: blueValue)
        return isExtended ? "C: \(cmyk.c)%\nM: \(cmyk.m)%\nY: \(cmyk.y)%\nK: \(cmyk.k)%" : "C:\(cmyk.c)% M:\(cmyk.m)% Y:\(cmyk.y)% K:\(cmyk.k)%"
    }
}

extension UIColor {
    func getTypeInfo(type: ColorType, isExtended: Bool) -> String {
        switch type {
            case .HEX: return self.hexValue
            case .RGB: return self.rgbDescription(isExtended: isExtended)
            case .HSB: return self.hsvDescription(isExtended: isExtended)
            case .CMYK: return self.cmykDescription(isExtended: isExtended)
        }
    }
}

extension UIColor: Identifiable {
    public var id: UUID {
        return .init()
    }
}

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
