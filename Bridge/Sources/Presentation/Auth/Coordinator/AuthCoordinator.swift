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
    
    private let authRepository: AuthRepository
    private let signInUseCase: SignInUseCase
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        
        let networkService = DefaultNetworkService()
        authRepository = DefaultAuthRepository(networkService: networkService)
        signInUseCase = DefaultSignInUseCase(authRepository: authRepository)
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
        signInNavigationController.setNavigationBarHidden(true, animated: false)
        
        // TODO: 로그인 화면에 x 버튼 추가하지 전까지 주석처리
//        signInNavigationController.modalPresentationStyle = .fullScreen
        
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
