//
//  SocialNetwork.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 17.02.2023.
//

import SwiftUI

enum SocialNetwork: CaseIterable, Identifiable {
    case vk
    case instagram
    
    var id: Int {
        switch self {
            case .vk: return 0
            case .instagram: return 1
        }
    }
    
    var iconName: String {
        switch self {
            case .vk: return "vk"
            case .instagram: return "instagram"
        }
    }
    
    var iconSize: (CGFloat, CGFloat) {
        switch self {
            case .vk: return (22.0, 13.0)
            case .instagram: return (18.0, 18.0)
        }
    }
    
    var title: String {
        switch self {
            case .vk: return "VK"
            case .instagram: return "Instagram"
        }
    }
    
    var foregroundColor: Color {
        switch self {
            case .vk: return .blue
            case .instagram: return .orange
        }
    }
}
