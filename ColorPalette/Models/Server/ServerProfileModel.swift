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
    
    enum CodingKeys: String, CodingKey {
        case email = "email"
        case role = "role"
        case tokenData = "token_data"
    }
    
    init(email: String?, role: Bool?, tokenData: ServerTokenData?) {
        self.email = email
        self.role = role
        self.tokenData = tokenData
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.role = try container.decodeIfPresent(Bool.self, forKey: .role)
        self.tokenData = try container.decodeIfPresent(ServerTokenData.self, forKey: .tokenData)
    }
    
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
