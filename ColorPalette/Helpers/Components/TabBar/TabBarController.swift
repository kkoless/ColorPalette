//
//  TabBarController.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 25.01.2023.
//

import Foundation
import UIKit

final class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
    }
}

extension TabBarController: UITabBarControllerDelegate {
func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
    return viewController != tabBarController.selectedViewController
}}
