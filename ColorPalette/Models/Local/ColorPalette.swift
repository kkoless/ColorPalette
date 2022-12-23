//
//  ColorPalette.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 22.12.2022.
//

import Foundation

struct ColorPalette: Identifiable {
    let id: UUID = .init()
    let colors: [Color]
    
    struct Color: Identifiable, Hashable {
        var id: Int { return hashValue }
        let r: CGFloat
        let g: CGFloat
        let b: CGFloat
        let alpha: CGFloat
        
        init(r: CGFloat?, g: CGFloat?, b: CGFloat?, alpha: CGFloat?) {
            self.r = r ?? 0.0
            self.g = g ?? 0.0
            self.b = b ?? 0.0
            self.alpha = alpha ?? 1.0
        }
        
        static var random: Self {
            return Color(
                r: .random(in: 0...1),
                g: .random(in: 0...1),
                b: .random(in: 0...1),
                alpha: 1.0
            )
        }
    }
    
    static func getTestPalettes(size: UInt) -> [Self] {
        var result: [Self] = []
        for i in 0...size - 1 {
            result.append(
                ColorPalette(colors: [Color.random, Color.random, Color.random])
            )
        }
        
        return result
    }
}
