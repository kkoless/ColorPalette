//
//  GeneralNetworkService.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 21.04.2023.
//

import Foundation
import CombineMoya
import Combine
import Moya

protocol ReplaceImageColorsServiceProtocol {
    func replaceColors(imageData: Data, palette: ColorPalette) -> AnyPublisher<Data, ApiError>
}

final class GeneralNetworkService: MoyaErrorParserable {
    private let provider = Provider<GeneralAPI>(session: DefaultAlamofireSession.shared)
    
    static let shared: GeneralNetworkService = .init()
    
    private init() {
        print("\(self) INIT")
    }
    
    deinit {
        print("\(self) DEINIT")
    }
}

extension GeneralNetworkService: ReplaceImageColorsServiceProtocol {
    func replaceColors(imageData: Data, palette: ColorPalette) -> AnyPublisher<Data, ApiError> {
        provider.requestPublisher(.colorsReplace(imageData: imageData, palette: palette))
            .filterSuccessfulStatusCodes()
            .map { $0.data }
            .mapError(mapError(error:))
            .eraseToAnyPublisher()
    }
}
