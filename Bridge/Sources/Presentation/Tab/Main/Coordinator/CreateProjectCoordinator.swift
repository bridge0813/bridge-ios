//
//  CreateProjectCoordinator.swift
//  Bridge
//
//  Created by 엄지호 on 2023/09/11.
//

import UIKit

final class CreateProjectCoordinator: Coordinator {
    // MARK: - Property
    weak var delegate: CoordinatorDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator]
    
    private let projectDataStorage = ProjectDataStorage()
    private var createProjectNavigationController: UINavigationController?
    
    private let projectRepository: ProjectRepository
    private let createProjectUseCase: CreateProjectUseCase
    
    // MARK: - Init
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        childCoordinators = []
        
        let networkService = DefaultNetworkService()
        projectRepository = DefaultProjectRepository(networkService: networkService)
        createProjectUseCase = DefaultCreateProjectUseCase(projectRepository: projectRepository)
    }
    
    // MARK: - Methods
    func start() {
        showSetMemberFieldViewController()
    }
}

// MARK: - Show
extension CreateProjectCoordinator {
    private func showSetMemberFieldViewController() {
        let viewModel = SetMemberFieldViewModel(
            coordinator: self,
            dataStorage: projectDataStorage
        )
        
        let viewController = SetMemberFieldViewController(viewModel: viewModel)
        createProjectNavigationController = UINavigationController(rootViewController: viewController)
        createProjectNavigationController?.modalPresentationStyle = .fullScreen
        
        navigationController.present(
            createProjectNavigationController ?? UINavigationController(),
            animated: true
        )
    }
    
    func showSetMemberRequirementViewController(with selectedFields: [String]) {
        let viewModel = SetMemberRequirementViewModel(
            coordinator: self,
            selectedFields: selectedFields,
            dataStorage: projectDataStorage
        )

        let viewController = SetMemberRequirementViewController(viewModel: viewModel)
        createProjectNavigationController?.pushViewController(viewController, animated: true)
    }
    
    func showSetApplicantRestrictionViewController() {
        let viewModel = SetApplicantRestrictionViewModel(
            coordinator: self,
            dataStorage: projectDataStorage
        )
        
        let viewController = SetApplicantRestrictionViewController(viewModel: viewModel)
        createProjectNavigationController?.pushViewController(viewController, animated: true)
    }
    
    func showSetProjectScheduleViewController() {
        let viewModel = SetProjectScheduleViewModel(
            coordinator: self,
            dataStorage: projectDataStorage
        )
        
        let viewController = SetProjectScheduleViewController(viewModel: viewModel)
        createProjectNavigationController?.pushViewController(viewController, animated: true)
    }
    
    func showSetProjectProgressViewController() {
        let viewModel = SetProjectProgressViewModel(
            coordinator: self,
            dataStorage: projectDataStorage
        )
        
        let viewController = SetProjectProgressViewController(viewModel: viewModel)
        createProjectNavigationController?.pushViewController(viewController, animated: true)
    }
    
    func showSetProjectDescriptionViewController() {
        let viewModel = SetProjectDescriptionViewModel(
            coordinator: self,
            dataStorage: projectDataStorage,
            createProjectUseCase: createProjectUseCase
        )
        
        let viewController = SetProjectDescriptionViewController(viewModel: viewModel)
        createProjectNavigationController?.pushViewController(viewController, animated: true)
    }
    
    func showCompletionViewController(with projectID: Int) {
        let viewModel = CompletionViewModel(
            coordinator: self,
            projectID: projectID
        )
        
        let viewController = CompletionViewController(viewModel: viewModel)
        createProjectNavigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - Connect
extension CreateProjectCoordinator {
    func connectToProjectDetailFlow(with projectID: Int) {
        let detailCoordinator = ProjectDetailCoordinator(
            navigationController: createProjectNavigationController ?? navigationController
        )
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
}

// MARK: - CoordinatorDelegate
extension CreateProjectCoordinator: CoordinatorDelegate {
    func didFinish(childCoordinator: Coordinator) {
        navigationController.dismiss(animated: true)
        
        if let index = childCoordinators.firstIndex(where: { $0 === childCoordinator }) {
            childCoordinators.remove(at: index)
        }
    }
}
