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
        
        projectDetailUseCase = DefaultFetchProjectDetailUseCase(projectRepository: projectRepository)
        bookmarkUseCase = DefaultBookmarkUseCase(projectRepository: projectRepository)
        applyUseCase = DefaultApplyProjectUseCase(projectRepository: projectRepository)
        deleteUseCase = DefaultDeleteProjectUseCase(projectRepository: projectRepository)
        closeUseCase = DefaultCloseProjectUseCase(projectRepository: projectRepository)
    }
    
    // MARK: - Methods
    func start() { }
}

extension ProjectDetailCoordinator {
    // MARK: - Show
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
