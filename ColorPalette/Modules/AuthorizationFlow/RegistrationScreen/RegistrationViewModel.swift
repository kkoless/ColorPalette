//
//  RegistrationViewModel.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 09.02.2023.
//

import Foundation
import Combine

final class RegistrationViewModel: ObservableObject {
    
    private weak var router: AuthorizationRoutable?
    private let service: AuthServiceProtocol
    
    let input: Input
    @Published var output: Output
    
    private var cancellable: Set<AnyCancellable> = .init()
    
    init(router: AuthorizationRoutable? = nil,
         service: AuthServiceProtocol = AuthorizationService.shared) {
        self.input = Input()
        self.output = Output()
        self.service = service
        self.router = router
        
        bindTaps()
        
        print("\(self) INIT")
    }
    
    deinit {
        cancellable.forEach { $0.cancel() }
        cancellable.removeAll()
        
        print("\(self) DEINIT")
    }
}

private extension RegistrationViewModel {
    func bindTaps() {
        input.registrTap
            .flatMap { [unowned self] userData -> AnyPublisher<TokenData, ApiError> in
                return self.service.registr(email: userData.0, password: userData.1)
            }
            .sink { response in
                switch response {
                    case .failure(let error):
                        print(error.localizedDescription)
                    case .finished: print("finished")
                }
            } receiveValue: { [weak self] token in
                CredentialsManager.shared.isGuest = false
                CredentialsManager.shared.token = token.access_token
                self?.router?.navigateToTabBarFlow()
            }
            .store(in: &cancellable)
    }
}

extension RegistrationViewModel {
    struct Input {
        let registrTap: PassthroughSubject<(String, String), Never> = .init()
    }
    
    struct Output { }
}
