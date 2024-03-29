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
    var didFinishEventClosure: (() -> Void)?  // disAppear 시점에 자식 코디네이터에서 할당을 제거하기 위함.
    
    private let authRepository: AuthRepository
    private let userRepository: UserRepository
    private let alertRepository: AlertRepository
    private let projectRepository: ProjectRepository
    private let fileRepository: FileRepository
    
    private let signOutUseCase: SignOutUseCase
    private let withdrawUseCase: WithdrawUseCase
    
    private let fetchAlertsUseCase: FetchAlertsUseCase
    private let removeAlertUseCase: RemoveAlertUseCase
    
    private let changeFieldUseCase: ChangeFieldUseCase
    private let fetchBookmarkedProjectUseCase: FetchBookmarkedProjectsUseCase
    private let bookmarkUseCase: BookmarkUseCase
    
    private let fetchProfileUseCase: FetchProfileUseCase
    private let createProfileUseCase: CreateProfileUseCase
    private let updateProfileUseCase: UpdateProfileUseCase
    private let downloadFileUseCase: DownloadFileUseCase
    
    // MARK: - Init
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.childCoordinators = []
        
        let networkService = DefaultNetworkService()
        authRepository = DefaultAuthRepository(networkService: networkService)
        userRepository = DefaultUserRepository(networkService: networkService)
        alertRepository = DefaultAlertRepository(networkService: networkService)
        projectRepository = DefaultProjectRepository(networkService: networkService)
        fileRepository = DefaultFileRepository(networkService: networkService)
//        authRepository = MockAuthRepository()
//        userRepository = MockUserRepository()
//        alertRepository = MockAlertRepository()
//        projectRepository = MockProjectRepository()
        
        signOutUseCase = DefaultSignOutUseCase(authRepository: authRepository)
        withdrawUseCase = DefaultWithdrawUseCase(authRepository: authRepository)
        
        fetchAlertsUseCase = DefaultFetchAlertsUseCase(alertRepository: alertRepository)
        removeAlertUseCase = DefaultRemoveAlertUseCase(alertRepository: alertRepository)
        
        changeFieldUseCase = DefaultChangeFieldUseCase(userRepository: userRepository)
        fetchBookmarkedProjectUseCase = DefaultFetchBookmarkedProjectsUseCase(userRepository: userRepository)
        bookmarkUseCase = DefaultBookmarkUseCase(projectRepository: projectRepository)
        
        fetchProfileUseCase = DefaultFetchProfileUseCase(userRepository: userRepository)
        createProfileUseCase = DefaultCreateProfileUseCase(userRepository: userRepository)
        updateProfileUseCase = DefaultUpdateProfileUseCase(userRepository: userRepository)
        
        downloadFileUseCase = DefaultDownloadFileUseCase(fileRepository: fileRepository)
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
            fetchProfileUseCase: fetchProfileUseCase,
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
    
    func showProfileViewController() {
        let profileViewModel = ProfileViewModel(
            coordinator: self,
            fetchProfileUseCase: fetchProfileUseCase,
            downloadFileUseCase: downloadFileUseCase
        )
        let profileViewController = ProfileViewController(viewModel: profileViewModel)
        navigationController.pushViewController(profileViewController, animated: true)
    }
    
    func showCreateProfileViewController() {
        let createProfileViewModel = CreateProfileViewModel(
            coordinator: self,
            fetchProfileUseCase: fetchProfileUseCase, 
            createProfileUseCase: createProfileUseCase
        )
        let createProfileViewController = CreateProfileViewController(viewModel: createProfileViewModel)
        navigationController.pushViewController(createProfileViewController, animated: true)
    }
    
    func showUpdatProfileViewController(with profile: Profile) {
        let updateProfileViewModel = UpdateProfileViewModel(
            coordinator: self,
            profile: profile, 
            updateProfileUseCase: updateProfileUseCase
        )
        let updateProfileViewController = UpdateProfileViewController(viewModel: updateProfileViewModel)
        navigationController.pushViewController(updateProfileViewController, animated: true)
    }
    
    // MARK: - Connect
    func connectToProjectDetailFlow(with projectID: Int) {
        let detailCoordinator = ProjectDetailCoordinator(navigationController: navigationController)
        detailCoordinator.showProjectDetailViewController(projectID: projectID)
        detailCoordinator.didFinishEventClosure = { [weak self] in
            guard let self else { return }
            if let index = self.childCoordinators.firstIndex(where: { $0 === detailCoordinator }) {
                self.childCoordinators.remove(at: index)
            }
        }
        childCoordinators.append(detailCoordinator)
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
        delegate?.showWebPage(
            with: "https://shell-cardinal-3e8.notion.site/aa00892a9e5a4355824fc29680cf11e8?pvs=4",
            navigationController: navigationController
        )
    }
    
    func showPrivacyPolicy() {
        delegate?.showWebPage(
            with: "https://shell-cardinal-3e8.notion.site/976beef192834c0daba4cd97835bf133?pvs=4",
            navigationController: navigationController
        )
    }
    
    /// 프로필에서 참고링크를 보여주는 메서드.
    func showReferenceLink(with urlString: URLString) {
        delegate?.showWebPage(
            with: urlString,
            navigationController: navigationController
        )
    }
}
