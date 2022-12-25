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
    
    func navigateToSamplePalettes()
    func navigateToSampleColors()
    
    func navigateToColorPalette(palette: ColorPalette)
    
    func navigateToImageColorDetection()
    
    func navigateToSimilarColors(color: AppColor)
    func navigateToColorInfo(color: AppColor)
    
    func navigateToAddNewColor()
}

final class GeneralCoordinator: Coordinatable {
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
        var generalView = GeneralView()
        generalView.router = self
        let vc = UIHostingController(rootView: generalView)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func navigateToSamplePalettes() {
        var view = SamplePalettesView()
        view.router = self
        let vc = UIHostingController(rootView: view)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func navigateToSampleColors() {
        var view = SampleColorsView()
        view.router = self
        let vc = UIHostingController(rootView: view)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func navigateToColorPalette(palette: ColorPalette) {
        let view = ColorPaletteView(palette: palette)
        let vc = UIHostingController(rootView: view)
        navigationController.present(vc, animated: true)
    }
    
    func navigateToImageColorDetection() {
        let view = ImageColorDetection()
        let vc = UIHostingController(rootView: view)
        navigationController.pushViewController(vc, animated: true)
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
        let view = ColorInfoView(color: color)
        let vc = UIHostingController(rootView: view)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func navigateToAddNewColor() {
        let view = AddNewColorView().environmentObject(favoriteManager)
        let vc = UIHostingController(rootView: view)
        navigationController.pushViewController(vc, animated: true)
    }
}
