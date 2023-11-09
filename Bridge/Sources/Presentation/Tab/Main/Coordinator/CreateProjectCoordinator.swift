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
    
    // MARK: - Init
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.childCoordinators = []
    }
    
    // MARK: - Methods
    func start() {
        showMemberFieldSelectionViewController()
    }
}

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
            dataStorage: projectDataStorage
        )
        
        let viewController = ProjectDescriptionInputViewController(viewModel: viewModel)
        createProjectNavigationController?.pushViewController(viewController, animated: true)
    }
    
    func showCompletionViewController() {
        let viewModel = CompletionViewModel(
            coordinator: self
        )
        
        let viewController = CompletionViewController(viewModel: viewModel)
        createProjectNavigationController?.pushViewController(viewController, animated: true)
    }
}
