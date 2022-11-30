//
//  LoginCoordinator.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 28.11.2022.
//

import UIKit
import SwiftUI

protocol LoginRoutable: AnyObject {
    func navigateToLoginScreen()
    func navigateToRegistrationScreen()
}

final class LoginCoordinator: Coordinatable {
    var childCoordinators = [Coordinatable]()
    let navigationController: UINavigationController
    let type: CoordinatorType = .login
    
    weak var finishDelegate: CoordinatorFinishDelegate?
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        print("\(self) INIT")
    }
    
    func start() {
        navigateToLoginScreen()
    }
    
#if DEBUG
    deinit {
        print("\(self) DEINIT")
    }
#endif
}

extension LoginCoordinator: LoginRoutable {
    func navigateToLoginScreen() {
        let viewModel = LoginViewModel(router: self)
        let loginView = LoginView(viewModel: viewModel)
        let vc = UIHostingController(rootView: loginView)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func navigateToRegistrationScreen() {
        let registrationView = RegistrationView()
        let vc = UIHostingController(rootView: registrationView)
        navigationController.pushViewController(vc, animated: true)
    }
}
