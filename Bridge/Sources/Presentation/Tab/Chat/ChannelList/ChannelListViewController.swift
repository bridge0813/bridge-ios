//
//  ChannelListViewController.swift
//  Bridge
//
//  Created by 정호윤 on 2023/08/26.
//

import UIKit
import FlexLayout
import PinLayout
import RxCocoa
import RxSwift

final class ChannelListViewController: BaseViewController {
    // MARK: - UI
    private let rootFlexContainer = UIView()
    
    private lazy var channelListTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ChannelCell.self)
        tableView.rowHeight = 88
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = .zero
        return tableView
    }()
    
    private var placeholderView = BridgePlaceholderView()
    
    // MARK: - Property
    private typealias DataSource = UITableViewDiffableDataSource<ChannelListViewModel.Section, Channel>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<ChannelListViewModel.Section, Channel>
    private var dataSource: DataSource?
    
    private let viewModel: ChannelListViewModel
    private let leaveChannel = PublishRelay<Int>()
    
    // MARK: - Init
    init(viewModel: ChannelListViewModel) {
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
            flex.addItem(channelListTableView).isIncludedInLayout(!channelListTableView.isHidden).grow(1)
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
        channelListTableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
        let input = ChannelListViewModel.Input(
            viewWillAppear: self.rx.viewWillAppear.asObservable(),
            itemSelected: channelListTableView.rx.itemSelected.map { $0.row },
            leaveChannel: leaveChannel.asObservable()
        )
        let output = viewModel.transform(input: input)
        
        output.channels
            .drive { [weak self] channels in
                self?.applySnapshot(with: channels)
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
extension ChannelListViewController {
    private func configureDataSource() {
        dataSource = DataSource(tableView: channelListTableView) { tableView, indexPath, item in
            guard let cell = tableView.dequeueReusableCell(ChannelCell.self, for: indexPath) else { return ChannelCell() }
            cell.configure(with: item)
            return cell
        }
    }
    
    private func applySnapshot(with channels: [Channel]) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(channels)
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
}

// MARK: - Delegate
extension ChannelListViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "나가기") { [weak self] _, _, completion in
            self?.leaveChannel.accept(indexPath.row)
            completion(true)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

// MARK: - View state handling
private extension ChannelListViewController {
    /// 뷰의 상태에 따라 화면에 표시되는 컴포넌트를 설정하는 함수
    func handleViewState(_ viewState: ChannelListViewModel.ViewState) {
        channelListTableView.isHidden = true
        placeholderView.isHidden = false
        
        switch viewState {
        case .general:
            channelListTableView.isHidden = false
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
