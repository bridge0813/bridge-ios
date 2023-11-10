//
//  MainCoordinator.swift
//  Bridge
//
//  Created by 엄지호 on 2023/08/28.
//

import UIKit

final class MainCoordinator: Coordinator {
    // MARK: - Property
    weak var delegate: CoordinatorDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator]
    
    private let projectRepository: ProjectRepository
    private let fetchProjectsUseCase: FetchAllProjectsUseCase
    private let fetchHotProjectsUseCase: FetchHotProjectsUseCase
    
    // MARK: - Init
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.childCoordinators = []

//        let networkService = DefaultNetworkService()
        projectRepository = MockProjectRepository()
        fetchProjectsUseCase = DefaultFetchAllProjectsUseCase(projectRepository: projectRepository)
        fetchHotProjectsUseCase = DefaultFetchHotProjectsUseCase(projectRepository: projectRepository)
    }
    
    // MARK: - Methods
    func start() {
        showMainViewController()
    }
}

extension MainCoordinator {
    // MARK: - Show
    func showMainViewController() {
        let mainViewModel = MainViewModel(
            coordinator: self,
            fetchProjectsUseCase: fetchProjectsUseCase,
            fetchHotProjectsUseCase: fetchHotProjectsUseCase
        )
        
        let mainVC = MainViewController(viewModel: mainViewModel)
        navigationController.pushViewController(mainVC, animated: true)
    }
    
    // MARK: - ConnectCoordinator
    func connectToNotificationFlow() {
        print("알림 뷰 이동")
    }
    
    func connectToProjectFilteringFlow() {
        print("필터 뷰 이동")
    }
    
    func connectToProjectSearchFlow(with query: String) {
        print(query)
    }
    
    func connectToProjectDetailFlow(with id: String) {
        let projectDetailViewModel = ProjectDetailViewModel()
        let projectDetailVC = ProjectDetailViewController(viewModel: projectDetailViewModel)
        navigationController.pushViewController(projectDetailVC, animated: true)
    }
    
    func connectToCreateProjectFlow() {
        let createProjectCoordinator = CreateProjectCoordinator(navigationController: navigationController)
        createProjectCoordinator.delegate = self
        createProjectCoordinator.start()
        childCoordinators.append(createProjectCoordinator)
    }
}

// MARK: - CoordinatorDelegate
extension MainCoordinator: CoordinatorDelegate {
    func didFinish(childCoordinator: Coordinator) {
        navigationController.dismiss(animated: true)
        
        if let index = childCoordinators.firstIndex(where: { $0 === childCoordinator }) {
            childCoordinators.remove(at: index)
        }
    }
}
