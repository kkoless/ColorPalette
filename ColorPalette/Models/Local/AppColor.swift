//
//  AppColor.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 23.12.2022.
//

import Foundation
import UIKit

struct AppColor: Identifiable {
    let id: UUID
    var name: String
    let hex: String
    
    static func getRandomColor() -> AppColor {
        let uiColor = UIColor.random
        return AppColor(name: uiColor.accessibilityName, hex: uiColor.hexValue)
    }
    
    static func getClear() -> AppColor {
        return AppColor(uiColor: UIColor.clear)
    }
}

extension AppColor: Codable {
    init(name: String, hex: String) {
        self.id = .init()
        self.hex = hex
        
        if name.isEmpty {
            let uiColor = UIColor(hexString: hex)
            self.name = uiColor.accessibilityName
        } else {
            self.name = name
        }
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

extension AppColor: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(hex.lowercased())
        hasher.combine(name.lowercased())
        hasher.combine(id)
    }
    
    static func == (lhs: AppColor, rhs: AppColor) -> Bool {
        return lhs.hex.lowercased() == lhs.hex.lowercased() &&
                lhs.name.lowercased() == rhs.name.lowercased() &&
                lhs.id == rhs.id
    }
}
