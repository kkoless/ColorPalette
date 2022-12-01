//
//  AuthorizationAPI.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 01.12.2022.
//

import Foundation
import Moya

enum AuthorizationAPI {
    case login
    case register
}

extension AuthorizationAPI: TargetType {
    var baseURL: URL {
        Consts.API.baseUrl
    }
    
    var path: String {
        switch self {
            case .login:
                return ""
            case .register:
                return ""
        }
    }
    
    var method: Moya.Method {
        switch self {
            case .login, .register:
                return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
            case .login, .register:
                return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        var dict = [String: String]()
        return dict
    }
}
