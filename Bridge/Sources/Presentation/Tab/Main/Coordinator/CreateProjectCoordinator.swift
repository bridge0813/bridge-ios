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
    
    private let projectDataStorage = ProjectDataStorage()
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
            coordinator: self,
            dataStorage: projectDataStorage
        )
        
        let viewController = MemberFieldSelectionViewController(viewModel: viewModel)
        createProjectNavigationController = UINavigationController(rootViewController: viewController)
        createProjectNavigationController?.modalPresentationStyle = .fullScreen
        configureNavigationAppearance()
        
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

// MARK: - Configuration
extension CreateProjectCoordinator {
    private func configureNavigationAppearance() {
        let backButtonImage = UIImage(named: "chevron.left")?.resize(to: CGSize(width: 24, height: 24))
            
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.backgroundColor = BridgeColor.gray10
        appearance.shadowColor = nil
        appearance.titleTextAttributes = [
            .font: BridgeFont.subtitle1.font,
            .foregroundColor: BridgeColor.gray1
        ]
        appearance.setBackIndicatorImage(backButtonImage, transitionMaskImage: backButtonImage)
        appearance.backButtonAppearance = configureBackButtonAppearance()
        
        createProjectNavigationController?.navigationBar.standardAppearance = appearance
        createProjectNavigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    private func configureBackButtonAppearance() -> UIBarButtonItemAppearance {
        let backButtonAppearance = UIBarButtonItemAppearance()
        backButtonAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.clear,
            .font: UIFont.systemFont(ofSize: 0)
        ]
        
        return backButtonAppearance
    }
}
