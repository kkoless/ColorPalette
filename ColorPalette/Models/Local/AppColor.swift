//
//  AppColor.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 23.12.2022.
//

import Foundation
import UIKit

struct AppColor: Codable, Identifiable, Hashable {
    let id: UUID
    let name: String
    let hex: String
    
    init(name: String, hex: String) {
        self.id = .init()
        self.name = name
        self.hex = hex
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(hex.lowercased())
        hasher.combine(name.lowercased())
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = .init()
        self.name = try container.decode(String.self, forKey: .name)
        self.hex = try container.decode(String.self, forKey: .hex)
    }
    
    static func getRandomColor() -> AppColor {
        let uiColor = UIColor.random
        return AppColor(name: uiColor.accessibilityName, hex: uiColor.hexValue)
    }
}

extension AppColor {
    static func == (lhs: AppColor, rhs: AppColor) -> Bool {
        return lhs.hex.lowercased() == lhs.hex.lowercased() &&
                lhs.name.lowercased() == rhs.name.lowercased()
    }
}
