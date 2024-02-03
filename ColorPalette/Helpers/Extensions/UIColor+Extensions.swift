//
//  UIColor+Extensions.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 21.12.2022.
//

import Foundation
import SwiftUI
import UIKit

typealias RGBA = (red: Int, green: Int, blue: Int, alpha: Int)

extension Color {
  init(_ appColor: AppColor) {
    self.init(uiColor: UIColor(appColor))
  }

  var uiColor: UIColor {
    return UIColor(self)
  }

  static var systemCustomBackground: Color {
    .init(.systemCustomBackground)
  }

  static var invertedSystemCustomBackground: Color {
    .init(.invertedSystemCustomBackground)
  }
}

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

  convenience init(_ appColor: AppColor) {
    self.init(hexString: appColor.hex, alpha: appColor.alpha)
  }
}

extension UIColor {
  static var systemCustomBackground: UIColor { .init(named: "systemBackground")! }
  static var invertedSystemCustomBackground: UIColor { .init(named: "invertedSystemBackground")! }
  static var onboardingColor1: UIColor { .init(named: "onboardingColor1")! }
  static var onboardingColor2: UIColor { .init(named: "onboardingColor2")! }
  static var onboardingColor3: UIColor { .init(named: "onboardingColor3")! }
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

  var alphaValue: CGFloat {
    return self.cgColor.alpha.rounded(toDecimalPlaces: 2)
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
  func add(hue: CGFloat = 0, saturation: CGFloat = 0, brightness: CGFloat = 0, alpha: CGFloat = 1) -> UIColor {
    var (oldHue, oldSat, oldBright, oldAlpha): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
    getHue(&oldHue, saturation: &oldSat, brightness: &oldBright, alpha: &oldAlpha)

    // make sure new values doesn't overflow
    var newHue = oldHue + (hue / 180)
    while newHue < 0.0 { newHue += 1.0 }
    while newHue > 1.0 { newHue -= 1.0 }

    let newSat: CGFloat = max(min(oldSat + (saturation / 100.0), 1.0), 0.0)
    let newBright: CGFloat = max(min(oldBright + (brightness / 100.0), 1.0), 0.0)

    return UIColor(hue: newHue, saturation: newSat, brightness: newBright, alpha: alpha)
  }
}

extension UIColor {
  func rgbDescription(isExtended: Bool = false) -> String {
    return isExtended
    ? "R: \(Int(redValue))\nG: \(Int(greenValue))\nB: \(Int(blueValue))\nA \(alphaValue)"
    : "R:\(Int(redValue)) G:\(Int(greenValue)) B:\(Int(blueValue)) A:\(alphaValue)"
  }

  func hsbDescription(isExtended: Bool = false) -> String {
    let h = hsvValue.h.rounded(toDecimalPlaces: 1)
    let s = hsvValue.s.rounded(toDecimalPlaces: 1)
    let v = hsvValue.v.rounded(toDecimalPlaces: 1)
    return isExtended ? "H: \(h)°\nS: \(s)%\nB: \(v)%" : "H:\(h)° S:\(s)% B:\(v)%"
  }

  func cmykDescription(isExtended: Bool = false) -> String {
    let cmyk = cmyk(r: redValue, g: greenValue, b: blueValue)
    return isExtended ? "C: \(cmyk.c)%\nM: \(cmyk.m)%\nY: \(cmyk.y)%\nK: \(cmyk.k)%" : "C:\(cmyk.c)% M:\(cmyk.m)% Y:\(cmyk.y)% K:\(cmyk.k)%"
  }
}

extension UIColor {
  func getRGBCopyInfo() -> String {
    return "\(Int(redValue)), \(Int(greenValue)), \(Int(blueValue)), \(alphaValue)"
  }

  func getHSBCopyInfo() -> String {
    return "\(hsvValue.h.rounded(toDecimalPlaces: 1)), \(hsvValue.s.rounded(toDecimalPlaces: 1)), \(hsvValue.v.rounded(toDecimalPlaces: 1))"
  }

  func getCMYKCopyInfo() -> String {
    let cmyk = cmyk(r: redValue, g: greenValue, b: blueValue)
    return "\(cmyk.c), \(cmyk.m), \(cmyk.y), \(cmyk.k)"
  }
}

extension UIColor {
  func invertColor() -> UIColor {
    if (redValue * 0.299 + greenValue * 0.587 + blueValue * 0.114) > 186 {
      return UIColor(hexString: "#000000")
    } else {
      return UIColor(hexString: "#FFFFFF")
    }
  }
}

extension UIColor {
  func getTypeInfo(type: ColorType, isExtended: Bool) -> String {
    switch type {
    case .HEX: return self.hexValue
    case .RGB: return self.rgbDescription(isExtended: isExtended)
    case .HSB: return self.hsbDescription(isExtended: isExtended)
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

extension UIColor {

  /// Returns the color simulated to appear as though viewed by an individual afflicted with a specified type of color blindness.
  ///
  /// - Parameter type: The type of colorblindness for which to simulate the color.
  /// - Returns: The color simulated to appear as though viewed by an individual afflicted with a specified type of color blindness.
  func inclusiveColor(for type: InclusiveColor.BlindnessType) -> UIColor {
    let inclusiveColor = InclusiveColor()
    guard let color = rgba() else { fatalError("Attempted to simulate the appearance of an unspecified color.") }

    switch type {
    case .normal:
      return inclusiveColor.rgbToUIColor(rgb: color)
    case .protanopia:
      return inclusiveColor.rgbToUIColor(rgb: inclusiveColor.blindMK(rgb: color, deficiency: .protan))
    case .protanomaly:
      return inclusiveColor.rgbToUIColor(rgb: inclusiveColor.anomylize(rgb: color, adjustedRGB: (inclusiveColor.blindMK(rgb: color, deficiency: .protan))))
    case .deuteranopia:
      return inclusiveColor.rgbToUIColor(rgb: inclusiveColor.blindMK(rgb: color, deficiency: .deutan))
    case .deuteranomaly:
      return inclusiveColor.rgbToUIColor(rgb: inclusiveColor.anomylize(rgb: color, adjustedRGB: (inclusiveColor.blindMK(rgb: color, deficiency: .deutan))))
    case .tritanopia:
      return inclusiveColor.rgbToUIColor(rgb: inclusiveColor.blindMK(rgb: color, deficiency: .tritan))
    case .tritanomaly:
      return inclusiveColor.rgbToUIColor(rgb: inclusiveColor.anomylize(rgb: color, adjustedRGB: (inclusiveColor.blindMK(rgb: color, deficiency: .tritan))))
    case .achromatopsia:
      return inclusiveColor.rgbToUIColor(rgb: inclusiveColor.monochrome(rgb: color))
    case .achromatomaly:
      return inclusiveColor.rgbToUIColor(rgb: inclusiveColor.anomylize(rgb: color, adjustedRGB: (inclusiveColor.monochrome(rgb: color))))
    }
  }

  func rgba() -> RGBA? {
    var redLiteral = CGFloat(0.0), greenLiteral = CGFloat(0.0), blueLiteral = CGFloat(0.0), alphaLiteral = CGFloat(0.0)

    guard getRed(&redLiteral, green: &greenLiteral, blue: &blueLiteral, alpha: &alphaLiteral) else { assertionFailure("Could not extract RGBA components"); return nil }

    return (red: Int(redLiteral * 255), green: Int(greenLiteral * 255), blue: Int(blueLiteral * 255), alpha: Int(alphaLiteral) * 255)
  }
}

extension UIColor {
  func hsb() -> (hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat) {
    var hue: CGFloat = 0
    var saturation: CGFloat = 0
    var brightness: CGFloat = 0
    var alpha: CGFloat = 0.0

    getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)

    return (hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
  }

  func getSimilarColors(threshold: CGFloat) -> [UIColor] {
    let referenceHSB = self.hsb()
    var similarColors = [UIColor]()

    let minHue = referenceHSB.hue - threshold
    let maxHue = referenceHSB.hue + threshold

    let minSaturation = max(0, referenceHSB.saturation - threshold)
    let maxSaturation = min(1, referenceHSB.saturation + threshold)
    let minBrightness = max(0, referenceHSB.brightness - threshold)
    let maxBrightness = min(1, referenceHSB.brightness + threshold)

    for hue in stride(from: minHue, through: maxHue, by: threshold / 2) {
      for saturation in stride(from: minSaturation, through: maxSaturation, by: threshold / 2) {
        for brightness in stride(from: minBrightness, through: maxBrightness, by: threshold / 2) {
          let color = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
          similarColors.append(color)
        }
      }
    }

    return Array(similarColors.prefix(10))
  }

  func generateColorPalette(numberOfColors: UInt) -> [UIColor] {
    let baseComponents = self.hsb()

    var colors: [UIColor] = [self]

    for _ in 0 ..< numberOfColors - 1 {
      let newHue = baseComponents.hue + CGFloat.random(in: -0.2...0.2)
      let newSaturation = baseComponents.saturation + CGFloat.random(in: -0.2...0.2)
      let newBrightness = baseComponents.brightness + CGFloat.random(in: -0.2...0.2)
      let newColor = UIColor(hue: newHue, saturation: newSaturation, brightness: newBrightness, alpha: baseComponents.alpha)

      colors.append(newColor)
    }

    return colors
  }
}
