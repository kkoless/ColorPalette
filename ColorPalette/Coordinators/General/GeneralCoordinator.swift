//
//  GeneralCoordinator.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 30.11.2022.
//

import UIKit
import SwiftUI

protocol SamplesRoutable: AnyObject {
  func navigateToSamplePalettes()
  func navigateToSampleColors()
}

protocol GeneralRoutable: AnyObject {
  func navigateToGeneralScreen()
}

final class GeneralCoordinator: Coordinatable {
  var childCoordinators = [Coordinatable]()
  let navigationController: UINavigationController
  let type: CoordinatorType = .general

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

extension GeneralCoordinator {
  func pop() {
    setTabBarAppearance(isHidden: false)
    navigationController.popViewController(animated: true)
  }

  func popToRoot() {
    setTabBarAppearance(isHidden: false)
    navigationController.popToRootViewController(animated: true)
  }

  func navigateToGeneralScreen() {
    let viewModel = GeneralViewModel(router: self)
    let generalView = GeneralView(viewModel: viewModel)
      .environmentObject(LocalizationService.shared)
    let vc = UIHostingController(rootView: generalView)
    navigationController.pushViewController(vc, animated: true)
  }

  func navigateToSamplePalettes() {
    let viewModel = SamplePalettesViewModel(router: self)
    let view = SamplePalettesView(viewModel: viewModel)
      .environmentObject(LocalizationService.shared)
    let vc = UIHostingController(rootView: view)
    navigationController.pushViewController(vc, animated: true)
  }

  func navigateToSampleColors() {
    let viewModel = SampleColorsViewModel(router: self)
    let view = SampleColorsView(viewModel: viewModel)
      .environmentObject(LocalizationService.shared)
    let vc = UIHostingController(rootView: view)
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

  func navigateToImageColorDetection() {
    let viewModel = ImageColorDetectionViewModel(router: self)
    let view = ImageColorDetectionView(viewModel: viewModel)
    let vc = UIHostingController(rootView: view)

    setTabBarAppearance(isHidden: true)

    navigationController.pushViewController(vc, animated: true)
  }

  func navigateToCameraColorDetection() {
#if IOS_SIMULATOR
#else
    let vc = CameraColorDetectionViewController()
    let viewModel = CameraColorDetectionViewModel(router: self)
    vc.injectViewModel(viewModel)
    navigationController.pushViewController(vc, animated: true)
#endif
  }
}

private extension GeneralCoordinator {
  private func setTabBarAppearance(isHidden: Bool) {
    navigationController.tabBarController?.tabBar.isTranslucent = isHidden
    navigationController.tabBarController?.tabBar.isHidden = isHidden
  }
}

extension GeneralCoordinator: PopRoutable {}
extension GeneralCoordinator: PopToRootRoutable {}
extension GeneralCoordinator: DetectionRoutable {}
extension GeneralCoordinator: InfoRoutable {}
extension GeneralCoordinator: SamplesRoutable {}
extension GeneralCoordinator: GeneralRoutable {}
