//
//  TabBarCoordinator.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 30.11.2022.
//

import UIKit
import SwiftUI

internal typealias FavoriteRoutableProtocol = FavoriteRoutable
internal typealias GeneralRoutableProtocol = GeneralRoutable & SamplesRoutable
internal typealias ProfileRoutableProtocol = ProfileRoutable

protocol TabBarCoordinatorProtocol: Coordinatable {
  var tabBarController: UITabBarController { get set }

  func selectPage(_ page: TabBarPage)
  func setSelectedIndex(_ index: Int)

  func currentPage() -> TabBarPage?

  func getGeneralRouter() -> GeneralRoutableProtocol?
  func getFavoriteRouter() -> FavoriteRoutableProtocol?
  func getProfileRouter() -> ProfileRoutableProtocol?
}

final class TabBarCoordinator: Coordinatable {
  var childCoordinators: [Coordinatable] = []
  let navigationController: UINavigationController
  var tabBarController: UITabBarController
  let type: CoordinatorType = .tabBar

  weak var finishDelegate: CoordinatorFinishDelegate?

  init(_ navigationController: UINavigationController) {
    self.navigationController = navigationController
    self.tabBarController = TabBarController()
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

    navController.tabBarItem = UITabBarItem.init(
      title: nil,
      image: UIImage(systemName: page.iconName),
      tag: page.rawValue
    )

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
  func getGeneralRouter() -> GeneralRoutableProtocol? {
    return childCoordinators.filter({ $0.type == .general }).first as? GeneralRoutableProtocol
  }

  func getFavoriteRouter() -> FavoriteRoutableProtocol? {
    return childCoordinators.filter({ $0.type == .favorites }).first as? FavoriteRoutableProtocol
  }

  func getProfileRouter() -> ProfileRoutableProtocol? {
    return childCoordinators.filter({ $0.type == .profile }).first as? ProfileRoutableProtocol
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
    tabBarController.tabBar.backgroundColor = .systemCustomBackground
  }
}
