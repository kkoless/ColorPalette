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
    
    init(router: OnboardingRoutable?) {
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

private extension OnboardingViewModel {
    func bindTap() {
        input.closeTap
            .sink { [weak self] _ in
                self?.router?.navigateToMain()
            }
            .store(in: &cancellable)
    }
}

extension OnboardingViewModel {
    struct Input {
        let closeTap = PassthroughSubject<Void, Never>()
    }
    
    struct Output {}
}
