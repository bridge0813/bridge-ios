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
    
    private let userRepository: UserRepository
    private let projectRepository: ProjectRepository
    private let searchRepository: SearchRepository
    
    private let fetchProfileUseCase: FetchProfileUseCase
    private let fetchAllProjectsUseCase: FetchAllProjectsUseCase
    private let fetchProjectsByFieldUseCase: FetchProjectsByFieldUseCase
    private let fetchHotProjectsUseCase: FetchHotProjectsUseCase
    private let fetchDeadlineProjectsUseCase: FetchDeadlineProjectsUseCase
    private let fetchFilteredProjectsUseCase: FetchFilteredProjectsUseCase
    private let bookmarkUseCase: BookmarkUseCase
    
    private let fetchRecentSearchUseCase: FetchRecentSearchUseCase
    private let searchProjectsUseCase: SearchProjectsUseCase
    private let removeSearchUseCase: RemoveSearchUseCase
    
    // MARK: - Init
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.childCoordinators = []

        let networkService = DefaultNetworkService()
        userRepository = DefaultUserRepository(networkService: networkService)  // 프로필 리포지토리
        projectRepository = DefaultProjectRepository(networkService: networkService)  // 모집글 리포지토리
        searchRepository = DefaultSearchRepository(networkService: networkService)
//        userRepository = MockUserRepository()
//        projectRepository = MockProjectRepository()
//        searchRepository = MockSearchRepository()
        
        fetchProfileUseCase = DefaultFetchProfileUseCase(userRepository: userRepository)
        fetchAllProjectsUseCase = DefaultFetchAllProjectsUseCase(projectRepository: projectRepository)
        fetchProjectsByFieldUseCase = DefaultFetchProjectsByFieldUseCase(projectRepository: projectRepository)
        fetchHotProjectsUseCase = DefaultFetchHotProjectsUseCase(projectRepository: projectRepository)
        fetchDeadlineProjectsUseCase = DefaultFetchDeadlineProjectsUseCase(projectRepository: projectRepository)
        fetchFilteredProjectsUseCase = DefaultFetchFilteredProjectsUseCase(projectRepository: projectRepository)
        bookmarkUseCase = DefaultBookmarkUseCase(projectRepository: projectRepository)
        
        fetchRecentSearchUseCase = DefaultFetchRecentSearchUseCase(searchRepository: searchRepository)
        searchProjectsUseCase = DefaultSearchProjectsUseCase(searchRepository: searchRepository)
        removeSearchUseCase = DefaultRemoveSearchUseCase(searchRepository: searchRepository)
    }
    
    // MARK: - Methods
    func start() {
        showMainViewController()
    }
}

// MARK: - Show
extension MainCoordinator {
    func showMainViewController() {
        let mainViewModel = MainViewModel(
            coordinator: self,
            fetchProfileUseCase: fetchProfileUseCase,
            fetchAllProjectsUseCase: fetchAllProjectsUseCase,
            fetchProjectsByFieldUseCase: fetchProjectsByFieldUseCase,
            fetchHotProjectsUseCase: fetchHotProjectsUseCase,
            fetchDeadlineProjectsUseCase: fetchDeadlineProjectsUseCase,
            bookmarkUseCase: bookmarkUseCase
        )
        
        let mainVC = MainViewController(viewModel: mainViewModel)
        navigationController.pushViewController(mainVC, animated: true)
    }
    
    func showFilterViewController(with fieldTechStack: FieldTechStack) {
        let filterViewModel = FilteredProjectListViewModel(
            coordinator: self,
            fieldTechStack: fieldTechStack,
            fetchFilteredProjectsUseCase: fetchFilteredProjectsUseCase, 
            bookmarkUseCase: bookmarkUseCase
        )
        
        let filterVC = FilteredProjectListViewController(viewModel: filterViewModel)
        navigationController.pushViewController(filterVC, animated: true)
    }
    
    func showSearchViewController() {
        let searchProjectViewModel = SearchProjectViewModel(
            coordinator: self, 
            fetchRecentSearchUseCase: fetchRecentSearchUseCase, 
            removeSearchUseCase: removeSearchUseCase,
            searchProjectsUseCase: searchProjectsUseCase,
            bookmarkUseCase: bookmarkUseCase
        )
        
        let searchVC = SearchProjectViewController(viewModel: searchProjectViewModel)
        navigationController.pushViewController(searchVC, animated: true)
    }
    
    func showSignInViewController() {
        delegate?.showSignInViewController()
    }
    
    // MARK: - Connect
    func connectToNotificationFlow() {
        print("알림 뷰 이동")
    }
    
    func connectToProjectFilteringFlow() {
        print("필터 뷰 이동")
    }
    
    func connectToProjectSearchFlow() {
        print("검색 뷰 이동")
    }
    
    func connectToProjectDetailFlow(with projectID: Int) {
        let detailCoordinator = ProjectDetailCoordinator(navigationController: navigationController)
        detailCoordinator.delegate = self
        detailCoordinator.showProjectDetailViewController(projectID: projectID)
        detailCoordinator.didFinishEventClosure = { [weak self] in
            guard let self else { return }
            if let index = self.childCoordinators.firstIndex(where: { $0 === detailCoordinator }) {
                self.childCoordinators.remove(at: index)
            }
        }
        childCoordinators.append(detailCoordinator)
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
