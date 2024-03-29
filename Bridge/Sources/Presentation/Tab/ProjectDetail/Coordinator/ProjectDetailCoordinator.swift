//
//  ProjectDetailCoordinator.swift
//  Bridge
//
//  Created by 엄지호 on 2023/11/13.
//

import UIKit

final class ProjectDetailCoordinator: Coordinator {
    // MARK: - Property
    weak var delegate: CoordinatorDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var didFinishEventClosure: (() -> Void)?  // disAppear 시점에 자식 코디네이터에서 할당을 제거하기 위함.
    
    private let projectRepository: ProjectRepository
    private let applicantRepository: ApplicantRepository
    
    private let projectDetailUseCase: FetchProjectDetailUseCase
    private let bookmarkUseCase: BookmarkUseCase
    private let applyUseCase: ApplyProjectUseCase
    private let deleteUseCase: DeleteProjectUseCase
    private let closeUseCase: CloseProjectUseCase
    
    // MARK: - Init
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        
        let networkService = DefaultNetworkService()
        projectRepository = DefaultProjectRepository(networkService: networkService)
        applicantRepository = DefaultApplicantRepository(networkService: networkService)
//        projectRepository = MockProjectRepository()
//        applicantRepository = MockApplicantRepository()
        
        projectDetailUseCase = DefaultFetchProjectDetailUseCase(projectRepository: projectRepository)
        bookmarkUseCase = DefaultBookmarkUseCase(projectRepository: projectRepository)
        applyUseCase = DefaultApplyProjectUseCase(applicantRepository: applicantRepository)
        deleteUseCase = DefaultDeleteProjectUseCase(projectRepository: projectRepository)
        closeUseCase = DefaultCloseProjectUseCase(projectRepository: projectRepository)
    }
    
    // MARK: - Methods
    func start() { }
}

// MARK: - Show
extension ProjectDetailCoordinator {
    func showProjectDetailViewController(projectID: Int) {
        let viewModel = ProjectDetailViewModel(
            coordinator: self, 
            projectID: projectID,
            projectDetailUseCase: projectDetailUseCase,
            bookmarkUseCase: bookmarkUseCase,
            applyUseCase: applyUseCase,
            deleteUseCase: deleteUseCase,
            closeUseCase: closeUseCase
        )
        
        let vc = ProjectDetailViewController(viewModel: viewModel)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showRecruitFieldDetailViewController(with project: Project) {
        let viewModel = RecruitFieldDetailViewModel(
            coordinator: self,
            project: project
        )
        
        let vc = RecruitFieldDetailViewController(viewModel: viewModel)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showSignInViewController() {
        delegate?.showSignInViewController()
    }
}

// MARK: - Connect
extension ProjectDetailCoordinator {
    func connectToUpdateProjectFlow(with newProject: Project) {
        let updateProjectCoordinator = UpdateProjectCoordinator(navigationController: navigationController)
        updateProjectCoordinator.delegate = self
        updateProjectCoordinator.start(with: newProject)
        childCoordinators.append(updateProjectCoordinator)
    }
}

// MARK: - CoordinatorDelegate
extension ProjectDetailCoordinator: CoordinatorDelegate {
    func didFinish(childCoordinator: Coordinator) {
        navigationController.dismiss(animated: true)

        if let index = childCoordinators.firstIndex(where: { $0 === childCoordinator }) {
            childCoordinators.remove(at: index)
        }
    }
}
