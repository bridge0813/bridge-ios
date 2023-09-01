//
//  ChatCoordinator.swift
//  Bridge
//
//  Created by 정호윤 on 2023/08/25.
//

import UIKit

protocol ChatCoordinatorProtocol: Coordinator {
    func showChatRoomListViewController()
    func showChatRoomDetailViewController()
}

final class ChatCoordinator: ChatCoordinatorProtocol {
    
    weak var delegate: CoordinatorDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator]
    
    private let chatRoomRepository: ChatRoomRepository
    private let fetchChatRoomsUseCase: FetchChatRoomsUseCase
    private let leaveChatRoomUseCase: LeaveChatRoomUseCase
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.childCoordinators = []
        
        let networkService = DefaultNetworkService()
        chatRoomRepository = DefaultChatRoomRepository(networkService: networkService)
        fetchChatRoomsUseCase = DefaultFetchChatRoomsUseCase(chatRoomRepository: chatRoomRepository)
        leaveChatRoomUseCase = DefaultLeaveChatRoomUseCase(chatRoomRepository: chatRoomRepository)
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
        let viewController = ChatRoomListViewController(viewModel: chatRoomListViewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showChatRoomDetailViewController() {
        // ChatRoomDetailCoordinator로 연결...
    }
}
