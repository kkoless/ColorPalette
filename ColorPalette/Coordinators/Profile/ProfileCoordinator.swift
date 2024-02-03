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

protocol AuthorizationRoutable: AnyObject {
  func navigateToAuthorizationScreen()
  func navigateToRegistrationScreen()
}

protocol ColorPsychologyRoutable: AnyObject {
  func navigateToColorPsychologyScreen()
}

protocol SubscribtionsPlanInfoRoutable: AnyObject {
  func navigateToSubscribtionsPlanInfoScreen()
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

extension ProfileCoordinator {
  func pop() { navigationController.popViewController(animated: true) }
  func dismiss() { navigationController.dismiss(animated: true) }

  func navigateToProfileScreen() {
    let viewModel = ProfileViewModel(router: self)
    let profileView = ProfileView(viewModel: viewModel)
      .environmentObject(LocalizationService.shared)
    let vc = UIHostingController(rootView: profileView)
    navigationController.pushViewController(vc, animated: true)
  }

  func navigateToColorPalette(palette: ColorPalette) {
    let viewModel = ColorPaletteInfoViewModel(palette: palette)
    let view = ColorPaletteView(viewModel: viewModel, palette: palette)
    let vc = UIHostingController(rootView: view)
    navigationController.present(vc, animated: true)
  }

  func navigateToColorInfo(color: AppColor) {
    let colorInfoViewModel = ColorInfoViewModel(color: color)
    let additionalColorInfoViewModel = AdditionalColorInfoViewModel(color: color)
    let view = ColorInfoPagesView(
      colorInfoViewModel: colorInfoViewModel,
      additionalColorInfoViewModel: additionalColorInfoViewModel,
      appColor: color
    )
    let vc = UIHostingController(rootView: view)
    navigationController.present(vc, animated: true)
  }

  func navigateToColorPsychologyScreen() {
    let viewModel = ColorPsychologyViewModel(router: self)
    let view = ColorPsychologyView(viewModel: viewModel)
    let vc = UIHostingController(rootView: view)
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

  func navigateToSubscribtionsPlanInfoScreen() {
    let view = SubscribtionPlansInfoView()
    let vc = UIHostingController(rootView: view)
    navigationController.present(vc, animated: true)
  }
}

extension ProfileCoordinator: PopRoutable {}
extension ProfileCoordinator: DismissRoutable {}
extension ProfileCoordinator: ProfileRoutable {}
extension ProfileCoordinator: AuthorizationRoutable {}
extension ProfileCoordinator: ColorPsychologyRoutable {}
extension ProfileCoordinator: InfoRoutable {}
extension ProfileCoordinator: SubscribtionsPlanInfoRoutable {}
