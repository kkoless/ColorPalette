//
//  GoogleSearchAPI.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 25.03.2023.
//

import Foundation
import Moya

enum GoogleSearchAPI {
    case search(dominantColor: AppColor)
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
        
        switch self {
            case .search(let dominantColor):
                params["key"] = Consts.API.googleSearchAPIKey
                params["cx"] = "549275d6ab61f4ead"
                params["q"] = "\(dominantColor.uiColor.accessibilityName.capitalized) color aesthetics"
                params["imgColorType"] = "color"
                params["imgType"] = "photo"
                params["imgSize"] = "xxlarge"
                params["num"] = 10
                params["siteSearch"] = "https://ru.pinterest.com/"
                params["siteSearchFilter"] = "i"
//                params["imgDominantColor"] = dominantColor.googleDominantColor.rawValue
                return .requestParameters(parameters: params, encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        nil
    }
}
