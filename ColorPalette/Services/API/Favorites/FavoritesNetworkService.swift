//
//  FavoritesNetworkService.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 10.02.2023.
//

import Foundation
import CombineMoya
import Combine
import Moya

protocol FavoritesFetchServiceProtocol {
    func fetchColors() -> AnyPublisher<[AppColor], ApiError>
    func fetchPalettes() -> AnyPublisher<[ColorPalette], ApiError>
}

protocol FavoritesDeleteServiceProtocol {
    func deleteColor(colorId: Int) -> AnyPublisher<Void, ApiError>
    func deletePalette(paletteId: Int) -> AnyPublisher<Void, ApiError>
}

protocol FavoritesUpdateServiceProtocol {
    func updatePalette(paletteId: Int, newPalette: ColorPalette) -> AnyPublisher<Void, ApiError>
}

protocol FavoritesAddServiceProtocol {
    func addColor(color: AppColor) -> AnyPublisher<Void, ApiError>
    func addPalette(palette: ColorPalette) -> AnyPublisher<Void, ApiError>
}

final class FavoritesNetworkService: MoyaErrorParserable {
    private let provider = Provider<FavoritesAPI>()
    
    static let shared: FavoritesNetworkService = .init()
    
    private init() {
        print("\(self) INIT")
    }
    
    deinit {
        print("\(self) DEINIT")
    }
}

extension FavoritesNetworkService: FavoritesFetchServiceProtocol {
    func fetchColors() -> AnyPublisher<[AppColor], ApiError> {
        provider.requestPublisher(.getColors)
            .filterSuccessfulStatusCodes()
            .map([AppColor].self)
            .mapError(mapError(error:))
            .eraseToAnyPublisher()
    }
    
    func fetchPalettes() -> AnyPublisher<[ColorPalette], ApiError> {
        provider.requestPublisher(.getPalettes)
            .filterSuccessfulStatusCodes()
            .map([ColorPalette].self)
            .mapError(mapError(error:))
            .eraseToAnyPublisher()
    }
}

extension FavoritesNetworkService: FavoritesAddServiceProtocol {
    func addColor(color: AppColor) -> AnyPublisher<Void, ApiError> {
        provider.requestPublisher(.addColor(color: color))
            .filterSuccessfulStatusCodes()
            .map { _ in Void() }
            .mapError(mapError(error:))
            .eraseToAnyPublisher()
    }
    
    func addPalette(palette: ColorPalette) -> AnyPublisher<Void, ApiError> {
        provider.requestPublisher(.addPalette(palette: palette))
            .filterSuccessfulStatusCodes()
            .map { _ in Void() }
            .mapError(mapError(error:))
            .eraseToAnyPublisher()
    }
}

extension FavoritesNetworkService: FavoritesDeleteServiceProtocol {
    func deleteColor(colorId: Int) -> AnyPublisher<Void, ApiError> {
        provider.requestPublisher(.deleteColor(colorId: colorId))
            .filterSuccessfulStatusCodes()
            .map { _ in Void() }
            .mapError(mapError(error:))
            .eraseToAnyPublisher()
    }
    
    func deletePalette(paletteId: Int) -> AnyPublisher<Void, ApiError> {
        provider.requestPublisher(.deletePalette(paletteId: paletteId))
            .filterSuccessfulStatusCodes()
            .map { _ in Void() }
            .mapError(mapError(error:))
            .eraseToAnyPublisher()
    }
}

extension FavoritesNetworkService: FavoritesUpdateServiceProtocol {
    func updatePalette(paletteId: Int, newPalette: ColorPalette) -> AnyPublisher<Void, ApiError> {
        provider.requestPublisher(.updatePalette(paletteIdForDelete: paletteId, newPalette: newPalette))
            .filterSuccessfulStatusCodes()
            .map { _ in Void() }
            .mapError(mapError(error:))
            .eraseToAnyPublisher()
    }
}
