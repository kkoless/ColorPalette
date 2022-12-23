//
//  AppColor.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 23.12.2022.
//

import Foundation

struct AppColor: Codable, Identifiable {
    let id: UUID
    let name: String
    let hex: String
    
    init(name: String, hex: String) {
        self.id = .init()
        self.name = name
        self.hex = hex
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = .init()
        self.name = try container.decode(String.self, forKey: .name)
        self.hex = try container.decode(String.self, forKey: .hex)
    }
    
    static func getTestColors() -> [AppColor] {
        return [
            AppColor(name: "African Violet", hex: "#B284BE"),
            AppColor(name: "Alabama Crimson", hex: "#AF002A"),
            AppColor(name: "Buff", hex: "#F0DC82"),
            AppColor(name: "Mustard", hex: "#FFDB58")
        ]
    }
}
