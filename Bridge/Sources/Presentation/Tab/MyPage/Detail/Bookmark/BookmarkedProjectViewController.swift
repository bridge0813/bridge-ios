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
    
    // MARK: - Init
    init(viewModel: BookmarkedProjectViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
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
            viewWillAppear: self.rx.viewWillAppear.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        output.bookmarkedProjects
            .bind(to: bookmarkedProjectCollectionView.rx.items(
                cellIdentifier: BookmarkedProjectCell.reuseIdentifier,
                cellType: BookmarkedProjectCell.self)
            ) { _, element, cell in
                cell.configure(with: element)
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
        layout.sectionInset = UIEdgeInsets(top: 0, left: padding, bottom: 0, right: padding)
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = minimumItemSpacing
        
        return layout
    }
}
