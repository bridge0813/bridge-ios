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
    
    private let profileRepository: ProfileRepository
    private let projectRepository: ProjectRepository
    
    private let fetchProfilePreviewUseCase: FetchProfilePreviewUseCase
    private let fetchAllProjectsUseCase: FetchAllProjectsUseCase
    private let fetchProjectsByFieldUseCase: FetchProjectsByFieldUseCase
    private let fetchHotProjectsUseCase: FetchHotProjectsUseCase
    
    // MARK: - Init
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.childCoordinators = []

        let networkService = DefaultNetworkService()
        profileRepository = DefaultProfileRepository(networkService: networkService)  // 프로필
        projectRepository = DefaultProjectRepository(networkService: networkService)  // 모집글
        
        fetchProfilePreviewUseCase = DefaultFetchProfilePreviewUseCase(profileRepository: profileRepository)
        fetchAllProjectsUseCase = DefaultFetchAllProjectsUseCase(projectRepository: projectRepository)
        fetchProjectsByFieldUseCase = DefaultFetchProjectsByFieldUseCase(projectRepository: projectRepository)
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
            fetchProfilePreviewUseCase: fetchProfilePreviewUseCase,
            fetchAllProjectsUseCase: fetchAllProjectsUseCase,
            fetchProjectsByFieldUseCase: fetchProjectsByFieldUseCase,
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
        // TODO: - 연결된 코디네이터 제거 작업
        let coordinator = ProjectDetailCoordinator(navigationController: navigationController)
        coordinator.start()
        childCoordinators.append(coordinator)
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
