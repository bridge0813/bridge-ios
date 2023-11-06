//
//  MyPageCoordinator.swift
//  Bridge
//
//  Created by 정호윤 on 11/6/23.
//

import UIKit

final class MyPageCoordinator: Coordinator {
    // MARK: - Property
    weak var delegate: CoordinatorDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator]
    
    private let authRepository: AuthRepository
    
    // MARK: - Init
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.childCoordinators = []
        
        let networkService = DefaultNetworkService()
        authRepository = DefaultAuthRepository(networkService: networkService)
    }
    
    // MARK: - Start
    func start() {
        showMyPageViewController()
    }
}

// MARK: - My page
extension MyPageCoordinator {
    private func showMyPageViewController() {
        let myPageViewModel = MyPageViewModel(coordinator: self)
        let myPageViewController = MyPageViewController(viewModel: myPageViewModel)
        navigationController.pushViewController(myPageViewController, animated: false)
    }
}

// MARK: - Auth
extension MyPageCoordinator {
    func showSignInViewController() {
        delegate?.showSignInViewController()
    }
}
