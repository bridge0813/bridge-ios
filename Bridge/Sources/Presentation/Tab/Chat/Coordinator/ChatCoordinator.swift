//
//  ChatCoordinator.swift
//  Bridge
//
//  Created by 정호윤 on 2023/08/25.
//

import UIKit

final class ChatCoordinator: Coordinator {
    
    weak var delegate: CoordinatorDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator]
    var didFinishEventClosure: (() -> Void)?  // disAppear 시점에 자식 코디네이터에서 할당을 제거하기 위함.
    
    private let authRepository: AuthRepository
    private let channelRepository: ChannelRepository
    private let messageRepository: MessageRepository
    
    private let fetchChannelsUseCase: FetchChannelsUseCase
    private let leaveChannelUseCase: LeaveChannelUseCase
    private let channelSubscriptionUseCase: ChannelSubscriptionUseCase
    private let observeMessageUseCase: ObserveMessageUseCase
    private let fetchMessagesUseCase: FetchMessagesUseCase
    private let sendMessageUseCase: SendMessageUseCase
    
    // 다른 유저의 프로필 보여주기
    private let userRepository: UserRepository
    private let fileRepository: FileRepository
    private let fetchProfileUseCase: FetchProfileUseCase
    private let downloadFileUseCase: DownloadFileUseCase
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.childCoordinators = []
        
        let networkService = DefaultNetworkService()
        let stompService = DefaultStompService(webSocketService: DefaultWebSocketService.shared)
        authRepository = DefaultAuthRepository(networkService: networkService)
//        channelRepository = DefaultChannelRepository(networkService: networkService, stompService: stompService)
//        messageRepository = DefaultMessageRepository(networkService: networkService, stompService: stompService)
        channelRepository = MockChannelRepository()
        messageRepository = MockMessageRepository()
        
        fetchChannelsUseCase = DefaultFetchChannelsUseCase(channelRepository: channelRepository)
        leaveChannelUseCase = DefaultLeaveChannelUseCase(channelRepository: channelRepository)
        channelSubscriptionUseCase = DefaultChannelSubscriptionUseCase(channelRepository: channelRepository)
        observeMessageUseCase = DefaultObserveMessageUseCase(messageRepository: messageRepository)
        fetchMessagesUseCase = DefaultFetchMessagesUseCase(messageRepository: messageRepository)
        sendMessageUseCase = DefaultSendMessageUseCase(messageRepository: messageRepository)
        
        // 다른 유저의 프로필 보여주기
//        userRepository = DefaultUserRepository(networkService: networkService)
        fileRepository = DefaultFileRepository(networkService: networkService)
        userRepository = MockUserRepository()
        fetchProfileUseCase = DefaultFetchProfileUseCase(userRepository: userRepository)
        downloadFileUseCase = DefaultDownloadFileUseCase(fileRepository: fileRepository)
    }
    
    func start() {
        showChannelListViewController()
    }
}

extension ChatCoordinator {
    private func showChannelListViewController() {
        let channelListViewModel = ChannelListViewModel(
            coordinator: self,
            fetchChannelsUseCase: fetchChannelsUseCase,
            leaveChannelUseCase: leaveChannelUseCase
        )
        let channelListViewController = ChannelListViewController(viewModel: channelListViewModel)
        navigationController.pushViewController(channelListViewController, animated: true)
    }
    
    func showChannelViewController(of channel: Channel) {
        let channelViewModel = ChannelViewModel(
            coordinator: self,
            channel: channel,
            leaveChannelUseCase: leaveChannelUseCase,
            channelSubscriptionUseCase: channelSubscriptionUseCase,
            observeMessageUseCase: observeMessageUseCase,
            fetchMessagesUseCase: fetchMessagesUseCase,
            sendMessageUseCase: sendMessageUseCase
        )
        let channelViewController = ChannelViewController(viewModel: channelViewModel)
        navigationController.pushViewController(channelViewController, animated: true)
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
}

// MARK: - Auth
extension ChatCoordinator {
    func showSignInViewController() {
        delegate?.showSignInViewController()
    }
}
