//
//  GeneralAPI.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 21.04.2023.
//

import Foundation
import Moya

enum GeneralAPI {
    case colorsReplace(imageData: Data, palette: ColorPalette)
}

extension GeneralAPI: TargetType {
    var baseURL: URL {
        Consts.API.baseUrl
    }
    
    var path: String {
        switch self {
            case .colorsReplace:
                return "/colorsReplace"
        }
    }
    
    var method: Moya.Method {
        switch self {
            case .colorsReplace:
                return .post
        }
    }
    
    var task: Moya.Task {
        let jsonEncoder = JSONEncoder()
        
        switch self {
            case let .colorsReplace(imageData: imageData, palette: palette):
                var formData = [MultipartFormData]()
                
                print(palette.getJSON())
                
                formData
                    .append(MultipartFormData(provider: .data(imageData), name: "file", fileName: "image.jpg", mimeType: "image/jpeg"))
                
                if let jsonData = try? jsonEncoder.encode(palette) {
                    formData
                        .append(MultipartFormData(provider: .data(jsonData), name: "palette", fileName: "", mimeType: "application/json"))
                }
                
                return .uploadMultipart(formData)
        }
    }
    
    var headers: [String : String]? {
        nil
    }
}
