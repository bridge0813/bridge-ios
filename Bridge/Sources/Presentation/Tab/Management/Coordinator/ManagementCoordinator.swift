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
    private let profileRepository: ProfileRepository
    private let channelRepository: ChannelRepository
    private let messageRepository: MessageRepository
    
    private let fetchAppliedProjectsUseCase: FetchAppliedProjectsUseCase
    private let fetchMyProjectsUseCase: FetchMyProjectsUseCase
    private let deleteProjectUseCase: DeleteProjectUseCase
    
    private let fetchApplicantListUseCase: FetchApplicantListUseCase
    private let acceptApplicantUseCase: AcceptApplicantUseCase
    private let rejectApplicantUseCase: RejectApplicantUseCase
    
    private let createChannelUseCase: CreateChannelUseCase
    private let leaveChannelUseCase: LeaveChannelUseCase
    private let channelSubscriptionUseCase: ChannelSubscriptionUseCase
    private let observeMessageUseCase: ObserveMessageUseCase
    private let fetchMessagesUseCase: FetchMessagesUseCase
    private let sendMessageUseCase: SendMessageUseCase
    
    // MARK: - Init
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.childCoordinators = []

        // 네트워크 서비스
        let networkService = DefaultNetworkService()
        let stompService = DefaultStompService(webSocketService: DefaultWebSocketService.shared)
        
        // 리포지토리
        projectRepository = MockProjectRepository()
        profileRepository = MockProfileRepository()
        channelRepository = DefaultChannelRepository(networkService: networkService, stompService: stompService)
        messageRepository = DefaultMessageRepository(networkService: networkService, stompService: stompService)

        // 관리
        fetchAppliedProjectsUseCase = DefaultFetchAppliedProjectsUseCase(projectRepository: projectRepository)
        fetchMyProjectsUseCase = DefaultFetchMyProjectsUseCase(projectRepository: projectRepository)
        deleteProjectUseCase = DefaultDeleteProjectUseCase(projectRepository: projectRepository)
        fetchApplicantListUseCase = DefaultFetchApplicantListUseCase(profileRepository: profileRepository)
        
        // 지원자 목록(수락, 거절)
        acceptApplicantUseCase = DefaultAcceptApplicantUseCase(projectRepository: projectRepository)
        rejectApplicantUseCase = DefaultRejectApplicantUseCase(projectRepository: projectRepository)
        
        // 채팅(채팅방 개설 및 이동)
        createChannelUseCase = DefaultCreateChannelUseCase(channelRepository: channelRepository)
        leaveChannelUseCase = DefaultLeaveChannelUseCase(channelRepository: channelRepository)
        channelSubscriptionUseCase = DefaultChannelSubscriptionUseCase(channelRepository: channelRepository)
        observeMessageUseCase = DefaultObserveMessageUseCase(messageRepository: messageRepository)
        fetchMessagesUseCase = DefaultFetchMessagesUseCase(messageRepository: messageRepository)
        sendMessageUseCase = DefaultSendMessageUseCase(messageRepository: messageRepository)
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
            deleteProjectUseCase: deleteProjectUseCase
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
        // TODO: - 코디네이터 처리 논의
        print(channel)
//        let channelViewModel = ChannelViewModel(
//            coordinator: self,
//            channel: channel,
//            leaveChannelUseCase: leaveChannelUseCase,
//            channelSubscriptionUseCase: channelSubscriptionUseCase,
//            observeMessageUseCase: observeMessageUseCase,
//            fetchMessagesUseCase: fetchMessagesUseCase,
//            sendMessageUseCase: sendMessageUseCase
//        )
//        let channelViewController = ChannelViewController(viewModel: channelViewModel)
//        navigationController.pushViewController(channelViewController, animated: true)
    }
    
    // MARK: - Connect
    func connectToProjectDetailFlow(with projectID: Int) {
        // TODO: - 연결된 코디네이터 제거 작업
        let coordinator = ProjectDetailCoordinator(navigationController: navigationController)
        coordinator.start()
        childCoordinators.append(coordinator)
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
