//
//  UpdateProjectCoordinator.swift
//  Bridge
//
//  Created by 엄지호 on 2/9/24.
//

import UIKit

final class UpdateProjectCoordinator: Coordinator {
    // MARK: - Property
    weak var delegate: CoordinatorDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator]

    private let projectDataStorage = ProjectDataStorage()
    private var updateProjectNavigationController: UINavigationController?

    private let projectRepository: ProjectRepository
   
    // MARK: - Init
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        childCoordinators = []

        let networkService = DefaultNetworkService()
        projectRepository = DefaultProjectRepository(networkService: networkService)
    }

    // MARK: - Methods
    func start() {

    }
}

// MARK: - Show
extension UpdateProjectCoordinator {

}

// MARK: - CoordinatorDelegate
extension UpdateProjectCoordinator: CoordinatorDelegate {
    func didFinish(childCoordinator: Coordinator) {
        navigationController.dismiss(animated: true)

        if let index = childCoordinators.firstIndex(where: { $0 === childCoordinator }) {
            childCoordinators.remove(at: index)
        }
    }
}
