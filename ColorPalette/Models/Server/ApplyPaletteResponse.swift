//
//  ApplyPaletteResponse.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 19.05.2023.
//

import Foundation

struct ApplyPaletteResponse: Codable {
    let imgData: Data?
    let fromColors: [[Int]]?
    
    enum CodingKeys: String, CodingKey {
        case imgData = "image_data"
        case fromColors = "from_colors"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.imgData = try container.decode(Data.self, forKey: .imgData)
        self.fromColors = try container.decode([[Int]].self, forKey: .fromColors)
    }
}
