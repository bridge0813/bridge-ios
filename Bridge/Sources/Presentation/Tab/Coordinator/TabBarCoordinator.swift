//
//  TabBarCoordinator.swift
//  Bridge
//
//  Created by 정호윤 on 2023/08/25.
//

import UIKit

final class TabBarCoordinator: Coordinator {
    
    weak var delegate: CoordinatorDelegate?
    var navigationController: UINavigationController
    var tabBarController: UITabBarController
    var childCoordinators: [Coordinator]
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.tabBarController = UITabBarController()
        self.childCoordinators = []
    }
    
    func start() {
        let pages = TabBarPageType.allCases
        let viewControllers = pages.map { createTabNavigationController(of: $0) }
        configureTabBarController(with: viewControllers)
    }
}

private extension TabBarCoordinator {
    func configureTabBarController(with viewControllers: [UIViewController]) {
        tabBarController.viewControllers = viewControllers
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.pushViewController(tabBarController, animated: false)
        configureBarAppearance()
    }
    
    func createTabNavigationController(of page: TabBarPageType) -> UINavigationController {
        let navigationController = UINavigationController()
        navigationController.tabBarItem = page.tabBarItem
        connectTabCoordinator(of: page, to: navigationController)
        return navigationController
    }
    
    func connectTabCoordinator(of page: TabBarPageType, to tabNavigationController: UINavigationController) {
        switch page {
        case .main:
            connectMainFlow(to: tabNavigationController)
            
        case .management:
            return
            
        case .chat:
            connectChatFlow(to: tabNavigationController)
            
        case .my:
            return
        }
    }
    
    func connectMainFlow(to tabNavigationController: UINavigationController) {
        let mainCoordinator = MainCoordinator(navigationController: tabNavigationController)
        mainCoordinator.start()
        childCoordinators.append(mainCoordinator)
    }
    
    func connectManagementFlow(to tabNavigationController: UINavigationController) { }
    
    func connectChatFlow(to tabNavigationController: UINavigationController) {
        let chatCoordinator = ChatCoordinator(navigationController: tabNavigationController)
        chatCoordinator.start()
        chatCoordinator.delegate = self
        childCoordinators.append(chatCoordinator)
    }
    
    func connectMypageFlow(to tabNavigationController: UINavigationController) { }
}

// MARK: - Tab bar coordinator protocol
extension TabBarCoordinator {
    func selectPage(_ page: TabBarPageType) {
        tabBarController.selectedIndex = page.rawValue
    }
    
    func setSelectedPage(_ index: Int) {
        guard let page = TabBarPageType(rawValue: index) else { return }
        tabBarController.selectedIndex = page.rawValue
    }
    
    func currentPage() -> TabBarPageType? {
        TabBarPageType(rawValue: tabBarController.selectedIndex)
    }
}

// MARK: - Bar appearance
private extension TabBarCoordinator {
    func configureBarAppearance() {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        UINavigationBar.appearance().tintColor = .black
        UINavigationBar.appearance().standardAppearance = navigationBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
        UINavigationBar.appearance().compactAppearance = navigationBarAppearance
        
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.stackedLayoutAppearance.selected.iconColor = BridgeColor.primary1
        tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: BridgeColor.primary1]
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
    }
}

// MARK: - Coordinator delegate
extension TabBarCoordinator: CoordinatorDelegate {
    // AuthCoordinator에 의해 호출됨
    func didFinish(childCoordinator: Coordinator) {
        navigationController.dismiss(animated: true)
        
        if let index = childCoordinators.firstIndex(where: { $0 === childCoordinator }) {
            childCoordinators.remove(at: index)
        }
    }
    
    // MARK: - Auth
    func showSignInViewController() {
        let authCoordinator = AuthCoordinator(navigationController: navigationController)
        authCoordinator.start()
        authCoordinator.delegate = self
        childCoordinators.append(authCoordinator)
    }
}
