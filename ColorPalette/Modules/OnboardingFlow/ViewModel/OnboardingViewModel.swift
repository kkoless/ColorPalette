//
//  OnboardingViewModel.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 11.11.2022.
//

import Combine

final class OnboardingViewModel: ObservableObject {
    
    private weak var router: OnboardingRoutable?
    
    let input: Input
    @Published var output: Output
    
    private var cancellable: Set<AnyCancellable> = .init()
    
    init(router: OnboardingRoutable? = nil) {
        self.router = router
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

private extension OnboardingViewModel {
    func bindTaps() {
        input.skipTap
            .sink { [weak self] _ in
                OnboardingManager.shared.isOnboarding = true
                self?.router?.navigateToGeneralFlow()
            }
            .store(in: &cancellable)
        
        input.signInTap
            .sink { [weak self] _ in
                OnboardingManager.shared.isOnboarding = true
                self?.router?.navigateToAuthorizationFlow()
            }
            .store(in: &cancellable)
    }
}

extension OnboardingViewModel {
    struct Input {
        let signInTap: PassthroughSubject<Void, Never> = .init()
        let skipTap: PassthroughSubject<Void, Never> = .init()
    }
    
    struct Output { }
}
