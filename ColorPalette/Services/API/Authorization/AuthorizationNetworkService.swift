//
//  AuthorizationNetworkService.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 06.02.2023.
//

import Foundation
import CombineMoya
import Combine
import Moya

protocol AuthServiceProtocol {
    func login(email: String, password: String) -> AnyPublisher<Profile, ApiError>
    func registr(email: String, password: String) -> AnyPublisher<Profile, ApiError>
}

protocol ProfileServiceProtocol {
    func fetchProfile() -> AnyPublisher<Profile, ApiError>
}

final class AuthorizationNetworkService: MoyaErrorParserable {
    private let provider: Provider<AuthorizationAPI>
    
    static let shared: AuthorizationNetworkService = .init()
    
    private init() {
        self.provider = .init()
        print("\(self) INIT")
    }
    
    deinit {
        print("\(self) DEINIT")
    }
}

extension AuthorizationNetworkService: AuthServiceProtocol {
    func login(email: String, password: String) -> AnyPublisher<Profile, ApiError> {
        provider.requestPublisher(.login(email: email, password: password))
            .filterSuccessfulStatusCodes()
            .map(ServerProfileModel.self)
            .map { ProfileMapper.toLocal(from: $0) }
            .mapError(mapError(error:))
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func registr(email: String, password: String) -> AnyPublisher<Profile, ApiError> {
        provider.requestPublisher(.register(email: email, password: password))
            .filterSuccessfulStatusCodes()
            .map(ServerProfileModel.self)
            .map { ProfileMapper.toLocal(from: $0) }
            .mapError(mapError(error:))
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

extension AuthorizationNetworkService: ProfileServiceProtocol {
    func fetchProfile() -> AnyPublisher<Profile, ApiError> {
        provider.requestPublisher(.fetchUser)
            .filterSuccessfulStatusCodes()
            .map(ServerProfileModel.self)
            .map { ProfileMapper.toLocal(from: $0) }
            .mapError(mapError(error:))
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}


