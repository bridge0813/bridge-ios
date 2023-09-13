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
        
        let signInNavigationController = UINavigationController(rootViewController: signInViewController)
        signInNavigationController.setNavigationBarHidden(true, animated: false)
        signInNavigationController.modalPresentationStyle = .overFullScreen
        
        navigationController.present(signInNavigationController, animated: true)
    }
    
    // 회원가입 플로우
    func showSelectFieldViewController() {
        let selectFieldViewModel = SelectFieldViewModel(coordinator: self)
        let selectFieldViewController = SelectFieldViewController(viewModel: selectFieldViewModel)
        
        if let signInNavController = navigationController.presentedViewController as? UINavigationController {
            signInNavController.pushViewController(selectFieldViewController, animated: true)
        }
    }
}
