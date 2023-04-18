//
//  GoogleSearchRequest.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 25.03.2023.
//

import Foundation

struct GoogleSearchRequest {
    enum ColorType: String, Codable {
        case imgColorTypeUndefined
        case mono, gray, color, trans
    }
    
    enum DominantColor: String, Codable, CaseIterable {
        case imgDominantColorUndefined
        case black, blue, brown, gray, green,
             orange, pink, purple, red, teal, white, yellow
    }
    
    enum ImageSize: String, Codable {
        case imgSizeUndefined
        case HUGE, ICON, LARGE, MEDIUM,
             SMALL, XLARGE, XXLARGE
    }
    
    enum ImageType: String, Codable {
        case imgTypeUndefined
        case clipart, face, lineart,
             stock, photo, animated
    }
    
    enum SearchType: String, Codable {
        case searchTypeUndefined
        case image
    }
}
