//
//  MyPageCoordinator.swift
//  Bridge
//
//  Created by 정호윤 on 11/6/23.
//

import SafariServices
import UIKit

final class MyPageCoordinator: Coordinator {
    // MARK: - Property
    weak var delegate: CoordinatorDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator]
    
    private let authRepository: AuthRepository
    private let userRepository: UserRepository
    private let alertRepository: AlertRepository
    private let projectRepository: ProjectRepository
    
    private let signOutUseCase: SignOutUseCase
    private let withdrawUseCase: WithdrawUseCase
    private let fetchProfilePreviewUseCase: FetchProfilePreviewUseCase
    
    private let fetchAlertsUseCase: FetchAlertsUseCase
    private let removeAlertUseCase: RemoveAlertUseCase
    
    private let changeFieldUseCase: ChangeFieldUseCase
    private let fetchBookmarkedProjectUseCase: FetchBookmarkedProjectsUseCase
    private let bookmarkUseCase: BookmarkUseCase
    
    // MARK: - Init
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.childCoordinators = []
        
        let networkService = DefaultNetworkService()
        authRepository = DefaultAuthRepository(networkService: networkService)
        userRepository = DefaultUserRepository(networkService: networkService)
        alertRepository = DefaultAlertRepository(networkService: networkService)
        projectRepository = DefaultProjectRepository(networkService: networkService)
//        authRepository = MockAuthRepository()
//        userRepository = MockUserRepository()
//        alertRepository = MockAlertRepository()
//        projectRepository = MockProjectRepository()
        
        fetchProfilePreviewUseCase = DefaultFetchProfilePreviewUseCase(userRepository: userRepository)
        signOutUseCase = DefaultSignOutUseCase(authRepository: authRepository)
        withdrawUseCase = DefaultWithdrawUseCase(authRepository: authRepository)
        
        fetchAlertsUseCase = DefaultFetchAlertsUseCase(alertRepository: alertRepository)
        removeAlertUseCase = DefaultRemoveAlertUseCase(alertRepository: alertRepository)
        
        changeFieldUseCase = DefaultChangeFieldUseCase(userRepository: userRepository)
        fetchBookmarkedProjectUseCase = DefaultFetchBookmarkedProjectsUseCase(userRepository: userRepository)
        bookmarkUseCase = DefaultBookmarkUseCase(projectRepository: projectRepository)
    }
    
    // MARK: - Start
    func start() {
        showMyPageViewController()
    }
}

// MARK: - My page
extension MyPageCoordinator {
    private func showMyPageViewController() {
        let myPageViewModel = MyPageViewModel(
            coordinator: self,
            fetchProfilePreviewUseCase: fetchProfilePreviewUseCase,
            signOutUseCase: signOutUseCase,
            withdrawUseCase: withdrawUseCase
        )
        let myPageViewController = MyPageViewController(viewModel: myPageViewModel)
        navigationController.pushViewController(myPageViewController, animated: false)
    }
    
    func showPushAlertViewController() {
        let alertViewModel = AlertViewModel(
            coordinator: self,
            fetchAlertsUseCase: fetchAlertsUseCase,
            removeAlertUseCase: removeAlertUseCase
        )
        let alertViewController = AlertViewController(viewModel: alertViewModel)
        navigationController.pushViewController(alertViewController, animated: true)
    }
    
    func showMyFieldViewController() {
        let myFieldViewModel = MyFieldViewModel(
            coordinator: self,
            changeFieldUseCase: changeFieldUseCase
        )
        let myFieldViewController = MyFieldViewController(viewModel: myFieldViewModel)
        navigationController.pushViewController(myFieldViewController, animated: true)
    }
    
    func showBookmarkedProjectViewController() {
        let bookmarkedProjectViewModel = BookmarkedProjectViewModel(
            coordinator: self,
            fetchBookmarkedProjectUseCase: fetchBookmarkedProjectUseCase,
            bookmarkUseCase: bookmarkUseCase
        )
        let bookmarkedProjectViewController = BookmarkedProjectViewController(viewModel: bookmarkedProjectViewModel)
        navigationController.pushViewController(bookmarkedProjectViewController, animated: true)
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
