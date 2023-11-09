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
    var childCoordinators: [Coordinator]
    
    private let authRepository: AuthRepository
    private let signInUseCase: SignInUseCase
    private let signUpUseCase: SignUpUseCase
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        childCoordinators = []
        
        let networkService = DefaultNetworkService()
        let tokenStorage = KeychainTokenStorage()
        authRepository = DefaultAuthRepository(networkService: networkService, tokenStorage: tokenStorage)
        signInUseCase = DefaultSignInUseCase(authRepository: authRepository)
        signUpUseCase = DefaultSignUpUseCase(authRepository: authRepository)
    }
    
    func start() {
        showSignInViewController()
    }
}

extension AuthCoordinator {
    func showSignInViewController() {
        let signInViewModel = SignInViewModel(coordinator: self, signInUseCase: signInUseCase)
        let signInViewController = SignInViewController(viewModel: signInViewModel)
        let signInNavigationController = UINavigationController(rootViewController: signInViewController)
        signInNavigationController.modalPresentationStyle = .fullScreen
        navigationController.present(signInNavigationController, animated: true)
    }
    
    // 회원가입 플로우
    func showSetFieldViewController() {
        let selectFieldViewModel = SetFieldViewModel(coordinator: self, signUpUseCase: signUpUseCase)
        let selectFieldViewController = SetFieldViewController(viewModel: selectFieldViewModel)
        
        if let signInNavController = navigationController.presentedViewController as? UINavigationController {
            signInNavController.pushViewController(selectFieldViewController, animated: true)
        }
    }
}
