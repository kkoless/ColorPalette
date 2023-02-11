//
//  ServerLoginModel.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 06.02.2023.
//

import Foundation


struct ServerProfileModel: Codable {
    let email: String?
    let role: Bool?
    let tokenData: ServerTokenData?
    
    static func getNullObj() -> ServerProfileModel {
        ServerProfileModel(email: nil, role: nil, tokenData: nil)
    }
}

struct ServerTokenData: Codable {
    let access_token: String?
    let expire_time: String?
    
    static func getNullObj() -> ServerTokenData {
        ServerTokenData(access_token: nil, expire_time: nil)
    }
}
