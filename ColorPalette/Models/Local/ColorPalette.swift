//
//  ColorPalette.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 22.12.2022.
//

import Foundation

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

