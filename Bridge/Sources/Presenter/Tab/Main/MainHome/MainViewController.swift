//
//  MainViewController.swift
//  Bridge
//
//  Created by 엄지호 on 2023/08/28.
//

import UIKit
import FlexLayout
import PinLayout
import RxCocoa
import RxSwift

final class MainViewController: BaseViewController {
    // MARK: - Properties
    private let containerView = UIView()
    private lazy var projectCollectionView: UICollectionView = {
        let layout = createCompositionalLayout()
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(HotProjectCollectionViewCell.self)
        collectionView.register(ProjectSectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ProjectSectionHeaderView.identifier)
        
        return collectionView
    }()
    
    private lazy var goToNotificationButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            image: UIImage(systemName: "bell"),
            style: .done,
            target: self,
            action: nil
        )
        
        return button
    }()
    
    private let filterButton = UIButton()
    private let searchBar = UISearchBar()
    
    private let viewModel: MainViewModel
    private let viewDidLoadTrigger = PublishRelay<Void>()
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Project>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Project>
    private var dataSource: DataSource?
    
    // MARK: - Initializer
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureNavigationUI()
    }
    
    override func viewDidLayoutSubviews() {
        containerView.pin.all(view.pin.safeArea).marginTop(10)
        containerView.flex.layout()
    }
    
    // MARK: - Methods
    private func configureNavigationUI() {
        navigationItem.titleView = NavigationTitleView(title: "Bridge")  // 임의설정
        navigationItem.rightBarButtonItem = goToNotificationButton
        navigationController?.navigationBar.tintColor = .black
    }
    
    override func configureLayouts() {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 23, weight: .regular, scale: .default)
        let buttonImage = UIImage(systemName: "line.3.horizontal", withConfiguration: imageConfig)
        filterButton.setImage(buttonImage, for: .normal)
        filterButton.tintColor = .black
        
        searchBar.placeholder = "검색해주세요."
        searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)  // 서치바 라인 삭제
        
        view.addSubview(containerView)
        containerView.flex.direction(.column).define { flex in
            /// 상단 메뉴 버튼 및 서치바
            flex.addItem().height(70).direction(.row).justifyContent(.start).alignItems(.stretch).define { flex in
                flex.addItem(filterButton).marginLeft(10)
                flex.addItem(searchBar).shrink(1).marginLeft(5).marginRight(5)
            }
            
            /// 컬렉션 뷰
            flex.addItem(projectCollectionView).grow(1).marginTop(10)
        }
    }
    
    override func configureAttributes() {
        dataSource = configureDataSource()
        configureNavigationUI()
    }
    
    override func bind() {
        let input = MainViewModel.Input(viewDidLoadTrigger: viewDidLoadTrigger)
        let output = viewModel.transform(input: input)
        
        output.projects
            .compactMap { [weak self] projects in self?.createCurrentSnapshot(with: projects) }
            .drive { [weak self] snapshot in self?.dataSource?.apply(snapshot) }
            .disposed(by: disposeBag)
    }
    
}
// MARK: - CompositionalLayout
extension MainViewController {
    private func createCompositionalLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            return self?.createHotProjectSection()
        }

        return layout
    }
    
    private func createHotProjectSection() -> NSCollectionLayoutSection {
        /// item 설정
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        /// header 설정
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(60)
        )
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        
        /// group 설정
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(170),
            heightDimension: .absolute(170)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        /// section 설정
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [header]
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        
        return section
    }
}

// MARK: - Diffable data source
extension MainViewController {
    enum Section: CaseIterable {
        case main
    }
    
    func configureDataSource() -> DataSource {
        let dataSource = DataSource(collectionView: projectCollectionView,
                                    cellProvider: { collectionView, indexPath, item in
            
            guard let cell = collectionView.dequeueReusableCell(
                HotProjectCollectionViewCell.self,
                for: indexPath)
            else { return UICollectionViewCell() }
            
            cell.configureCell(with: item)
            print(item.title)
            return cell
        })
        
        dataSource.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            self?.createSectionHeader(collectionView: collectionView, kind: kind, indexPath: indexPath)
        }
        
        return dataSource
    }
    
    func createSectionHeader(
        collectionView: UICollectionView,
        kind: String,
        indexPath: IndexPath
    ) -> UICollectionReusableView? {
        if kind == UICollectionView.elementKindSectionHeader {
            
            guard let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: ProjectSectionHeaderView.identifier,
                for: indexPath) as? ProjectSectionHeaderView else {
                return UICollectionReusableView()
            }
            
            headerView.configureHeader(titleText: "인기 폭발 프로젝트", decoText: "HOT")
            return headerView
        }
        return UICollectionReusableView()
    }
    
    func createCurrentSnapshot(with projects: [Project]) -> Snapshot {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(projects)
        return snapshot
    }
}
