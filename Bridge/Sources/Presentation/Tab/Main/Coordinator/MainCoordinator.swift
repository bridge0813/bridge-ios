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
    func connectToProjectSearchFlow(with query: String)
    func connectToProjectDetailFlow(with project: Project)
    func connectToCreateProjectFlow()
}

final class MainCoordinator: MainCoordinatorProtocol {
    // MARK: - Properties
    weak var delegate: CoordinatorDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator]
    
    private let projectRepository: ProjectRepository
    private let fetchProjectsUseCase: FetchAllProjectsUseCase
    private let fetchHotProjectsUseCase: FetchHotProjectsUseCase
    
    // MARK: - Initializer
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.childCoordinators = []

        let networkService = DefaultNetworkService()
        projectRepository = DefaultProjectRepository(networkService: networkService)
        fetchProjectsUseCase = DefaultFetchAllProjectsUseCase(projectRepository: projectRepository)
        fetchHotProjectsUseCase = DefaultFetchHotProjectsUseCase(projectRepository: projectRepository)
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
            fetchProjectsUseCase: fetchProjectsUseCase,
            fetchHotProjectsUseCase: fetchHotProjectsUseCase
        )
        
        let mainVC = MainViewController(viewModel: mainViewModel)
        navigationController.pushViewController(mainVC, animated: true)
    }
}

// MARK: - MainCoordinatorProtocol Method
extension MainCoordinator {
    func connectToNotificationFlow() {
        print("알림 뷰 이동")
    }
    
    func connectToProjectFilteringFlow() {
        print("필터 뷰 이동")
    }
    
    func connectToProjectSearchFlow(with query: String) {
        print(query)
    }
    
    func connectToProjectDetailFlow(with project: Project) {
        print(project.title)
    }
    
    func connectToCreateProjectFlow() { }
}
