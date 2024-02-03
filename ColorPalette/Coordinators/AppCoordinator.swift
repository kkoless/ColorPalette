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
    finishDelegate?.coordinatorDidFinish(childCoordinator: self, next: nil)
  }
}

protocol CoordinatorFinishDelegate: AnyObject {
  func coordinatorDidFinish(childCoordinator: Coordinatable,  next: CoordinatorType?)
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
    if OnboardingManager.shared.isOnboarding {
      navigateToTabBarFlow()
    } else {
      navigateToOnboardingFlow()
    }
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
  
  func navigateToTabBarFlow() {
    let tabBarCoordinator = TabBarCoordinator(navigationController)
    childCoordinators.append(tabBarCoordinator)
    tabBarCoordinator.finishDelegate = self
    tabBarCoordinator.start()
  }
}

extension AppCoordinator: CoordinatorFinishDelegate {
  func coordinatorDidFinish(childCoordinator: Coordinatable, next: CoordinatorType?) {
    childCoordinators = childCoordinators.filter({ $0.type != childCoordinator.type })
    
    switch childCoordinator.type {
    case .onboarding:
      navigationController.viewControllers.removeAll()
      
      switch next {
      case .tabBar: navigateToTabBarFlow()
      default: return
      }
      
    default:
      break
    }
  }
}
