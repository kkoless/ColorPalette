//
//  GeneralCoordinator.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 30.11.2022.
//

import UIKit
import SwiftUI

protocol GeneralRoutable: AnyObject {
    func pop()
    func popToRoot()
    
    func navigateToGeneralScreen()
    
    func navigateToSamplePalettes()
    func navigateToSampleColors()
    
    func navigateToColorPalette(palette: ColorPalette)
    
    func navigateToSimilarColors(color: AppColor)
    func navigateToColorInfo(color: AppColor)
    
    func navigateToEditPalette(palette: ColorPalette)
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

extension GeneralCoordinator: GeneralRoutable {
    func pop() { navigationController.popViewController(animated: true) }
    func popToRoot() { navigationController.popToRootViewController(animated: true) }
    
    func navigateToGeneralScreen() {
        let viewModel = GeneralViewModel(router: self)
        var generalView = GeneralView(viewModel: viewModel)
        let vc = UIHostingController(rootView: generalView)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func navigateToSamplePalettes() {
        let viewModel = SamplePalettesViewModel(router: self)
        let view = SamplePalettesView(viewModel: viewModel)
        let vc = UIHostingController(rootView: view)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func navigateToSampleColors() {
        let viewModel = SampleColorsViewModel(router: self)
        let view = SampleColorsView().environmentObject(viewModel)
        let vc = UIHostingController(rootView: view)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func navigateToColorPalette(palette: ColorPalette) {
        let viewModel = ColorPaletteInfoViewModel(palette: palette)
        let view = ColorPaletteView(viewModel: viewModel, palette: palette)
        let vc = UIHostingController(rootView: view)
        navigationController.present(vc, animated: true)
    }
    
    func navigateToSimilarColors(color: AppColor) {
        let view = SimilarColorsView(color: UIColor(hexString: color.hex))
        let vc = UIHostingController(rootView: view)
        
        if let sheet = vc.sheetPresentationController {
            sheet.detents = [ .medium(), .large() ]
            sheet.prefersGrabberVisible = true
        }
         
        navigationController.present(vc, animated: true)
    }
    
    func navigateToColorInfo(color: AppColor) {
        let viewModel = ColorInfoViewModel(color: color)
        let view = ColorInfoView(viewModel: viewModel, appColor: color)
        let vc = UIHostingController(rootView: view)
        navigationController.present(vc, animated: true)
    }
    
    func navigateToEditPalette(palette: ColorPalette) {
        let view = EditPaletteView(initPalette: palette)
        let vc = UIHostingController(rootView: view)
        navigationController.present(vc, animated: true)
    }
}
