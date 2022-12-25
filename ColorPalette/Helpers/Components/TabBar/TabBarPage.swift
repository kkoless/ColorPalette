//
//  TabBarPage.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 30.11.2022.
//

enum TabBarPage: Int, CaseIterable {
    case general
    case favorites
    case profile
    
    var iconName: String {
        switch self {
            case .general:
                return "house"
            case .favorites:
                return "heart"
            case .profile:
                return "person"
        }
    }
    
    var title: String {
        switch self {
            case .general:
                return "General"
            case .favorites:
                return "Favorites"
            case .profile:
                return "Profile"
        }
    }
}
