//
//  TabBarCoordinator.swift
//  Bridge
//
//  Created by 정호윤 on 2023/08/25.
//

import UIKit

protocol TabBarCoordinatorProtocol: Coordinator {
    var tabBarController: UITabBarController { get set }
    
    func selectPage(_ page: TabBarPageType)
    func setSelectedPage(_ index: Int)
    func currentPage() -> TabBarPageType?
}

final class TabBarCoordinator: TabBarCoordinatorProtocol {
    
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
        navigationBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        navigationBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
        navigationBarAppearance.buttonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.black]
        UINavigationBar.appearance().standardAppearance = navigationBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
        UINavigationBar.appearance().compactAppearance = navigationBarAppearance
        
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.stackedLayoutAppearance.selected.iconColor = .black
        tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.black]
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
    }
}

// MARK: - Coordinator delegate
extension TabBarCoordinator: CoordinatorDelegate {
    func didFinish(childCoordinator: Coordinator) {
        navigationController.popToRootViewController(animated: true)
        finish()
    }
}