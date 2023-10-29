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
    private let chatRoomRepository: ChatRoomRepository
    private let messageRepository: MessageRepository
    
    private let fetchChatRoomsUseCase: FetchChatRoomsUseCase
    private let leaveChatRoomUseCase: LeaveChatRoomUseCase
    private let observeMessageUseCase: ObserveMessageUseCase
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.childCoordinators = []
        
        let networkService = DefaultNetworkService()
        authRepository = DefaultAuthRepository(networkService: networkService)
        chatRoomRepository = MockChatRoomRepository()
        messageRepository = MockMessageRepository()
        fetchChatRoomsUseCase = DefaultFetchChatRoomsUseCase(chatRoomRepository: chatRoomRepository)
        leaveChatRoomUseCase = DefaultLeaveChatRoomUseCase(chatRoomRepository: chatRoomRepository)
        observeMessageUseCase = DefaultObserveMessageUseCase(messageRepository: messageRepository)
    }
    
    func start() {
        showChatRoomListViewController()
    }
}

extension ChatCoordinator {
    func showChatRoomListViewController() {
        let chatRoomListViewModel = ChatRoomListViewModel(
            coordinator: self,
            fetchChatRoomsUseCase: fetchChatRoomsUseCase,
            leaveChatRoomUseCase: leaveChatRoomUseCase
        )
        let chatRoomListViewController = ChatRoomListViewController(viewModel: chatRoomListViewModel)
        navigationController.pushViewController(chatRoomListViewController, animated: true)
    }
    
    func showChatRoomViewController(of chatRoom: ChatRoom) {
        let chatRoomViewModel = MessageViewModel(
            coordinator: self,
            chatRoom: chatRoom,
            observeMessageUseCase: observeMessageUseCase
        )
        let chatRoomViewController = MessageViewController(viewModel: chatRoomViewModel)
        navigationController.pushViewController(chatRoomViewController, animated: true)
    }
}

// MARK: - Auth
extension ChatCoordinator {
    func showSignInViewController() {
        delegate?.showSignInViewController()
    }
}
