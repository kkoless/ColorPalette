//
//  Profile.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 31.12.2022.
//

import Foundation


struct Profile {
    let email: String
    let role: Role
    let accessTokenData: TokenData
}

struct TokenData {
    let access_token: String
    let expire_time: String
}

enum Role {
    case free
    case paid
    
    var boolValue: Bool {
        switch self {
            case .free: return false
            case .paid: return true
        }
    }
    
    var title: Strings {
        switch self {
            case .free: return .freePlan
            case .paid: return .paidPlan
        }
    }
}
