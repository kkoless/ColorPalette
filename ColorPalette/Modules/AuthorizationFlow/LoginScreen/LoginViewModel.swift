//
//  LoginViewModel.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 30.11.2022.
//

import Combine

final class LoginViewModel: ObservableObject {
    
    private weak var router: AuthorizationRoutable?
    private let service: AuthServiceProtocol
    
    let input: Input
    @Published var output: Output
    
    private var cancellable: Set<AnyCancellable> = .init()
    
    init(router: AuthorizationRoutable? = nil,
         service: AuthServiceProtocol = AuthorizationNetworkService.shared) {
        self.router = router
        self.service = service
        self.input = Input()
        self.output = Output()
        
        bindTaps()
        
        print("\(self) INIT")
    }
    
    deinit {
        print("\(self) DEINIT")
        
        cancellable.forEach { $0.cancel() }
        cancellable.removeAll()
    }
    
}

private extension LoginViewModel {
    func bindTaps() {
        input.registerTap
            .sink { [weak self] _ in self?.router?.navigateToRegistrationScreen() }
            .store(in: &cancellable)

        input.loginTap
            .flatMap { [unowned self] userData -> AnyPublisher<TokenData, ApiError> in
                return self.service.login(email: userData.0, password: userData.1)
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

extension LoginViewModel {
    struct Input {
        let loginTap = PassthroughSubject<(String, String), Never>()
        let registerTap = PassthroughSubject<Void, Never>()
    }
    
    struct Output {}
}
