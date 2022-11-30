//
//  LoginViewModel.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 30.11.2022.
//

import Combine

final class LoginViewModel: ObservableObject {
    
    private weak var router: AuthorizationRoutable?
    
    let input: Input
    @Published var output: Output
    
    private var cancellable: Set<AnyCancellable> = .init()
    
    init(router: AuthorizationRoutable?) {
        self.router = router
        self.input = Input()
        self.output = Output()
        
        bindTap()
    }
    
    deinit {
        print("\(self) DEINIT")
        
        cancellable.forEach { $0.cancel() }
        cancellable.removeAll()
    }
    
}

private extension LoginViewModel {
    func bindTap() {
        input.registerTap
            .sink { [weak self] _ in self?.router?.navigateToRegistrationScreen() }
            .store(in: &cancellable)
        
        input.loginTap
            .sink { [weak self] _ in self?.router?.navigateToTabBarFlow() }
            .store(in: &cancellable)
    }
}

extension LoginViewModel {
    struct Input {
        let loginTap = PassthroughSubject<Void, Never>()
        let registerTap = PassthroughSubject<Void, Never>()
    }
    
    struct Output {}
}
