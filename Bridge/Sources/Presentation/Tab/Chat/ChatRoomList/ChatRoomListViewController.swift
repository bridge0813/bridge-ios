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
    // MARK: - UI
    private let rootFlexContainer = UIView()
    
    private lazy var chatRoomListTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ChatRoomCell.self)
        tableView.rowHeight = 88
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = .zero
        return tableView
    }()
    
    private var placeholderView = BridgePlaceholderView()
    
    // MARK: - Property
    private typealias DataSource = UITableViewDiffableDataSource<ChatRoomListViewModel.Section, ChatRoom>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<ChatRoomListViewModel.Section, ChatRoom>
    private var dataSource: DataSource?
    
    private let viewModel: ChatRoomListViewModel
    private let leaveChatRoom = PublishRelay<Int>()
    
    // MARK: - Init
    init(viewModel: ChatRoomListViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Configuration
    override func configureAttributes() {
        navigationItem.title = "채팅"
        configureDataSource()
    }
    
    override func configureLayouts() {
        view.addSubview(rootFlexContainer)
        
        rootFlexContainer.flex.define { flex in
            flex.addItem(chatRoomListTableView).isIncludedInLayout(!chatRoomListTableView.isHidden).grow(1)
            flex.addItem(placeholderView).isIncludedInLayout(!placeholderView.isHidden).grow(1)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        rootFlexContainer.pin.all(view.pin.safeArea)
        rootFlexContainer.flex.layout()
    }
    
    // MARK: - Binding
    override func bind() {
        chatRoomListTableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
        let input = ChatRoomListViewModel.Input(
            viewWillAppear: self.rx.viewWillAppear.asObservable(),
            itemSelected: chatRoomListTableView.rx.itemSelected.map { $0.row },
            leaveChatRoom: leaveChatRoom.asObservable()
        )
        let output = viewModel.transform(input: input)
        
        output.chatRooms
            .drive { [weak self] chatRooms in
                self?.applySnapshot(with: chatRooms)
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
        dataSource = DataSource(tableView: chatRoomListTableView) { tableView, indexPath, item in
            guard let cell = tableView.dequeueReusableCell(ChatRoomCell.self, for: indexPath) else { return ChatRoomCell() }
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            cell.configure(with: item)
            return cell
        }
    }
    
    private func applySnapshot(with chatRooms: [ChatRoom]) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(chatRooms)
        dataSource?.apply(snapshot)
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
        chatRoomListTableView.isHidden = true
        placeholderView.isHidden = false
        
        switch viewState {
        case .general:
            chatRoomListTableView.isHidden = false
            placeholderView.isHidden = true
            
        case .signInNeeded:
            placeholderView.configurePlaceholderView(
                for: .needSignIn,
                configuration: BridgePlaceholderView.PlaceholderConfiguration(
                    title: "로그인 후 사용 가능해요!",
                    description: "채팅을 시작해보세요."
                )
            )
            
        case .empty:
            placeholderView.configurePlaceholderView(for: .emptyChatRoom)
            
        case .error:
            placeholderView.configurePlaceholderView(for: .error)
        }
        
        configureLayouts()
    }
}
