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
      let startIndexes: [UInt] = [1, 11, 22, 33]
      var googleDominantColor: GoogleSearchRequest.DominantColor = .imgDominantColorUndefined

      params["key"] = Consts.API.googleSearchAPIKey
      params["cx"] = "549275d6ab61f4ead"
      params["imgColorType"] = GoogleSearchRequest.ColorType.color.rawValue
      params["imgType"] = GoogleSearchRequest.ImageType.photo.rawValue
      params["imgSize"] = GoogleSearchRequest.ImageSize.XXLARGE.rawValue
      params["siteSearch"] = "https://ru.pinterest.com/"
      params["siteSearchFilter"] = "i"
      params["start"] = startIndexes.randomElement() ?? 1

      GoogleSearchRequest.DominantColor.allCases.forEach { googleColor in
        if dominantColor.name.lowercased().contains(googleColor.rawValue) {
          googleDominantColor = googleColor
          print(googleColor.rawValue)
        }
      }

      if googleDominantColor == .imgDominantColorUndefined {
        params["q"] = "\(dominantColor.uiColor.accessibilityName.capitalized) aesthetics"
      } else {
        params["q"] = "\(googleDominantColor.rawValue) color aesthetics"
        params["imgDominantColor"] = googleDominantColor.rawValue
      }

      return .requestParameters(parameters: params, encoding: URLEncoding.default)
    }
  }

  var headers: [String : String]? {
    nil
  }
}
