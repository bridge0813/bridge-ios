//
//  ManagementCoordinator.swift
//  Bridge
//
//  Created by 엄지호 on 12/6/23.
//

import UIKit

final class ManagementCoordinator: Coordinator {
    // MARK: - Property
    weak var delegate: CoordinatorDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator]
    
    private let projectRepository: ProjectRepository
    
    private let fetchApplyProjectsUseCase: FetchApplyProjectsUseCase
    private let fetchMyProjectsUseCase: FetchMyProjectsUseCase
    
    // MARK: - Init
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.childCoordinators = []

        let networkService = DefaultNetworkService()
        projectRepository = MockProjectRepository()

        fetchApplyProjectsUseCase = DefaultFetchApplyProjectsUseCase(projectRepository: projectRepository)
        fetchMyProjectsUseCase = DefaultFetchMyProjectsUseCase(projectRepository: projectRepository)
    }
    
    // MARK: - Methods
    func start() {
        showManagementViewController()
    }
}

extension ManagementCoordinator {
    // MARK: - Show
    func showManagementViewController() {
        let viewModel = ManagementViewModel(
            coordinator: self,
            fetchApplyProjectsUseCase: fetchApplyProjectsUseCase,
            fetchMyProjectsUseCase: fetchMyProjectsUseCase
        )
        
        let vc = ManagementViewController(viewModel: viewModel)
        navigationController.pushViewController(vc, animated: true)
    }
    
    // MARK: - Connect
    func connectToProjectDetailFlow(with projectID: Int) {
        // TODO: - 연결된 코디네이터 제거 작업
        let coordinator = ProjectDetailCoordinator(navigationController: navigationController)
        coordinator.start()
        childCoordinators.append(coordinator)
    }
}

// MARK: - CoordinatorDelegate
extension ManagementCoordinator: CoordinatorDelegate {
    func didFinish(childCoordinator: Coordinator) {
        navigationController.dismiss(animated: true)
        
        if let index = childCoordinators.firstIndex(where: { $0 === childCoordinator }) {
            childCoordinators.remove(at: index)
        }
    }
}
