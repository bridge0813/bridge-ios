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
    private let checkUserAuthStateUseCase: CheckUserAuthStateUseCase
    private let fetchChatRoomsUseCase: FetchChatRoomsUseCase
    private let leaveChatRoomUseCase: LeaveChatRoomUseCase
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.childCoordinators = []
        
        let networkService = DefaultNetworkService()
        let tokenStorage = KeychainTokenStorage()
        authRepository = DefaultAuthRepository(networkService: networkService, tokenStorage: tokenStorage)
        chatRoomRepository = DefaultChatRoomRepository(networkService: networkService)
        checkUserAuthStateUseCase = DefaultCheckUserAuthStateUseCase(authRepository: authRepository)
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
            checkUserAuthStateUseCase: checkUserAuthStateUseCase,
            fetchChatRoomsUseCase: fetchChatRoomsUseCase,
            leaveChatRoomUseCase: leaveChatRoomUseCase
        )
        let viewController = ChatRoomListViewController(viewModel: chatRoomListViewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showChatRoomDetailViewController(of chatRoom: ChatRoom) {
        // ChatRoomDetail로 연결...
    }
}

// MARK: - Auth
extension ChatCoordinator {
    func showSignInViewController() {
        delegate?.showSignInViewController()
    }
}
