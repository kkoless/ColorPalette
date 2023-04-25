//
//  Profile.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 31.12.2022.
//

import Foundation


struct Profile: Equatable {
    let email: String
    let role: Role
    let accessTokenData: TokenData
    
    static func == (lhs: Profile, rhs: Profile) -> Bool {
        lhs.email == rhs.email && lhs.accessTokenData.access_token == rhs.accessTokenData.access_token
    }
    
    static func getEmptyProfile() -> Profile {
        Profile(email: "", role: .free, accessTokenData: TokenData.getEmptyTokenData())
    }
}

struct TokenData: Equatable {
    let access_token: String
    let expire_time: String
    
    static func getEmptyTokenData() -> TokenData {
        TokenData(access_token: "", expire_time: "")
    }
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
