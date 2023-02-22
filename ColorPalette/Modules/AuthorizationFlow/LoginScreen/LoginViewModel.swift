//
//  LoginViewModel.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 30.11.2022.
//

import Combine

final class LoginViewModel: ObservableObject {
    
    private weak var router: ProfileRoutable?
    private let service: AuthServiceProtocol
    private let profileManager: ProfileManager
    
    let input: Input
    @Published var output: Output
    
    private var cancellable: Set<AnyCancellable> = .init()
    
    init(router: ProfileRoutable? = nil,
         service: AuthServiceProtocol = AuthorizationNetworkService.shared) {
        self.router = router
        self.service = service
        self.profileManager = .shared
        self.input = Input()
        self.output = Output()
        
        bindTaps()
        
        print("\(self) INIT")
    }
    
    deinit {
        cancellable.forEach { $0.cancel() }
        cancellable.removeAll()
        
        print("\(self) DEINIT")
    }
}

private extension LoginViewModel {
    func bindTaps() {
        input.registerTap
            .sink { [weak self] _ in self?.router?.navigateToRegistrationScreen() }
            .store(in: &cancellable)

        input.loginTap
            .flatMap { [unowned self] userData -> AnyPublisher<Profile, ApiError> in
                return self.service.login(email: userData.0, password: userData.1)
            }
            .sink { response in
                switch response {
                    case .failure(let error):
                        print(error.localizedDescription)
                    case .finished: print("finished")
                }
            } receiveValue: { [weak self] data in
                self?.profileManager.setProfile(data)
                self?.router?.dismiss()
            }
            .store(in: &cancellable)
    }
}

extension LoginViewModel {
    struct Input {
        let loginTap: PassthroughSubject<(String, String), Never> = .init()
        let registerTap: PassthroughSubject<Void, Never> = .init()
    }
    
    struct Output {
        
    }
}
