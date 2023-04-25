//
//  GoogleSearchNetworkService.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 10.04.2023.
//

import Foundation
import CombineMoya
import Combine
import Moya

protocol GoogleSearchServiceProtocol {
    func search(dominantColor: AppColor) -> AnyPublisher<GoogleSearchResponse, ApiError>
}

final class GoogleSearchNetworkService: MoyaErrorParserable {
    private let provider = Provider<GoogleSearchAPI>()
    
    static let shared: GoogleSearchNetworkService = .init()
    
    private init() {
        print("\(self) INIT")
    }
    
    deinit {
        print("\(self) DEINIT")
    }
}

extension GoogleSearchNetworkService: GoogleSearchServiceProtocol {
    func search(dominantColor: AppColor) -> AnyPublisher<GoogleSearchResponse, ApiError> {
        provider.requestPublisher(.search(dominantColor: dominantColor))
            .filterSuccessfulStatusCodes()
            .map(GoogleSearchResponse.self)
            .mapError(mapError(error:))
            .eraseToAnyPublisher()
    }
}
