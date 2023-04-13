//
//  ColorPalette.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 22.12.2022.
//

import Foundation
import UIKit

struct PopularPaletteJSON: Codable {
    let data: [PopularPalette]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.data = try container.decode([PopularPalette].self, forKey: .data)
    }
    
    struct PopularPalette: Codable, Hashable {
        let colors: [String]
        let saves: Int
        
        var id: Int {
            hashValue
        }
        
        var colorPalette: ColorPalette {
            let colors = colors.map { AppColor(hex: "#" + $0) }
            return ColorPalette(colors: colors)
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(colors)
        }
        
        var hashValue: Int {
            colors.map { $0 }.reduce("", +).hash
        }
        
        static func == (lhs: PopularPalette, rhs: PopularPalette) -> Bool {
            return lhs.id == rhs.id
        }
    }
}

struct ColorPalette: Identifiable {
    let colors: [AppColor]
    
    var id: Int {
        self.hashValue
    }
}

extension ColorPalette {
    private func calculateColorBalance() -> CGFloat {
        let colors = self.colors.map { $0.uiColor }
        
        var rSum: CGFloat = 0.0
        var gSum: CGFloat = 0.0
        var bSum: CGFloat = 0.0
        
        for color in colors {
            var r: CGFloat = 0.0
            var g: CGFloat = 0.0
            var b: CGFloat = 0.0
            var a: CGFloat = 0.0
            
            color.getRed(&r, green: &g, blue: &b, alpha: &a)
            rSum += r
            gSum += g
            bSum += b
        }
        
        let rAvg = rSum / CGFloat(colors.count)
        let gAvg = gSum / CGFloat(colors.count)
        let bAvg = bSum / CGFloat(colors.count)
        
        let balance = (rAvg + gAvg + bAvg) / 3.0
        
        return balance
    }
    
    func adjustColorBalance() -> ColorPalette {
        let uiColors = self.colors.map { $0.uiColor }
        let balance = calculateColorBalance()
        
        if balance == 0.5 {
            return ColorPalette(colors: self.colors)
        }
        
        var adjustedColors: [UIColor] = []
        
        for color in uiColors {
            var r: CGFloat = 0.0
            var g: CGFloat = 0.0
            var b: CGFloat = 0.0
            var a: CGFloat = 0.0
            
            color.getRed(&r, green: &g, blue: &b, alpha: &a)
            
            let newR = r + (0.5 - balance)
            let newG = g + (0.5 - balance)
            let newB = b + (0.5 - balance)
            
            let adjustedColor = UIColor(red: newR, green: newG, blue: newB, alpha: a)
            adjustedColors.append(adjustedColor)
        }
        
        let appColors = adjustedColors.map { AppColor(uiColor: $0) }
        let palette = ColorPalette(colors: appColors)
        
        return palette
    }
}

extension ColorPalette {
    static func getTestPalettes(_ size: UInt) -> [ColorPalette] {
        var result = [ColorPalette]()
        
        for _ in 0...size {
            result.append(ColorPalette(colors: [
                AppColor.getRandomColor(),
                AppColor.getRandomColor(),
                AppColor.getRandomColor(),
                AppColor.getRandomColor()]
                                      ))
        }
        
        return result
    }
    
    static func getRandomPalette(size: UInt) -> ColorPalette {
        let randomUIColor = AppColor.getRandomColor().uiColor
        let appColors = randomUIColor.generateColorPalette(numberOfColors: size).map { AppColor(uiColor: $0) }
        return ColorPalette(colors: appColors)
    }
}

extension ColorPalette: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(colors)
    }
    
    var hashValue: Int {
        colors.map { $0.hex }.reduce("", +).hash
    }
    
    static func == (lhs: ColorPalette, rhs: ColorPalette) -> Bool {
        return lhs.id == rhs.id
    }
}

extension ColorPalette: Codable {
    func getData() -> Data {
        do { return try JSONEncoder().encode(colors) }
        catch {
            print("Unable to encode \(error)")
            return Data()
        }
    }
    
    func getJSON() -> [String: Any] {
        var params: [String: Any] = .init()
        params["id"] = id
        params["colors"] = colors.map { $0.getJSON() }
        return params
    }
}

