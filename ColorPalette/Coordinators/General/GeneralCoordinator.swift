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
    
    func navigateToGeneralScreen()
    
    func navigateToSamplePalettes()
    func navigateToSampleColors()
    
    func navigateToColorPalette(palette: ColorPalette)
    
    func navigateToSimilarColors(color: AppColor)
    func navigateToColorInfo(color: AppColor)
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
    func pop() {
        navigationController.popViewController(animated: true)
    }
    
    func navigateToGeneralScreen() {
        var generalView = GeneralView()
        generalView.router = self
        let vc = UIHostingController(rootView: generalView)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func navigateToSamplePalettes() {
        let view = SamplePalettesView(router: self)
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
        let view = ColorPaletteView(palette: palette)
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
        let view = ColorInfoView(appColor: color)
            .environmentObject(FavoriteManager.shared)
        let vc = UIHostingController(rootView: view)
        navigationController.present(vc, animated: true)
    }
}
