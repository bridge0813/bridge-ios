//
//  ChannelViewController.swift
//  Bridge
//
//  Created by 정호윤 on 10/16/23.
//

import UIKit
import FlexLayout
import PinLayout
import RxCocoa
import RxSwift

final class ChannelViewController: BaseViewController {
    // MARK: - UI
    private let profileView: ChannelProfileView = {
        let view = ChannelProfileView()
        view.frame = CGRect(x: 0, y: 0, width: 150, height: 30)
        return view
    }()
    
    private lazy var menuBarButton = UIBarButtonItem(
        image: UIImage(named: "hamburger")?.resize(to: CGSize(width: 24, height: 24)).withRenderingMode(.alwaysTemplate),
        style: .plain,
        target: self,
        action: nil
    )
    private lazy var dropdown = DropDown(
        anchorView: menuBarButton,
        bottomOffset: CGPoint(x: 0, y: 14),
        dataSource: ["채팅방 나가기", "신고하기"],
        cellHeight: 43,
        itemTextColor: BridgeColor.gray03,
        width: 147,
        cornerRadius: 4,
        customCellType: ChannelDropdownMenuCell.self,
        customCellConfiguration: { index, _, cell in
            guard let cell = cell as? ChannelDropdownMenuCell else { return }
            cell.configure(image: UIImage(named: ["leave", "warning"][index]))
        }
    )
    
    private let rootFlexConatiner: UIView = {
        let view = UIView()
        view.backgroundColor = BridgeColor.gray09
        return view
    }()
    
    private lazy var messageCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.backgroundColor = BridgeColor.gray09
        collectionView.alwaysBounceVertical = true
        collectionView.register(BaseChatCell.self)
        collectionView.register(MessageCell.self)
        collectionView.register(ApplicationResultCell.self)
        return collectionView
    }()
    
    private let messageInputBar = BridgeMessageInputBar()
    
    // MARK: - Property
    private typealias DataSource = UICollectionViewDiffableDataSource<ChannelViewModel.Section, Message>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<ChannelViewModel.Section, Message>
    private var dataSource: DataSource?
    
    private let viewModel: ChannelViewModel
    
    // MARK: - Init
    init(viewModel: ChannelViewModel) {
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
    
    // MARK: - Configuration
    override func configureAttributes() {
        configureNavigationBar()
        configureDataSource()
    }
    
    private func configureNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: profileView)
        navigationItem.leftItemsSupplementBackButton = true
        navigationItem.rightBarButtonItem = menuBarButton
    }
    
    // MARK: - Layout
    override func configureLayouts() {
        view.addSubview(rootFlexConatiner)
        
        rootFlexConatiner.flex.define { flex in
            flex.addItem(messageCollectionView).grow(1)
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
        menuBarButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.dropdown.show()
            })
            .disposed(by: disposeBag)
        
        messageInputBar.rx.keyboardLayoutChanged
            .bind(to: messageInputBar.rx.yPosition)
            .disposed(by: disposeBag)
        
        messageCollectionView.rx.keyboardLayoutChanged
            .bind(to: messageCollectionView.rx.yPosition)
            .disposed(by: disposeBag)
        
        let input = ChannelViewModel.Input(
            viewWillAppear: self.rx.viewWillAppear.asObservable(),
            profileButtonTapped: profileView.nameButtonTapped,
            dropdownItemSelected: dropdown.itemSelected.map { $0.title }.asObservable(),
            sendMessage: messageInputBar.sendMessage,
            viewDidDisappear: self.rx.viewDidDisappear.asObservable()
        )
        let output = viewModel.transform(input: input)
        
        output.channel
            .drive { [weak self] channel in
                self?.profileView.configure(with: channel)
            }
            .disposed(by: disposeBag)
        
        output.messages
            .drive { [weak self] messages in
                self?.applySnapshot(with: messages)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - Data source
extension ChannelViewController {
    private func configureDataSource() {
        dataSource = DataSource(collectionView: messageCollectionView) { [weak self] collectionView, indexPath, item in
            let currentMessage = item
            
            // 날짜(yyyy-mm-dd)가 바뀌었는지 비교해 보여줘야 하는지 결정
            var shouldShowDate: Bool {
                if indexPath.row == 0 { return true }
                
                guard let previousMessage = self?.dataSource?.item(before: indexPath) else { return false }
                
                return previousMessage.sentDate != currentMessage.sentDate
            }
            
            // 읽음 여부 처리를 위해 현재 셀이 마지막 셀인지 판단
            var shouldShowReadStatus: Bool {
                let lastSection = collectionView.numberOfSections - 1
                let lastItem = collectionView.numberOfItems(inSection: lastSection) - 1
                return indexPath.section == lastSection && indexPath.row == lastItem && item.sender == .me && item.hasRead
            }
            
            let cell: BaseChatCell
            
            switch item.type {
            case .text:
                cell = collectionView.dequeueReusableCell(MessageCell.self, for: indexPath) ?? MessageCell()
                
            case .accept, .reject:
                cell = collectionView.dequeueReusableCell(ApplicationResultCell.self, for: indexPath) ?? ApplicationResultCell()
                
            default:
                cell = BaseChatCell()
            }
            
            cell.configure(with: item, shouldShowDate: shouldShowDate, shouldShowReadStatus: shouldShowReadStatus)
            return cell
        }
    }
    
    private func applySnapshot(with messages: [Message]) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(messages)
        dataSource?.apply(snapshot, animatingDifferences: false)
        
        // 가장 아래로 스크롤
        if let lastItem = snapshot.itemIdentifiers(inSection: .main).last,
           let lastIndexPath = dataSource?.indexPath(for: lastItem) {
            messageCollectionView.scrollToItem(at: lastIndexPath, at: .top, animated: false)
        }
    }
}

// MARK: - Layout
private extension ChannelViewController {
    func createLayout() -> UICollectionViewLayout {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.estimatedItemSize = CGSize(width: view.frame.width, height: 66)
        flowLayout.sectionInset = UIEdgeInsets(top: 24, left: 0, bottom: 16, right: 0)
        flowLayout.minimumLineSpacing = 16
        return flowLayout
    }
}

// MARK: - Helper
private extension UICollectionViewDiffableDataSource {
    func item(before indexPath: IndexPath) -> ItemIdentifierType? {
        guard indexPath.row > 0 else { return nil }
        
        let previousIndexPath = IndexPath(row: indexPath.row - 1, section: indexPath.section)
        return itemIdentifier(for: previousIndexPath)
    }
}
