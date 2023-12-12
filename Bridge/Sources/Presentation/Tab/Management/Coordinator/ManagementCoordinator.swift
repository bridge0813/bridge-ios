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
    private let profileRepository: ProfileRepository
    
    private let fetchAppliedProjectsUseCase: FetchAppliedProjectsUseCase
    private let fetchMyProjectsUseCase: FetchMyProjectsUseCase
    private let deleteProjectUseCase: DeleteProjectUseCase
    
    private let fetchApplicantListUseCase: FetchApplicantListUseCase
    private let acceptApplicantUseCase: AcceptApplicantUseCase
    
    // MARK: - Init
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.childCoordinators = []

        let networkService = DefaultNetworkService()
        projectRepository = MockProjectRepository()
        profileRepository = MockProfileRepository()

        fetchAppliedProjectsUseCase = DefaultFetchAppliedProjectsUseCase(projectRepository: projectRepository)
        fetchMyProjectsUseCase = DefaultFetchMyProjectsUseCase(projectRepository: projectRepository)
        deleteProjectUseCase = DefaultDeleteProjectUseCase(projectRepository: projectRepository)
        fetchApplicantListUseCase = DefaultFetchApplicantListUseCase(profileRepository: profileRepository)
        acceptApplicantUseCase = DefaultAcceptApplicantUseCasee(projectRepository: projectRepository)
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
            fetchAppliedProjectsUseCase: fetchAppliedProjectsUseCase,
            fetchMyProjectsUseCase: fetchMyProjectsUseCase,
            deleteProjectUseCase: deleteProjectUseCase
        )
        
        let vc = ManagementViewController(viewModel: viewModel)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showApplicantListViewController(with projectID: Int) {
        let viewModel = ApplicantListViewModel(
            coordinator: self,
            projectID: projectID, 
            fetchApplicantListUseCase: fetchApplicantListUseCase, 
            acceptApplicantUseCase: acceptApplicantUseCase
        )
        
        let vc = ApplicantListViewController(viewModel: viewModel)
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
