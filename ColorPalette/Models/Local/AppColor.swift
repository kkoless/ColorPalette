//
//  AppColor.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 23.12.2022.
//

import Foundation
import UIKit
import SwiftUI

struct AppColor: Identifiable {
    let name: String
    let hex: String
    let alpha: CGFloat
    
    var id: Int {
        self.hashValue
    }
    
    var uiColor: UIColor {
        return UIColor(self)
    }
    
    init(name: String = "", hex: String, alpha: CGFloat = 1) {
        self.hex = hex
        self.name = name.isEmpty ? UIColor(hexString: hex, alpha: alpha).accessibilityName : name
        self.alpha = alpha
    }
}

extension AppColor: Codable {
    init(uiColor: UIColor) {
        self.name = uiColor.accessibilityName
        self.hex = uiColor.hexValue
        self.alpha = uiColor.cgColor.alpha
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.hex = try container.decode(String.self, forKey: .hex)
        self.alpha = try container.decodeIfPresent(CGFloat.self, forKey: .alpha) ?? 1.0
    }
}

extension AppColor {
    static func getRandomColor() -> AppColor {
        let uiColor = UIColor.random
        return AppColor(name: uiColor.accessibilityName, hex: uiColor.hexValue, alpha: uiColor.alphaValue)
    }
    
    static func getClear() -> AppColor {
        return AppColor(uiColor: UIColor.clear)
    }
    
    static func getPrimary() -> AppColor {
        return AppColor(uiColor: Color.primary.uiColor)
    }
}

extension AppColor {
    func generatePalette(size: UInt) -> ColorPalette {
        let appColors = self.uiColor
            .generateColorPalette(numberOfColors: size)
            .map { AppColor(uiColor: $0) }
        
        return ColorPalette(colors: appColors)
    }
    
    func getSimilarPalette() -> ColorPalette {
        let appColors = Array(self.uiColor.getSimilarColors(threshold: 0.04).prefix(4))
            .map { AppColor(uiColor: $0) }
        
        return ColorPalette(colors: appColors)
    }
}

extension AppColor: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(hex.lowercased())
        hasher.combine(name.lowercased())
        hasher.combine(alpha)
    }
    
    var hashValue: Int {
        Int(hex.lowercased().hash) + Int(alpha)
    }
    
    static func == (lhs: AppColor, rhs: AppColor) -> Bool {
        return lhs.id == rhs.id
    }
}

extension AppColor {
    func getJSON() -> [String: Any] {
        var params: [String: Any] = .init()
        params["id"] = id
        params["name"] = name
        params["hex"] = hex
        params["alpha"] = alpha
        return params
    }
}
