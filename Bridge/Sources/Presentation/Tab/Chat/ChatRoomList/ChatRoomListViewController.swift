//
//  ChatRoomListViewController.swift
//  Bridge
//
//  Created by 정호윤 on 2023/08/26.
//

import UIKit
import PinLayout
import RxCocoa
import RxSwift

final class ChatRoomListViewController: BaseViewController {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ChatRoomCell.self)
        tableView.backgroundColor = BridgeColor.gray9
        tableView.rowHeight = 104
        tableView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private var placeholderView = BridgePlaceholderView()
    
    private typealias DataSource = UITableViewDiffableDataSource<ChatRoomListViewModel.Section, ChatRoom>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<ChatRoomListViewModel.Section, ChatRoom>
    private var dataSource: DataSource?
    
    private let viewModel: ChatRoomListViewModel
    private let leaveChatRoom = PublishRelay<Int>()
    
    init(viewModel: ChatRoomListViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Configurations
    override func configureAttributes() {
        navigationItem.title = "채팅"
        configureDataSource()
    }
    
    override func configureLayouts() {
        view.addSubview(tableView)
        view.addSubview(placeholderView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.pin.all()
        placeholderView.pin.all()
    }
    
    override func bind() {
        tableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
        let input = ChatRoomListViewModel.Input(
            viewWillAppear: self.rx.viewWillAppear.asObservable(),
            itemSelected: tableView.rx.itemSelected.map { $0.row },
            leaveChatRoom: leaveChatRoom.asObservable()
        )
        let output = viewModel.transform(input: input)
        
        output.chatRooms
            .compactMap { [weak self] chatRooms in
                self?.createCurrentSnapshot(with: chatRooms)
            }
            .drive { [weak self] currentSnapshot in
                self?.dataSource?.apply(currentSnapshot)
            }
            .disposed(by: disposeBag)
        
        output.viewState
            .drive { [weak self] viewState in
                self?.handleViewState(viewState)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - Data source
extension ChatRoomListViewController {
    private func configureDataSource() {
        dataSource = DataSource(tableView: tableView) { tableView, indexPath, item in
            guard let cell = tableView.dequeueReusableCell(ChatRoomCell.self, for: indexPath) else { return UITableViewCell() }
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            cell.configureCell(with: item)
            return cell
        }
    }
    
    private func createCurrentSnapshot(with chatRoom: [ChatRoom]) -> Snapshot {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(chatRoom)
        return snapshot
    }
}

// MARK: - Delegate
extension ChatRoomListViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "나가기") { [weak self] _, _, completion in
            self?.leaveChatRoom.accept(indexPath.row)
            completion(true)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

// MARK: - View state handling
private extension ChatRoomListViewController {
    /// 뷰의 상태에 따라 화면에 표시되는 컴포넌트를 설정하는 함수
    func handleViewState(_ viewState: ChatRoomListViewModel.ViewState) {
        tableView.isHidden = true
        placeholderView.isHidden = false
        
        switch viewState {
        case .general:
            tableView.isHidden = false
            placeholderView.isHidden = true
            
        case .notSignedIn:
            placeholderView.configurePlaceholderView(description: "로그인 후 이용할 수 있어요.")
            
        case .empty:
            placeholderView.configurePlaceholderView(description: "프로젝트에 지원하고 채팅을 시작해보세요!")
            
        case .error:
            placeholderView.configurePlaceholderView(description: "알 수 없는 오류가 발생했습니다.")
        }
    }
}
