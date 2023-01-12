//
//  TabBarCoordinator.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 30.11.2022.
//

import UIKit
import SwiftUI

protocol TabBarCoordinatorProtocol: Coordinatable {
    var tabBarController: UITabBarController { get set }
    
    func selectPage(_ page: TabBarPage)
    func setSelectedIndex(_ index: Int)
    
    func currentPage() -> TabBarPage?
    
    func getGeneralRouter() -> GeneralRoutable?
    func getFavoriteRouter() -> FavoritesRoutable?
    func getProfileRouter() -> ProfileRoutable?
}

final class TabBarCoordinator: Coordinatable {
    var childCoordinators: [Coordinatable] = []
    let navigationController: UINavigationController
    var tabBarController: UITabBarController
    let type: CoordinatorType = .tabBar
    
    weak var finishDelegate: CoordinatorFinishDelegate?
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.tabBarController = .init()
        configureTabBar()
    }
    
    func start() {
        let tabs: [TabBarPage] = TabBarPage.allCases
        let controllers: [UINavigationController] = tabs.map({ getTabController($0) })
        
        prepareTabBarController(withTabControllers: controllers)
    }
    
#if DEBUG
    deinit {
        print("\(self) DEINIT")
    }
#endif
}

private extension TabBarCoordinator {
    private func prepareTabBarController(withTabControllers tabControllers: [UIViewController]) {
        tabBarController.setViewControllers(tabControllers, animated: true)
        tabBarController.selectedIndex = TabBarPage.general.rawValue
        tabBarController.tabBar.isTranslucent = false
        navigationController.viewControllers = [tabBarController]
    }
    
    private func getTabController(_ page: TabBarPage) -> UINavigationController {
        let navController = UINavigationController()
        navController.setNavigationBarHidden(true, animated: false)
        
        navController.tabBarItem = UITabBarItem.init(title: page.title,
                                                     image: UIImage(systemName: page.iconName),
                                                     tag: page.rawValue)
        
        switch page {
            case .profile:
                let profileCoordinator = ProfileCoordinator(navController)
                childCoordinators.append(profileCoordinator)
                profileCoordinator.start()
            
            case .favorites:
                let favoritesCoordinator = FavoritesCoordinator(navController)
                childCoordinators.append(favoritesCoordinator)
                favoritesCoordinator.tabBarDelegate = self
                favoritesCoordinator.start()
                
            case .general:
                let generalCoordinator = GeneralCoordinator(navController)
                childCoordinators.append(generalCoordinator)
                generalCoordinator.start()
        }
        
        return navController
    }
}

extension TabBarCoordinator: TabBarCoordinatorProtocol {
    func getGeneralRouter() -> GeneralRoutable? {
        return childCoordinators.filter({ $0.type == .general }).first as? GeneralRoutable
    }
    
    func getFavoriteRouter() -> FavoritesRoutable? {
        return childCoordinators.filter({ $0.type == .favorites }).first as? FavoritesRoutable
    }
    
    func getProfileRouter() -> ProfileRoutable? {
        return childCoordinators.filter({ $0.type == .profile }).first as? ProfileRoutable
    }
    
    func selectPage(_ page: TabBarPage) {
        tabBarController.selectedIndex = page.rawValue
    }
    
    func setSelectedIndex(_ index: Int) {
        tabBarController.selectedIndex = index
    }
    
    func currentPage() -> TabBarPage? {
        return TabBarPage(rawValue: tabBarController.selectedIndex)
    }
}

private extension TabBarCoordinator {
    func configureTabBar() {
        tabBarController.tabBar.backgroundColor = UIColor(named: "systemBackground")
    }
}
