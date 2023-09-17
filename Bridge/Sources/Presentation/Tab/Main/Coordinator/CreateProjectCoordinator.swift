//
//  CreateProjectCoordinator.swift
//  Bridge
//
//  Created by 엄지호 on 2023/09/11.
//

import UIKit

final class CreateProjectCoordinator: Coordinator {
    // MARK: - Properties
    weak var delegate: CoordinatorDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator]
    
    private var createProjectNavigationController: UINavigationController?
    
    // MARK: - Initializer
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
            coordinator: self
        )
        
        let viewController = MemberFieldSelectionViewController(viewModel: viewModel)
        createProjectNavigationController = UINavigationController(rootViewController: viewController)
        createProjectNavigationController?.modalPresentationStyle = .overFullScreen
        
        navigationController.present(
            createProjectNavigationController ?? UINavigationController(),
            animated: true
        )
    }
    
    func showMemberRequirementInputViewController(
        with selectedFields: [String],
        memberRequirements: [MemberRequirement]
    ) {
        let viewModel = MemberRequirementInputViewModel(
            coordinator: self,
            selectedFields: selectedFields,
            memberRequirements: memberRequirements
        )

        let viewController = MemberRequirementInputViewController(viewModel: viewModel)
        createProjectNavigationController?.pushViewController(viewController, animated: true)
    }
    
    func showApplicantRestrictionViewController(with memberRequirements: [MemberRequirement]) {
        let viewModel = ApplicantRestrictionViewModel(
            coordinator: self,
            memberRequirements: memberRequirements
        )
        
        let viewController = ApplicantRestrictionViewController(viewModel: viewModel)
        createProjectNavigationController?.pushViewController(viewController, animated: true)
    }
    
    func showProjectDatePickerViewController(with project: Project) {
        let viewModel = ProjectDatePickerViewModel(
            coordinator: self,
            project: project
        )
        
        let viewController = ProjectDatePickerViewController(viewModel: viewModel)
        createProjectNavigationController?.pushViewController(viewController, animated: true)
    }
    
    func showProjectProgressStatusViewController(with project: Project) {
        let viewModel = ProjectProgressStatusViewModel(
            coordinator: self,
            project: project
        )
        
        let viewController = ProjectProgressStatusViewController(viewModel: viewModel)
        createProjectNavigationController?.pushViewController(viewController, animated: true)
    }
    
    func showProjectDescriptionInputViewController(with project: Project) {
        let viewModel = ProjectDescriptionInputViewModel(
            coordinator: self,
            project: project
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
