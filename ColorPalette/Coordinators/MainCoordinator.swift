//
//  MainCoordinator.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 07.11.2022.
//

import UIKit
import SwiftUI

protocol Coordinatable {
    var childCoordinators: [Coordinatable] { get set }
    var navigationController: UINavigationController { get set }
    func start()
}

protocol OnboardingRoutable: AnyObject {
    func navigateToMain()
}

final class MainCoordinator: Coordinatable {
    var childCoordinators = [Coordinatable]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = OnboardingViewModel(router: self)
        let view = OnboardingView(viewModel: viewModel)
        let vc = UIHostingController(rootView: view)
        navigationController.pushViewController(vc, animated: true)
    }
}

extension MainCoordinator: OnboardingRoutable {
    func navigateToMain() {
        let vc = ColorDetectionViewController()
        navigationController.pushViewController(vc, animated: true)
    }
}


