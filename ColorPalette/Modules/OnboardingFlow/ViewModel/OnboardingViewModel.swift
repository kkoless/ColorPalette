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
  private func bindTaps() {
    input.skipTap
      .sink { [unowned self] _ in
        OnboardingManager.shared.isOnboarding = true
        CredentialsManager.shared.isGuest = true
        router?.navigateToGeneralFlow()
      }
      .store(in: &cancellable)
  }
}

extension OnboardingViewModel {
  struct Input {
    let skipTap: PassthroughSubject<Void, Never> = .init()
  }
  
  struct Output { }
}
