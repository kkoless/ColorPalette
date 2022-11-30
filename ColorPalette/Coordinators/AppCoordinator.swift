//
//  AppCoordinator.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 28.11.2022.
//

import UIKit
import SwiftUI

protocol Coordinatable: AnyObject {
    var finishDelegate: CoordinatorFinishDelegate? { get set }
    var navigationController: UINavigationController { get }
    var childCoordinators: [Coordinatable] { get set }
    var type: CoordinatorType { get }
    
    func start()
    func finish()
    
    init(_ navigationController: UINavigationController)
}

extension Coordinatable {
    func finish() {
        childCoordinators.removeAll()
        finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
}

protocol CoordinatorFinishDelegate: AnyObject {
    func coordinatorDidFinish(childCoordinator: Coordinatable)
}

final class AppCoordinator: Coordinatable {
    var childCoordinators = [Coordinatable]()
    let navigationController: UINavigationController
    let type: CoordinatorType = .app
    
    weak var finishDelegate: CoordinatorFinishDelegate?
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        print("\(self) INIT")
    }
    
    func start() {
        navigateToOnboardingFlow()
    }
    
#if DEBUG
    deinit {
        print("\(self) DEINIT")
    }
#endif
}

private extension AppCoordinator {
    func navigateToOnboardingFlow() {
        let onboardingCoordinator = OnboardingCoordinator(navigationController)
        childCoordinators.append(onboardingCoordinator)
        onboardingCoordinator.finishDelegate = self
        onboardingCoordinator.start()
    }
    
    func navigateToAuthorizationFlow() {
        let loginCoordinator = AuthorizationCoordinator(navigationController)
        childCoordinators.append(loginCoordinator)
        loginCoordinator.finishDelegate = self
        loginCoordinator.start()
    }
    
    func navigateToTabBarFlow() {
        let tabBarCoordinator = TabBarCoordinator(navigationController)
        childCoordinators.append(tabBarCoordinator)
        tabBarCoordinator.finishDelegate = self
        tabBarCoordinator.start()
    }
}

extension AppCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinatable) {
        childCoordinators = childCoordinators.filter({ $0.type != childCoordinator.type })
        
        switch childCoordinator.type {
            case .onboarding:
                navigationController.viewControllers.removeAll()
                navigateToAuthorizationFlow()
            case .login:
                navigationController.viewControllers.removeAll()
                navigateToTabBarFlow()
            default:
                break
        }
    }
}
