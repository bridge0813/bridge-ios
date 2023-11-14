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
    
    private let authRepository: AuthRepository
    private let channelRepository: ChannelRepository
    private let messageRepository: MessageRepository
    
    private let fetchChannelsUseCase: FetchChannelsUseCase
    private let leaveChannelUseCase: LeaveChannelUseCase
    private let fetchMessagesUseCase: FetchMessagesUseCase
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.childCoordinators = []
        
        let networkService = DefaultNetworkService()
        authRepository = DefaultAuthRepository(networkService: networkService)
        channelRepository = DefaultChannelRepository(networkService: networkService)
        messageRepository = DefaultMessageRepository(networkService: networkService)
        
        fetchChannelsUseCase = DefaultFetchChannelsUseCase(channelRepository: channelRepository)
        leaveChannelUseCase = DefaultLeaveChannelUseCase(channelRepository: channelRepository)
        fetchMessagesUseCase = DefaultFetchMessagesUseCase(messageRepository: messageRepository)
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
            fetchMessagesUseCase: fetchMessagesUseCase,
            leaveChannelUseCase: leaveChannelUseCase
        )
        let channelViewController = ChannelViewController(viewModel: channelViewModel)
        navigationController.pushViewController(channelViewController, animated: true)
    }
    
    func showProfileViewController(of userID: String) { }
}

// MARK: - Auth
extension ChatCoordinator {
    func showSignInViewController() {
        delegate?.showSignInViewController()
    }
}
