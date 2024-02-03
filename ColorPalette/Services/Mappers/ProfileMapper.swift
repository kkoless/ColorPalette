//
//  ProfileMapper.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 08.02.2023.
//

import Foundation

final class ProfileMapper {
  static func toLocal(from: ServerProfileModel) -> Profile {
    let email = from.email ?? ""
    let role: Role = (from.role ?? false) ? .paid : .free
    let tokenData = TokenMapper.toLocal(from: from.tokenData ?? ServerTokenData.getNullObj())
    
    return Profile(email: email, role: role, accessTokenData: tokenData)
  }
}

final class TokenMapper {
  static func toLocal(from: ServerTokenData) -> TokenData {
    TokenData(
      access_token: from.access_token ?? "",
      expire_time: from.expire_time ?? ""
    )
  }
}
