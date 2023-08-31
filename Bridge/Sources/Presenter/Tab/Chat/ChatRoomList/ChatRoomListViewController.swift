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
        tableView.register(ChatRoomCell.self)
        tableView.backgroundColor = .white
        tableView.rowHeight = 104
        tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
        tableView.separatorStyle = .none
        return tableView
    }()
    
    typealias DataSource = UITableViewDiffableDataSource<Section, ChatRoom>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, ChatRoom>
    private var dataSource: DataSource?
    
    private let viewModel: ChatRoomListViewModel
    private let leaveChatRoomTrigger = PublishRelay<Int>()
    
    init(viewModel: ChatRoomListViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureNavigationController()
    }
    
    // MARK: - Configurations
    override func configureAttributes() {
        dataSource = configureDataSource()
        configureNavigationController()
    }
    
    private func configureNavigationController() {
        navigationItem.titleView = NavigationTitleView(title: "채팅")
    }
    
    override func configureLayouts() {
        view.addSubview(chatRoomListTableView)
    }
    
    override func viewDidLayoutSubviews() {
        chatRoomListTableView.pin.all()
        chatRoomListTableView.flex.layout()
    }
    
    override func bind() {
        let input = ChatRoomListViewModel.Input(leaveChatRoomTrigger: leaveChatRoomTrigger)
        let output = viewModel.transform(input: input)
        
        output.chatRooms
            .compactMap { [weak self] chatRooms in self?.createCurrentSnapshot(with: chatRooms) }
            .drive { [weak self] currentSnapshot in self?.dataSource?.apply(currentSnapshot) }
            .disposed(by: disposeBag)
        
        chatRoomListTableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
        chatRoomListTableView.rx.itemSelected
            .bind(onNext: { [weak self] indexPath in self?.showChatRoomDetailViewController(at: indexPath) })
            .disposed(by: disposeBag)
    }
    
    private func showChatRoomDetailViewController(at indexPath: IndexPath) {
        guard let chatRoom = dataSource?.itemIdentifier(for: indexPath) else { return }
        viewModel.showChatRoomDetailViewController(of: chatRoom)
    }
}

// MARK: - Diffable data source
extension ChatRoomListViewController {
    enum Section: CaseIterable {
        case main
    }
    
    func configureDataSource() -> DataSource {
        UITableViewDiffableDataSource(
            tableView: chatRoomListTableView
        ) { [weak self] tableView, indexPath, itemIdentifier in
            guard let cell = tableView.dequeueReusableCell(
                ChatRoomCell.self,
                for: indexPath
            ) else { return UITableViewCell() }

            // TODO: binding
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func createCurrentSnapshot(with chatRoom: [ChatRoom]) -> Snapshot {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(chatRoom)
        return snapshot
    }
}

// MARK: - Delegate
extension ChatRoomListViewController: UITableViewDelegate {
    
}
