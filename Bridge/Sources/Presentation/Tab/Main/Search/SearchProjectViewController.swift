//
//  SearchProjectViewController.swift
//  Bridge
//
//  Created by 엄지호 on 2/5/24.
//

import UIKit
import FlexLayout
import PinLayout
import RxCocoa
import RxSwift

final class SearchProjectViewController: BaseViewController {
    // MARK: - UI
    private let rootFlexContainer: UIView = {
        let view = UIView()
        view.backgroundColor = BridgeColor.gray09
        return view
    }()
    
    private let searchContainer: UIView = {
        let view = UIView()
        view.flex.height(88)
        view.backgroundColor = BridgeColor.gray10
        return view
    }()
    private let searchBar = BridgeSearchBar()
    
    private let cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("취소", for: .normal)
        button.setTitleColor(BridgeColor.secondary1, for: .normal)
        button.titleLabel?.font = BridgeFont.body2.font
        return button
    }()
    
    private let dividerView: UIView = {
        let divider = UIView()
        divider.flex.width(100%).height(1)
        divider.backgroundColor = BridgeColor.gray06
        divider.isHidden = true
        return divider
    }()
    
    private let recentSearchesView: RecentSearchesView = {
        let view = RecentSearchesView()
        view.flex.width(100%).height(100%)
        view.isHidden = true
        return view
    }()
    
    private lazy var projectListCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionViewLayout())
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = BridgeColor.gray09
        collectionView.register(ProjectCell.self)
        collectionView.register(
            ProjectCountHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader
        )
        
        return collectionView
    }()
    
    private let placeholderView: BridgePlaceholderView = {
        let view = BridgePlaceholderView()
        view.configurePlaceholderView(for: .emptySearchedProject)
        view.isHidden = true
        return view
    }()
    
    // MARK: - Property
    private let viewModel: SearchProjectViewModel
    
    private typealias DataSource = UICollectionViewDiffableDataSource<SearchProjectViewModel.Section, ProjectPreview>
    private typealias SectionSnapshot = NSDiffableDataSourceSectionSnapshot<ProjectPreview>
    
    private var dataSource: DataSource?
    
    private let itemSelected = PublishSubject<ProjectID>()
    private let bookmarkButtonTapped = PublishSubject<ProjectID>()
    
    // MARK: - Init
    init(viewModel: SearchProjectViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
        tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - Configuration
    override func configureAttributes() {
        configureDataSource()
    }
    
    // MARK: - Layout
    override func configureLayouts() {
        view.addSubview(rootFlexContainer)
        
        rootFlexContainer.flex.define { flex in
            flex.addItem(searchContainer).direction(.row).alignItems(.center).padding(22, 15, 22, 15).define { flex in
                flex.addItem(searchBar).grow(1).height(44)
                flex.addItem(cancelButton).marginLeft(16)
            }
            
            flex.addItem(dividerView)
            flex.addItem(recentSearchesView).isIncludedInLayout(true).marginTop(4)
            flex.addItem(projectListCollectionView).isIncludedInLayout(false).grow(1)
            flex.addItem(placeholderView).isIncludedInLayout(false).grow(1)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        rootFlexContainer.pin.all(view.pin.safeArea)
        rootFlexContainer.flex.layout()
    }
    
    // MARK: - Binding
    override func bind() {
        let input = SearchProjectViewModel.Input(
            textFieldEditingDidBegin: searchBar.editingDidBegin,
            searchButtonTapped: searchBar.searchButtonTapped,
            cancelButtonTapped: cancelButton.rx.tap,
            removeAllButtonTapped: recentSearchesView.removeAllButtonTapped,
            itemSelected: itemSelected,
            bookmarkButtonTapped: bookmarkButtonTapped
        )
        let output = viewModel.transform(input: input)
        
        // 최근 검색어 선택
        recentSearchesView.recentSearchSelected
            .withUnretained(self)
            .subscribe(onNext: { owner, recentSearch in
                owner.view.endEditing(true)
                owner.searchBar.text = recentSearch.searchWord  // 텍스트 필드의 텍스트 변경 후 검색 시작
            })
            .disposed(by: disposeBag)
        
        // 검색 결과(모집글)
        output.projects
            .skip(1)
            .drive(onNext: { [weak self] projects in
                guard let self else { return }
                
                // recentSearchesView를 제거하고, 컬렉션 뷰 혹은 플레이스홀더를 보여주기
                self.dividerView.isHidden = false
                self.recentSearchesView.flex.isIncludedInLayout(false)
                self.recentSearchesView.isHidden = true
                self.projectListCollectionView.flex.isIncludedInLayout(projects.isEmpty ? false : true)
                self.projectListCollectionView.isHidden = projects.isEmpty ? true : false
                self.placeholderView.flex.isIncludedInLayout(projects.isEmpty ? true : false)
                self.placeholderView.isHidden = projects.isEmpty ? false : true
                self.rootFlexContainer.flex.layout()
                
                self.configureSupplementaryView(projectCount: projects.count)
                self.applySectionSnapshot(with: projects)
            })
            .disposed(by: disposeBag)
        
        // 최근 검색어 조회 결과
        output.recentSearches
            .skip(1)
            .bind(to: recentSearchesView.recentSearchesUpdated)
            .disposed(by: disposeBag)
        
        
        // 키보드가 올라올 때, recentSearchesView를 보여주기.
        recentSearchesView.rx.keyboardLayoutChanged
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { owner, keyboardHeight in
                // 키보드가 내려갔을 경우
                guard keyboardHeight > 0 else {
                    return
                }
                
                let viewHeight = owner.view.frame.size.height
                let safeAreaInset = owner.view.safeAreaInsets.top
                let recentSearchesViewMarginTop: CGFloat = 93
                let newHeight = viewHeight - recentSearchesViewMarginTop - keyboardHeight - safeAreaInset
                
                owner.projectListCollectionView.isHidden = true
                owner.projectListCollectionView.flex.isIncludedInLayout(false)
                owner.placeholderView.isHidden = true
                owner.placeholderView.flex.isIncludedInLayout(false)
                owner.dividerView.isHidden = true
                
                owner.recentSearchesView.flex.isIncludedInLayout(true).height(newHeight).markDirty()
                owner.recentSearchesView.isHidden = false
                owner.rootFlexContainer.flex.layout()
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - 컴포지셔널레이아웃
extension SearchProjectViewController {
    private func configureCollectionViewLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
        
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(149)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(38)
        )
        
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        section.boundarySupplementaryItems = [header]
        section.contentInsets = NSDirectionalEdgeInsets(top: 24, leading: 0, bottom: 30, trailing: 0)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}

// MARK: - 데이터소스
extension SearchProjectViewController {
    private func configureDataSource() {
        dataSource = DataSource(
            collectionView: projectListCollectionView
        ) { collectionView, indexPath, project in
            guard let cell = collectionView.dequeueReusableCell(ProjectCell.self, for: indexPath) else {
                return UICollectionViewCell()
            }
            cell.configureCell(with: project)
            cell.delegate = self
            return cell
        }
    }
    
    private func configureSupplementaryView(projectCount: Int) {
        dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard let headerView = collectionView.dequeueReusableSupplementaryView(
                ProjectCountHeaderView.self,
                ofKind: kind,
                for: indexPath
            ) else { return UICollectionReusableView() }
            
            headerView.configureCountLabel(with: String(projectCount))
            
            return headerView
        }
        
        projectListCollectionView.reloadData()  // 헤더 뷰 갱신
    }
    
    private func applySectionSnapshot(with projectList: [ProjectPreview]) {
        var snapshot = SectionSnapshot()
        snapshot.append(projectList)
        dataSource?.apply(snapshot, to: .main, animatingDifferences: true)
    }
}

// MARK: - CellDelgate
extension SearchProjectViewController: ProjectCellDelegate {
    func bookmarkButtonTapped(projectID: Int) {
        bookmarkButtonTapped.onNext(projectID)
    }
    
    func itemSelected(projectID: Int) {
        itemSelected.onNext(projectID)
    }
}
