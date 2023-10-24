//
//  ChatRoomViewController.swift
//  Bridge
//
//  Created by 정호윤 on 10/16/23.
//

import UIKit
import FlexLayout
import PinLayout
import RxCocoa
import RxSwift

final class ChatRoomViewController: BaseViewController {
    // MARK: - UI
    private let rootFlexConatiner = UIView()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.register(MessageCell.self)
        collectionView.backgroundColor = BridgeColor.gray9
        return collectionView
    }()
    
    private let messageInputBar = BridgeMessageInputBar()
    
    private typealias DataSource = UICollectionViewDiffableDataSource<ChatRoomViewModel.Section, Message>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<ChatRoomViewModel.Section, Message>
    private var dataSource: DataSource?
    
    private let viewModel: ChatRoomViewModel
    
    init(viewModel: ChatRoomViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        enableKeyboardHiding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    override func configureAttributes() {
        configureDataSource()
    }
    
    // MARK: - Layout
    override func configureLayouts() {
        view.addSubview(rootFlexConatiner)
        
        rootFlexConatiner.flex.define { flex in
            flex.addItem(collectionView).grow(1)
            flex.addItem(messageInputBar)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        rootFlexConatiner.pin.all(view.pin.safeArea)
        rootFlexConatiner.flex.layout()
    }
    
    // MARK: - Binding
    override func bind() {
        messageInputBar.rx.keyboardLayoutChanged
            .bind(to: messageInputBar.rx.yPosition)
            .disposed(by: disposeBag)
        
        let input = ChatRoomViewModel.Input(
            viewWillAppear: self.rx.viewWillAppear.asObservable(),
            sendMessage: messageInputBar.sendMessage
        )
        let output = viewModel.transform(input: input)
        
        output.messages
            .drive { [weak self] messages in
                self?.applySnapshot(with: messages)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - Data source
extension ChatRoomViewController {
    private func configureDataSource() {
        dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(MessageCell.self, for: indexPath) else {
                return UICollectionViewCell()
            }
            cell.backgroundColor = .clear
            cell.configureCell(with: item)
            return cell
        }
    }
    
    private func applySnapshot(with messages: [Message]) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(messages)
        dataSource?.apply(snapshot)
        
        // 가장 아래로 스크롤
        if let lastItem = snapshot.itemIdentifiers(inSection: .main).last,
           let lastIndexPath = dataSource?.indexPath(for: lastItem) {
            collectionView.scrollToItem(at: lastIndexPath, at: .top, animated: false)
        }
    }
}

// MARK: - Layout
extension ChatRoomViewController {
    func createLayout() -> UICollectionViewLayout {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.estimatedItemSize = CGSize(width: view.frame.width, height: 66)
        flowLayout.sectionInset = UIEdgeInsets(top: 24, left: 0, bottom: 16, right: 0)
        flowLayout.minimumLineSpacing = 16
        return flowLayout
    }
}
