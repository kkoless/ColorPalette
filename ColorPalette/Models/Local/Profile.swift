//
//  Profile.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 31.12.2022.
//

import Foundation


struct Profile {
    let username: String
    var isFree: Bool
    
    var role: String {
        switch isFree {
            case true: return "FREE"
            case false: return "PAID"
        }
    }
    
    mutating func changeRole() {
        self.isFree.toggle()
    }
}
