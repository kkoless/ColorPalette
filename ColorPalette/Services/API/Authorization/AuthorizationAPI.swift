//
//  AuthorizationAPI.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 01.12.2022.
//

import Foundation
import Moya

enum AuthorizationAPI {
    case login(email: String, password: String)
    case register(email: String, password: String)
    case fetchUser
}

extension AuthorizationAPI: TargetType {
    var baseURL: URL {
        Consts.API.baseUrl
    }
    
    var path: String {
        switch self {
            case .login:
                return "/user/login"
            case .register:
                return "/user/signup"
            case .fetchUser:
                return "/user"
        }
    }
    
    var method: Moya.Method {
        switch self {
            case .login, .register:
                return .post
            case .fetchUser:
                return .get
        }
    }
    
    var task: Moya.Task {
        var params = [String: Any]()
        switch self {
            case let .login(email: email, password: password):
                params["email"] = email
                params["password"] = password
                return .requestParameters(parameters: params, encoding: JSONEncoding.default)
                
            case let .register(email: email, password: password):
                params["email"] = email
                params["password"] = password
                return .requestParameters(parameters: params, encoding: JSONEncoding.default)
            case .fetchUser:
                return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        var params: [String: String] = .init()
        
        switch self {
            case .fetchUser:
                if let token = CredentialsManager.shared.token, !token.isEmpty {
                    params[Consts.API.tokenHeader] = "Bearer \(token)"
                }
            default:
                return params
        }
        
        return params
    }
}
