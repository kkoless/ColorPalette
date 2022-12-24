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
    
    func showSimilarColors(color: AppColor)
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
    
    func showSimilarColors(color: AppColor) {
        let view = SimilarColorsView(color: UIColor(hexString: color.hex))
        let vc = UIHostingController(rootView: view)
        
        if let sheet = vc.sheetPresentationController {
            sheet.detents = [ .medium(), .large() ]
            sheet.prefersGrabberVisible = true
        }
         
        navigationController.present(vc, animated: true)
    }
}
