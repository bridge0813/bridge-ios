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
        createProjectNavigationController?.setNavigationBarHidden(true, animated: false)
        createProjectNavigationController?.modalPresentationStyle = .overFullScreen
        
        navigationController.present(
            createProjectNavigationController ?? UINavigationController(),
            animated: true
        )
    }
    
    func showMemberDetailInputViewController(for selectedFields: [String], fieldRequirements: [MemberRequirement]) {
        let viewModel = MemberDetailInputViewModel(
            coordinator: self,
            selectedFields: selectedFields,
            fieldRequirements: fieldRequirements
        )

        let viewController = MemberDetailInputViewController(viewModel: viewModel)
        createProjectNavigationController?.pushViewController(viewController, animated: true)
    }
    
    func showApplicantRestrictionViewController(fieldRequirements: [FieldRequirement]) {
        let viewModel = ApplicantRestrictionViewModel(
            coordinator: self,
            fieldRequirements: fieldRequirements
        )
        
        print(fieldRequirements)
        let viewController = ApplicantRestrictionViewController(viewModel: viewModel)
        createProjectNavigationController?.pushViewController(viewController, animated: true)
    }
    
    func showProjectDatePickerViewController() {
        let viewModel = ProjectDatePickerViewModel(
            coordinator: self
        )
        
        let viewController = ProjectDatePickerViewController(viewModel: viewModel)
        createProjectNavigationController?.pushViewController(viewController, animated: true)
    }
    
    func showProjectProgressStatusViewController() {
        let viewModel = ProjectProgressStatusViewModel(
            coordinator: self
        )
        
        let viewController = ProjectProgressStatusViewController(viewModel: viewModel)
        createProjectNavigationController?.pushViewController(viewController, animated: true)
    }
    
    func showProjectDescriptionInputViewController() {
        let viewModel = ProjectDescriptionInputViewModel(
            coordinator: self
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
