//
//  ManagementCoordinator.swift
//  Bridge
//
//  Created by 엄지호 on 12/6/23.
//

import UIKit

final class ManagementCoordinator: Coordinator {
    // MARK: - Property
    weak var delegate: CoordinatorDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator]
    
    private let projectRepository: ProjectRepository
    private let applicantRepository: ApplicantRepository
    
    private let fetchAppliedProjectsUseCase: FetchAppliedProjectsUseCase
    private let fetchMyProjectsUseCase: FetchMyProjectsUseCase
    private let deleteProjectUseCase: DeleteProjectUseCase
    private let cancelApplicationUseCase: CancelApplicationUseCase
    
    private let fetchApplicantListUseCase: FetchApplicantListUseCase
    private let acceptApplicantUseCase: AcceptApplicantUseCase
    private let rejectApplicantUseCase: RejectApplicantUseCase
    
    // 채널방 개설 및 보여주기
    private let createChannelUseCase: CreateChannelUseCase
    private let channelRepository: ChannelRepository
    
    // 다른 유저의 프로필 보여주기
    private let userRepository: UserRepository
    private let fileRepository: FileRepository
    private let fetchProfileUseCase: FetchProfileUseCase
    private let downloadFileUseCase: DownloadFileUseCase
    
    // MARK: - Init
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.childCoordinators = []

        // 네트워크 서비스
        let networkService = DefaultNetworkService()
        let stompService = DefaultStompService(webSocketService: DefaultWebSocketService.shared)
        
//        projectRepository = DefaultProjectRepository(networkService: networkService)
//        applicantRepository = DefaultApplicantRepository(networkService: networkService)
        projectRepository = MockProjectRepository()
        applicantRepository = MockApplicantRepository()
        
        // 관리
        fetchAppliedProjectsUseCase = DefaultFetchAppliedProjectsUseCase(projectRepository: projectRepository)
        fetchMyProjectsUseCase = DefaultFetchMyProjectsUseCase(projectRepository: projectRepository)
        deleteProjectUseCase = DefaultDeleteProjectUseCase(projectRepository: projectRepository)
        
        // 지원자 목록, 수락, 거절, 지원취소
        fetchApplicantListUseCase = DefaultFetchApplicantListUseCase(applicantRepository: applicantRepository)
        acceptApplicantUseCase = DefaultAcceptApplicantUseCase(applicantRepository: applicantRepository)
        rejectApplicantUseCase = DefaultRejectApplicantUseCase(applicantRepository: applicantRepository)
        cancelApplicationUseCase = DefaultCancelApplicationUseCase(applicantRepository: applicantRepository)
        
        // 채팅방 개설
//        channelRepository = DefaultChannelRepository(networkService: networkService, stompService: stompService)
        channelRepository = MockChannelRepository()
        createChannelUseCase = DefaultCreateChannelUseCase(channelRepository: channelRepository)
        
        // 다른 유저의 프로필 보여주기
//        userRepository = DefaultUserRepository(networkService: networkService)
        fileRepository = DefaultFileRepository(networkService: networkService)
        userRepository = MockUserRepository()
        fetchProfileUseCase = DefaultFetchProfileUseCase(userRepository: userRepository)
        downloadFileUseCase = DefaultDownloadFileUseCase(fileRepository: fileRepository)
    }
    
    // MARK: - Methods
    func start() {
        showManagementViewController()
    }
}

extension ManagementCoordinator {
    // MARK: - Show
    func showManagementViewController() {
        let viewModel = ManagementViewModel(
            coordinator: self,
            fetchAppliedProjectsUseCase: fetchAppliedProjectsUseCase,
            fetchMyProjectsUseCase: fetchMyProjectsUseCase,
            deleteProjectUseCase: deleteProjectUseCase,
            cancelApplicationUseCase: cancelApplicationUseCase
        )
        
        let vc = ManagementViewController(viewModel: viewModel)
        navigationController.pushViewController(vc, animated: true)
    }
    
    // 지원자 목록 이동
    func showApplicantListViewController(with projectID: Int) {
        let viewModel = ApplicantListViewModel(
            coordinator: self,
            projectID: projectID, 
            fetchApplicantListUseCase: fetchApplicantListUseCase, 
            acceptApplicantUseCase: acceptApplicantUseCase,
            rejectApplicantUseCase: rejectApplicantUseCase,
            createChannelUseCase: createChannelUseCase
        )
        
        let vc = ApplicantListViewController(viewModel: viewModel)
        navigationController.pushViewController(vc, animated: true)
    }
    
    // 채팅방 이동
    func showChannelViewController(of channel: Channel) {
        delegate?.showChannelViewController(of: channel, navigationController: navigationController)
    }
    
    // 프로필 보여주기
    func showProfileViewController(of userID: String) {
        let otherUserProfileViewModel = OtherUserProfileViewModel(
            coordinator: self,
            userID: userID,
            fetchProfileUseCase: fetchProfileUseCase,
            downloadFileUseCase: downloadFileUseCase
        )
        let otherUserProfileViewController = OtherUserProfileViewController(viewModel: otherUserProfileViewModel)
        navigationController.pushViewController(otherUserProfileViewController, animated: true)
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

// MARK: - CoordinatorDelegate
extension ManagementCoordinator: CoordinatorDelegate {
    func didFinish(childCoordinator: Coordinator) {
        navigationController.dismiss(animated: true)
        
        if let index = childCoordinators.firstIndex(where: { $0 === childCoordinator }) {
            childCoordinators.remove(at: index)
        }
    }
}
