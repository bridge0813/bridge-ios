//
//  MainCoordinator.swift
//  Bridge
//
//  Created by 엄지호 on 2023/08/28.
//

import UIKit

protocol MainCoordinatorProtocol: Coordinator {
    func connectToNotificationFlow()
    func connectToFilterFlow()
    func connectToSearchFlow()
    func connectToDetailFlow()
    func connectToWriteFlow()
}

final class MainCoordinator: MainCoordinatorProtocol {
    
    weak var delegate: CoordinatorDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator]
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.childCoordinators = []
    }
    
    func start() {
        showMainViewController()
    }
}

extension MainCoordinator {
    func showMainViewController() {
        let mainVC = MainViewController()
        navigationController.pushViewController(mainVC, animated: true)
    }
}

// MARK: - MainCoordinatorProtocol Method
extension MainCoordinator {
    func connectToNotificationFlow() { }
    func connectToFilterFlow() { }
    func connectToSearchFlow() { }
    func connectToDetailFlow() { }
    func connectToWriteFlow() { }
}
