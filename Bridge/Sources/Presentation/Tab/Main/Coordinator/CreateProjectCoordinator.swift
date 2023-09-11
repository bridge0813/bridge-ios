//
//  CreateProjectCoordinator.swift
//  Bridge
//
//  Created by 엄지호 on 2023/09/11.
//

import UIKit

// MARK: - Protocol
protocol CreateProjectCoordinatorProtocol: Coordinator {
    
}

final class CreateProjectCoordinator: CreateProjectCoordinatorProtocol {
    // MARK: - Properties
    weak var delegate: CoordinatorDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator]
    
    // MARK: - Initializer
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.childCoordinators = []
    }
    
    // MARK: - Methods
    func start() {
        showCreateProjectViewController()
    }
}

extension CreateProjectCoordinator {
    func showCreateProjectViewController() {
        let memberFieldSelectionViewModel = MemberFieldSelectionViewModel(
            coordinator: self
        )
        
        let createProjectVC = MemberFieldSelectionViewController(viewModel: memberFieldSelectionViewModel)
        navigationController.pushViewController(createProjectVC, animated: true)
    }
}

// MARK: - MainCoordinatorProtocol Method
extension MainCoordinator {
    
}
