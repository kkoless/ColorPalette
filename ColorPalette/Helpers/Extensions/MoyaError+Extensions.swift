//
//  MoyaError+Extensions.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 09.02.2023.
//

import Foundation
import Moya


protocol MoyaErrorParserable {}

extension MoyaErrorParserable {
  func mapError(error: MoyaError) -> ApiError {
    switch error {
    case .statusCode(let response):
      switch response.statusCode {
      case 400: return .badRequest(message: response.description)
      case 403:
        DispatchQueue.main.async {
          ProfileManager.shared.logOut()
        }
        return .accountNotFound
      default:
        return .network(message: response.description)
      }

    case .underlying:
      return .internetDisabled
    default:
      return .network(message: error.localizedDescription)
    }
  }
}

extension MoyaError: MoyaErrorParserable {}
