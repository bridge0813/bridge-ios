//
//  TabBarCoordinator.swift
//  Bridge
//
//  Created by 정호윤 on 2023/08/25.
//

import UIKit

final class TabBarCoordinator: Coordinator {
    // MARK: - Property
    weak var delegate: CoordinatorDelegate?
    var navigationController: UINavigationController
    var tabBarController: UITabBarController
    var childCoordinators: [Coordinator]
    
    // MARK: - Init
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.tabBarController = UITabBarController()
        self.childCoordinators = []
    }
    
    // MARK: - Start
    func start() {
        let pages = TabBarPageType.allCases
        let viewControllers = pages.map { createTabNavigationController(of: $0) }
        configureTabBarController(with: viewControllers)
    }
}

// MARK: - Configuration
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
            connectMypageFlow(to: tabNavigationController)
        }
    }
    
    func connectMainFlow(to tabNavigationController: UINavigationController) {
        let mainCoordinator = MainCoordinator(navigationController: tabNavigationController)
        mainCoordinator.start()
        mainCoordinator.delegate = self
        childCoordinators.append(mainCoordinator)
    }
    
    func connectManagementFlow(to tabNavigationController: UINavigationController) { }
    
    func connectChatFlow(to tabNavigationController: UINavigationController) {
        let chatCoordinator = ChatCoordinator(navigationController: tabNavigationController)
        chatCoordinator.start()
        chatCoordinator.delegate = self
        childCoordinators.append(chatCoordinator)
    }
    
    func connectMypageFlow(to tabNavigationController: UINavigationController) {
        let myPageCoordinator = MyPageCoordinator(navigationController: tabNavigationController)
        myPageCoordinator.start()
        myPageCoordinator.delegate = self
        childCoordinators.append(myPageCoordinator)
    }
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
        let backButtonImage = UIImage(named: "chevron.left")?
            .resize(to: CGSize(width: 24, height: 24))
            .withAlignmentRectInsets(UIEdgeInsets(top: 0, left: -2, bottom: 2, right: 0))
        
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.setBackIndicatorImage(backButtonImage, transitionMaskImage: backButtonImage)
        navigationBarAppearance.titleTextAttributes = [.font: BridgeFont.subtitle1.font, .foregroundColor: BridgeColor.gray01]
        navigationBarAppearance.shadowColor = BridgeColor.gray06
        
        UINavigationBar.appearance().tintColor = BridgeColor.gray01
        UINavigationBar.appearance().standardAppearance = navigationBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
        UINavigationBar.appearance().compactAppearance = navigationBarAppearance
        
        let tabBarItemAppearance = UITabBarItemAppearance()
        tabBarItemAppearance.normal.iconColor = BridgeColor.gray04
        tabBarItemAppearance.normal.titleTextAttributes = [.foregroundColor: BridgeColor.gray04]
        tabBarItemAppearance.selected.iconColor = BridgeColor.primary1
        tabBarItemAppearance.selected.titleTextAttributes = [.foregroundColor: BridgeColor.primary1]
        
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = .white
        tabBarAppearance.shadowImage = nil
        tabBarAppearance.shadowColor = nil
        
        tabBarAppearance.stackedLayoutAppearance = tabBarItemAppearance
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        
        tabBarController.tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBarController.tabBar.layer.shadowOpacity = 0.04
        tabBarController.tabBar.layer.shadowOffset = CGSize(width: 0, height: -6)
        tabBarController.tabBar.layer.shadowRadius = 10
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
