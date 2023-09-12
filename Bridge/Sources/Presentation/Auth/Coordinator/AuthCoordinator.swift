//
//  AuthCoordinator.swift
//  Bridge
//
//  Created by 정호윤 on 2023/09/07.
//

import UIKit

final class AuthCoordinator: Coordinator {
    
    weak var delegate: CoordinatorDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showSignInViewController()
    }
}

extension AuthCoordinator {
    func showSignInViewController() {
        let signInViewModel = SignInViewModel(coordinator: self)
        let signInViewController = SignInViewController(viewModel: signInViewModel)
        navigationController.present(signInViewController, animated: true)
    }
    
    // 회원가입 플로우 추가
}
