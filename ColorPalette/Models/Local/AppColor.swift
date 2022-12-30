//
//  AppColor.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 23.12.2022.
//

import Foundation
import UIKit

struct AppColor: Identifiable {
    let name: String
    let hex: String
    
    var id: Int {
        self.hashValue
    }
    
    var uiColor: UIColor {
        return UIColor(self)
    }
    
    init(name: String, hex: String) {
        self.hex = hex
        self.name = name.isEmpty ? UIColor(hexString: hex).accessibilityName : name
    }
}

extension AppColor: Codable {
    init(uiColor: UIColor) {
        self.name = uiColor.accessibilityName
        self.hex = uiColor.hexValue
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.hex = try container.decode(String.self, forKey: .hex)
    }
}

extension AppColor {
    static func getRandomColor() -> AppColor {
        let uiColor = UIColor.random
        return AppColor(name: uiColor.accessibilityName, hex: uiColor.hexValue)
    }
    
    static func getClear() -> AppColor {
        return AppColor(uiColor: UIColor.clear)
    }
}

extension AppColor: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(hex.lowercased())
        hasher.combine(name.lowercased())
    }
    
    static func == (lhs: AppColor, rhs: AppColor) -> Bool {
        return lhs.id == rhs.id
    }
}
