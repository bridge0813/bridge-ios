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
        showMemberFieldSelectionViewController()
    }
}

// MARK: - Show
extension CreateProjectCoordinator {
    private func showMemberFieldSelectionViewController() {
        let viewModel = MemberFieldSelectionViewModel(
            coordinator: self,
            dataStorage: projectDataStorage
        )
        
        let viewController = MemberFieldSelectionViewController(viewModel: viewModel)
        createProjectNavigationController = UINavigationController(rootViewController: viewController)
        createProjectNavigationController?.modalPresentationStyle = .fullScreen
        
        navigationController.present(
            createProjectNavigationController ?? UINavigationController(),
            animated: true
        )
    }
    
    func showMemberRequirementInputViewController(with selectedFields: [String]) {
        let viewModel = MemberRequirementInputViewModel(
            coordinator: self,
            selectedFields: selectedFields,
            dataStorage: projectDataStorage
        )

        let viewController = MemberRequirementInputViewController(viewModel: viewModel)
        createProjectNavigationController?.pushViewController(viewController, animated: true)
    }
    
    func showApplicantRestrictionViewController() {
        let viewModel = ApplicantRestrictionViewModel(
            coordinator: self,
            dataStorage: projectDataStorage
        )
        
        let viewController = ApplicantRestrictionViewController(viewModel: viewModel)
        createProjectNavigationController?.pushViewController(viewController, animated: true)
    }
    
    func showProjectDatePickerViewController() {
        let viewModel = ProjectDatePickerViewModel(
            coordinator: self,
            dataStorage: projectDataStorage
        )
        
        let viewController = ProjectDatePickerViewController(viewModel: viewModel)
        createProjectNavigationController?.pushViewController(viewController, animated: true)
    }
    
    func showProjectProgressStatusViewController() {
        let viewModel = ProjectProgressStatusViewModel(
            coordinator: self,
            dataStorage: projectDataStorage
        )
        
        let viewController = ProjectProgressStatusViewController(viewModel: viewModel)
        createProjectNavigationController?.pushViewController(viewController, animated: true)
    }
    
    func showProjectDescriptionInputViewController() {
        let viewModel = ProjectDescriptionInputViewModel(
            coordinator: self,
            dataStorage: projectDataStorage,
            createProjectUseCase: createProjectUseCase
        )
        
        let viewController = ProjectDescriptionInputViewController(viewModel: viewModel)
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
            self?.didFinish(childCoordinator: detailCoordinator)
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
