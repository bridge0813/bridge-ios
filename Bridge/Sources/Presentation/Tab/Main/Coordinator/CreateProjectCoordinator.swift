//
//  CreateProjectCoordinator.swift
//  Bridge
//
//  Created by 엄지호 on 2023/09/11.
//

import UIKit

// MARK: - Protocol
protocol CreateProjectCoordinatorProtocol: Coordinator {
    
}

final class CreateProjectCoordinator: CreateProjectCoordinatorProtocol {
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
    
    func showMemberDetailInputViewController() {
        let viewModel = MemberDetailInputViewModel(
            coordinator: self
        )
        
        let viewController = MemberDetailInputViewController(viewModel: viewModel)
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
    
    func showProjectOverviewInputViewController() {
        let viewModel = ProjectOverviewInputViewModel(
            coordinator: self
        )
        
        let viewController = ProjectOverviewInputViewController(viewModel: viewModel)
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

// MARK: - MainCoordinatorProtocol Method
extension MainCoordinator {
    
}
