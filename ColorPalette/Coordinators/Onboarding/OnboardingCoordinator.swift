//
//  OnboardingCoordinator.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 28.11.2022.
//

import UIKit
import SwiftUI

protocol OnboardingRoutable: AnyObject {
    func navigateToOnboarding()
    func navigateToGeneralFlow()
}

final class OnboardingCoordinator: Coordinatable {
    var childCoordinators = [Coordinatable]()
    let navigationController: UINavigationController
    let type: CoordinatorType = .onboarding
    
    weak var finishDelegate: CoordinatorFinishDelegate?
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        print("\(self) INIT")
    }
    
    func start() {
        navigateToOnboarding()
    }
    
#if DEBUG
    deinit {
        print("\(self) DEINIT")
    }
#endif
}

extension OnboardingCoordinator: OnboardingRoutable {
    func navigateToOnboarding() {
        let viewModel = OnboardingViewModel(router: self)
        let view = OnboardingView(viewModel: viewModel)
            .environmentObject(LocalizationService.shared)
        let vc = UIHostingController(rootView: view)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func navigateToGeneralFlow() {
        finishDelegate?.coordinatorDidFinish(childCoordinator: self, next: .tabBar)
    }
}
