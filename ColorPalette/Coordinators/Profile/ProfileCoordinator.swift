//
//  ProfileCoordinator.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 30.11.2022.
//

import UIKit
import SwiftUI

protocol ProfileRoutable: AnyObject {
    func navigateToProfileScreen()
}

final class ProfileCoordinator: Coordinatable {
    var childCoordinators = [Coordinatable]()
    let navigationController: UINavigationController
    let type: CoordinatorType = .profile
    var favoriteManager: FavoriteManager
    
    weak var finishDelegate: CoordinatorFinishDelegate?
    
    init(_ navigationController: UINavigationController, favoriteManager: FavoriteManager) {
        self.navigationController = navigationController
        self.favoriteManager = favoriteManager
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
    func navigateToProfileScreen() {
        let profileView = ProfileView()
        let vc = UIHostingController(rootView: profileView)
        navigationController.pushViewController(vc, animated: true)
    }
}
