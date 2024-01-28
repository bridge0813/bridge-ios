//
//  BookmarkedProjectViewController.swift
//  Bridge
//
//  Created by 정호윤 on 12/14/23.
//

import UIKit
import FlexLayout
import PinLayout
import RxCocoa
import RxSwift

final class BookmarkedProjectViewController: BaseViewController {
    // MARK: - UI
    private lazy var bookmarkedProjectCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.backgroundColor = BridgeColor.gray09
        collectionView.alwaysBounceVertical = true
        collectionView.register(BookmarkedProjectCell.self)
        return collectionView
    }()
    
    // MARK: - Property
    private let viewModel: BookmarkedProjectViewModel
    private let bookmarkButtonTapped = PublishRelay<Int>()
    
    // MARK: - Init
    init(viewModel: BookmarkedProjectViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
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
        navigationItem.title = "관심공고"
    }
    
    // MARK: - Layout
    override func configureLayouts() {
        view.addSubview(bookmarkedProjectCollectionView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        bookmarkedProjectCollectionView.pin.all()
        bookmarkedProjectCollectionView.flex.layout()
    }
    
    // MARK: - Binding
    override func bind() {
        let input = BookmarkedProjectViewModel.Input(
            viewWillAppear: self.rx.viewWillAppear.asObservable(),
            bookmarkButtonTapped: bookmarkButtonTapped.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        output.bookmarkedProjects
            .bind(to: bookmarkedProjectCollectionView.rx.items(
                cellIdentifier: BookmarkedProjectCell.reuseIdentifier,
                cellType: BookmarkedProjectCell.self)
            ) { [weak self] _, element, cell in
                guard let self else { return }
                
                cell.configure(with: element)
                
                cell.bookmarkButtonTapped
                    .map { element.id }
                    .bind(to: self.bookmarkButtonTapped)
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - Layout
extension BookmarkedProjectViewController {
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        
        let padding: CGFloat = 16
        let minimumItemSpacing: CGFloat = 9
        let availableWidth = view.bounds.width - (padding * 2) - minimumItemSpacing
        let cellWidth = availableWidth / 2
        
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth * 1.1)
        layout.sectionInset = UIEdgeInsets(top: 24, left: padding, bottom: 0, right: padding)
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = minimumItemSpacing
        
        return layout
    }
}
