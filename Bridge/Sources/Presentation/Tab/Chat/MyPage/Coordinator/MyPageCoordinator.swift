//
//  MyPageCoordinator.swift
//  Bridge
//
//  Created by 정호윤 on 11/6/23.
//

import UIKit
import SafariServices

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

// MARK: - External
extension MyPageCoordinator {
    func openSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString),
              UIApplication.shared.canOpenURL(settingsUrl)
        else { return }
        
        UIApplication.shared.open(settingsUrl)
    }
    
    func showOpenSourceLicense() {
        guard let url = URL(string: "https://shell-cardinal-3e8.notion.site/aa00892a9e5a4355824fc29680cf11e8?pvs=4") else {
            return
        }
        let safariViewController = SFSafariViewController(url: url)
        navigationController.present(safariViewController, animated: true)
    }
    
    func showPrivacyPolicy() {
        guard let url = URL(string: "https://shell-cardinal-3e8.notion.site/976beef192834c0daba4cd97835bf133?pvs=4") else {
            return
        }
        let safariViewController = SFSafariViewController(url: url)
        navigationController.present(safariViewController, animated: true)
    }
}
