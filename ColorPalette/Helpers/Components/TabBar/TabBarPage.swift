//
//  TabBarPage.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 30.11.2022.
//

enum TabBarPage: Int, CaseIterable {
    case general
    case profile
    
    var iconName: String {
        switch self {
            case .general:
                return "house"
            case .profile:
                return "person"
        }
    }
    
    var title: String {
        switch self {
            case .general:
                return "General"
            case .profile:
                return "Profile"
        }
    }
}
