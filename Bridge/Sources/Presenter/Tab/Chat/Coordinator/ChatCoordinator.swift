//
//  ChatCoordinator.swift
//  Bridge
//
//  Created by 정호윤 on 2023/08/25.
//

import UIKit

protocol ChatCoordinatorProtocol: Coordinator { }

final class ChatCoordinator: ChatCoordinatorProtocol {
    
    weak var delegate: CoordinatorDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator]
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.childCoordinators = []
    }
    
    func start() {
        showChatRoomListViewController()
    }
}

extension ChatCoordinator {
    func showChatRoomListViewController() {
        let viewController = ChatRoomListViewController()
        navigationController.pushViewController(viewController, animated: true)
    }
}
