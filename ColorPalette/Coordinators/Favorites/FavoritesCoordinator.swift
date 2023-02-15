//
//  FavoritesCoordinator.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 25.12.2022.
//

import UIKit
import SwiftUI

protocol FavoritesRoutable: AnyObject {
    func pop()
    func dismiss()
    
    func navigateToFavoritesScreen()
    func navigateToEditPalette(palette: ColorPalette)
    
    func navigateToColorPalette(palette: ColorPalette)
    func navigateToColorInfo(color: AppColor)
    
    func navigateToAddNewColorToPalette(templateManager: TemplatePaletteManager)
    func navigateToAddNewColorToFavorites()
    
    func navigateToImageColorDetection()
    func navigateToCameraColorDetection()
    func navigateToCreatePalette()
    
    func navigateToPaletteLibrary()
    func navigateToColorLibrary()
}

final class FavoritesCoordinator: Coordinatable {
    var childCoordinators = [Coordinatable]()
    let navigationController: UINavigationController
    let type: CoordinatorType = .favorites
    
    weak var finishDelegate: CoordinatorFinishDelegate?
    weak var tabBarDelegate: TabBarCoordinatorProtocol?
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        print("\(self) INIT")
    }
    
    func start() {
        navigateToFavoritesScreen()
    }
    
#if DEBUG
    deinit {
        print("\(self) DEINIT")
    }
#endif
}

extension FavoritesCoordinator: FavoritesRoutable {
    func pop() {
        navigationController.popViewController(animated: true)
    }
    
    func dismiss() {
        navigationController.dismiss(animated: true)
    }
    
    func navigateToFavoritesScreen() {
        let viewModel = FavoriteViewModel(router: self)
        let favoriteView = FavoritesView(viewModel: viewModel)
            .environmentObject(LocalizationService.shared)
        let vc = UIHostingController(rootView: favoriteView)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func navigateToColorPalette(palette: ColorPalette) {
        let viewModel = ColorPaletteInfoViewModel(palette: palette)
        let view = ColorPaletteView(viewModel: viewModel, palette: palette)
        let vc = UIHostingController(rootView: view)
        navigationController.present(vc, animated: true)
    }
    
    func navigateToColorInfo(color: AppColor) {
        let viewModel = ColorInfoViewModel(color: color)
        let view = ColorInfoView(viewModel: viewModel, appColor: color)
        let vc = UIHostingController(rootView: view)
        navigationController.present(vc, animated: true)
    }
    
    func navigateToEditPalette(palette: ColorPalette) {
        let viewModel = EditPaletteViewModel(router: self, palette: palette)
        let view = EditPaletteView(viewModel: viewModel, initPalette: palette)
        let vc = UIHostingController(rootView: view)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func navigateToAddNewColorToPalette(templateManager: TemplatePaletteManager) {
        let viewModel = AddNewColorToPaletteViewModel(templatePaletteManager: templateManager, router: self)
        let view = AddNewColorToPaletteView(viewModel: viewModel)
        let vc = UIHostingController(rootView: view)
        navigationController.present(vc, animated: true)
    }
    
    func navigateToAddNewColorToFavorites() {
        let viewModel = AddNewColorToFavoritesViewModel(router: self)
        let view = AddNewColorToFavoritesView(viewModel: viewModel)
        let vc = UIHostingController(rootView: view)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func navigateToImageColorDetection() {
        let viewModel = ImageColorDetectionViewModel(router: self)
        let view = ImageColorDetectionView(viewModel: viewModel)
        let vc = UIHostingController(rootView: view)
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
    
    func navigateToCreatePalette() {
        let viewModel = CreateColorPaletteViewModel(router: self)
        let view = CreateColorPaletteView(viewModel: viewModel)
        let vc = UIHostingController(rootView: view)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func navigateToPaletteLibrary() {
        tabBarDelegate?.selectPage(.general)
        tabBarDelegate?.getGeneralRouter()?.navigateToSamplePalettes()
    }
    
    func navigateToColorLibrary() {
        tabBarDelegate?.selectPage(.general)
        tabBarDelegate?.getGeneralRouter()?.navigateToSampleColors()
    }
}
