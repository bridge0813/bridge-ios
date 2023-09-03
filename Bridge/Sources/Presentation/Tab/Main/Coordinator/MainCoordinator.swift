//
//  MainCoordinator.swift
//  Bridge
//
//  Created by 엄지호 on 2023/08/28.
//

import UIKit

// MARK: - Protocol
protocol MainCoordinatorProtocol: Coordinator {
    func connectToNotificationFlow()
    func connectToProjectFilteringFlow()
    func connectToProjectSearchFlow()
    func connectToProjectDetailFlow()
    func connectToCreateProjectFlow()
}

final class MainCoordinator: MainCoordinatorProtocol {
    // MARK: - Properties
    weak var delegate: CoordinatorDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator]
    
    private let projectRepository: ProjectRepository
    private let fetchProjectsUseCase: FetchProjectsUseCase
    
    
    // MARK: - Initializer
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.childCoordinators = []

        let networkService = DefaultNetworkService()
        projectRepository = DefaultProjectRepository(networkService: networkService)
        fetchProjectsUseCase = DefaultFetchProjectsUseCase(projectRepository: projectRepository)
    }
    
    
    // MARK: - Methods
    func start() {
        showMainViewController()
    }
}

extension MainCoordinator {
    func showMainViewController() {
        let mainViewModel = MainViewModel(
            coordinator: self,
            fetchProjectsUseCase: fetchProjectsUseCase
        )
        
        let mainVC = MainViewController(viewModel: mainViewModel)
        navigationController.pushViewController(mainVC, animated: true)
    }
}

// MARK: - MainCoordinatorProtocol Method
extension MainCoordinator {
    func connectToNotificationFlow() { }
    func connectToProjectFilteringFlow() { }
    func connectToProjectSearchFlow() { }
    func connectToProjectDetailFlow() { }
    func connectToCreateProjectFlow() { }
}
