//
//  MainCoordinator.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 07.11.2022.
//

import UIKit

protocol Coordinatable {
    var childCoordinators: [Coordinatable] { get set }
    var navigationController: UINavigationController { get set }
    func start()
}

final class MainCoordinator: Coordinatable {
    var childCoordinators = [Coordinatable]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        navigateToOnboarding()
    }
}

private extension MainCoordinator {
    func navigateToOnboarding() {
        let vc = OnboardingViewController()
        navigationController.pushViewController(vc, animated: true)
    }
}
