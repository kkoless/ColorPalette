//
//  ProfileCoordinator.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 30.11.2022.
//

import UIKit
import SwiftUI

protocol ProfileRoutable: AnyObject {
    func pop()
    func dismiss()
    
    func navigateToProfileScreen()
    func navigateToAuthorizationScreen()
    func navigateToRegistrationScreen()
}

final class ProfileCoordinator: Coordinatable {
    var childCoordinators = [Coordinatable]()
    let navigationController: UINavigationController
    let type: CoordinatorType = .profile
    
    weak var finishDelegate: CoordinatorFinishDelegate?
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        print("\(self) INIT")
    }
    
    func start() {
        navigateToProfileScreen()
    }
    
#if DEBUG
    deinit {
        print("\(self) DEINIT")
    }
#endif
}

extension ProfileCoordinator: ProfileRoutable {
    func pop() { navigationController.popViewController(animated: true) }
    func dismiss() { navigationController.dismiss(animated: true) }
    
    func navigateToProfileScreen() {
        let viewModel = ProfileViewModel(router: self)
        let profileView = ProfileView(viewModel: viewModel)
            .environmentObject(LocalizationService.shared)
        let vc = UIHostingController(rootView: profileView)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func navigateToAuthorizationScreen() {
        let viewModel = LoginViewModel(router: self)
        let view = LoginView(viewModel: viewModel)
            .environmentObject(LocalizationService.shared)
        let vc = UIHostingController(rootView: view)
        
        if let sheet = vc.sheetPresentationController {
            sheet.detents = [.medium()]
        }
        
        navigationController.present(vc, animated: true)
    }
    
    func navigateToRegistrationScreen() {
        let viewModel = RegistrationViewModel(router: self)
        let view = RegistrationView(viewModel: viewModel)
            .environmentObject(LocalizationService.shared)
        let vc = UIHostingController(rootView: view)
        
        dismiss()
        
        if let sheet = vc.sheetPresentationController {
            sheet.detents = [.medium()]
        }
        
        navigationController.present(vc, animated: true)
    }
}
