//
//  GeneralCoordinator.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 30.11.2022.
//

import UIKit
import SwiftUI

protocol GeneralRoutable: AnyObject {
    func navigateToGeneralScreen()
}

final class GeneralCoordinator: Coordinatable {
    var childCoordinators = [Coordinatable]()
    let navigationController: UINavigationController
    let type: CoordinatorType = .profile
    
    weak var finishDelegate: CoordinatorFinishDelegate?
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        print("\(self) INIT")
    }
    
    func start() {
        navigateToGeneralScreen()
    }
    
#if DEBUG
    deinit {
        print("\(self) DEINIT")
    }
#endif
}

extension GeneralCoordinator: GeneralRoutable {
    func navigateToGeneralScreen() {
        let generalView = GeneralView()
        let vc = UIHostingController(rootView: generalView)
        navigationController.pushViewController(vc, animated: true)
    }
}
