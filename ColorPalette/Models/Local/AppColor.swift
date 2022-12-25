//
//  AppColor.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 23.12.2022.
//

import Foundation
import UIKit

struct AppColor: Codable, Identifiable {
    let id: UUID
    let name: String
    let hex: String
    
    static func getRandomColor() -> AppColor {
        let uiColor = UIColor.random
        return AppColor(name: uiColor.accessibilityName, hex: uiColor.hexValue)
    }
    
    static func getClear() -> AppColor {
        return AppColor(uiColor: UIColor.clear)
    }
}

extension AppColor {
    init(name: String, hex: String) {
        self.id = .init()
        self.name = name
        self.hex = hex
    }
    
    init(uiColor: UIColor) {
        self.id = .init()
        self.name = uiColor.accessibilityName
        self.hex = uiColor.hexValue
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = .init()
        self.name = try container.decode(String.self, forKey: .name)
        self.hex = try container.decode(String.self, forKey: .hex)
    }
}

extension AppColor {
    var uiColor: UIColor {
        return UIColor(self)
    }
}

extension AppColor {
    static func == (lhs: AppColor, rhs: AppColor) -> Bool {
        return lhs.hex.lowercased() == lhs.hex.lowercased() &&
                lhs.name.lowercased() == rhs.name.lowercased()
    }
}
