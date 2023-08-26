//
//  AppCoordinator.swift
//  Bridge
//
//  Created by 정호윤 on 2023/08/25.
//

import UIKit

protocol AppCoordinatorProtocol: Coordinator {
    func connectOnboardingFlow()
    func connectTabBarFlow()
}

final class AppCoordinator: AppCoordinatorProtocol {
    
    weak var delegate: CoordinatorDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator]
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.childCoordinators = []
    }
    
    func start() {
        connectTabBarFlow()
    }
}

extension AppCoordinator {
    func connectOnboardingFlow() { }
    
    func connectTabBarFlow() {
        navigationController.popToRootViewController(animated: true)
        let tabBarCoordinator = TabBarCoordinator(navigationController: navigationController)
        tabBarCoordinator.delegate = self
        tabBarCoordinator.start()
        childCoordinators.append(tabBarCoordinator)
    }
}

// MARK: - Coordinator delegate
extension AppCoordinator: CoordinatorDelegate {
    func didFinish(childCoordinator: Coordinator) {
        navigationController.popToRootViewController(animated: true)
        connectTabBarFlow()
    }
}
