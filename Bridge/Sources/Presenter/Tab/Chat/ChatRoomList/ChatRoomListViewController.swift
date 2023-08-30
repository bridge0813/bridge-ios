//
//  ChatRoomListViewController.swift
//  Bridge
//
//  Created by 정호윤 on 2023/08/26.
//

import UIKit
import FlexLayout
import PinLayout
import RxCocoa
import RxSwift

final class ChatRoomListViewController: BaseViewController {
    
    private lazy var chatRoomListTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ChatRoomTableViewCell.self)
        return tableView
    }()
    
    private var dataSource: UITableViewDiffableDataSource<Section, ChatRoom>?
    
    private let viewModel: ChatRoomListViewModel
    private let leaveTrigger = PublishRelay<Int>()
    
    init(viewModel: ChatRoomListViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}

// MARK: - Diffable data source
extension ChatRoomListViewController {
    enum Section: CaseIterable {
        case main
    }
    
}

// MARK: - Delegate
extension ChatRoomListViewController: UITableViewDelegate {
    
}
