//
//  Profile.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 31.12.2022.
//

import Foundation


struct Profile {
    let username: String
    var role: Role
    
    mutating func changeRole(_ newRole: Role) {
        self.role = newRole
    }
}

extension Profile {
    enum Role {
        case free
        case paid
    }
}
