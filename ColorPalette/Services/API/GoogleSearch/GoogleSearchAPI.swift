//
//  GoogleSearchAPI.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 25.03.2023.
//

import Foundation
import Moya

enum GoogleSearchAPI {
    case search
}

extension GoogleSearchAPI: TargetType {
    var baseURL: URL {
        Consts.API.googleUrl
    }
    
    var path: String {
        switch self {
            case .search: return "customsearch/v1"
        }
    }
    
    var method: Moya.Method {
        switch self {
            case .search: return .get
        }
    }
    
    var task: Moya.Task {
        var params = [String: Any]()
        params["key"] = Consts.API.googleSearchAPIKey
        params["cx"] = "549275d6ab61f4ead"
        params["q"] = ""
        
        switch self {
            case .search:
            
                
                
                return .requestCompositeParameters(bodyParameters: [:],
                                                   bodyEncoding: JSONEncoding.default,
                                                   urlParameters: params)
        }
    }
    
    var headers: [String : String]? {
        var params: [String: String] = .init()
        
        if let token = CredentialsManager.shared.token, !token.isEmpty {
            params[Consts.API.tokenHeader] = "Bearer \(token)"
        }
        
        return params
    }
}
