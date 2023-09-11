//
//  AuthCoordinator.swift
//  Bridge
//
//  Created by 정호윤 on 2023/09/07.
//

import UIKit

protocol AuthCoordinatorProtocol: Coordinator {
    func showSignInViewController()
    func connectSignUpFlow(to: UINavigationController)
}

final class AuthCoordinator: AuthCoordinatorProtocol {
    
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
    
    func connectSignUpFlow(to: UINavigationController) {
        let signUpCoordinator = SignUpCoordinator(navigationController: navigationController)
        signUpCoordinator.start()
        childCoordinators.append(signUpCoordinator)
    }
}
