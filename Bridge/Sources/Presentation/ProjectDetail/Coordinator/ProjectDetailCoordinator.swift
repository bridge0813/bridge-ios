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
    var childCoordinators: [Coordinator]
    
    // MARK: - Init
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.childCoordinators = []

    }
    
    // MARK: - Methods
    func start() {
        showProjectDetailViewController()
    }
}

extension ProjectDetailCoordinator {
    // MARK: - Show
    func showProjectDetailViewController() {
        let viewModel = ProjectDetailViewModel(
            coordinator: self
        )
        
        let vc = ProjectDetailViewController(viewModel: viewModel)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showRecruitFieldDetailViewController(with requirements: [MemberRequirement]) {
        let viewModel = RecruitFieldDetailViewModel(
            coordinator: self,
            requirements: requirements
        )
        
        let vc = RecruitFieldDetailViewController(viewModel: viewModel)
        navigationController.pushViewController(vc, animated: true)
    }
}
