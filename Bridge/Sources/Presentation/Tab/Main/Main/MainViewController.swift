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
        collectionView.register(ProjectCollectionViewCell.self)
        collectionView.register(
            ProjectSectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader
        )
        
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
    
    private let filterButton: UIButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 23, weight: .regular, scale: .default)
        let buttonImage = UIImage(systemName: "line.3.horizontal", withConfiguration: imageConfig)
        button.setImage(buttonImage, for: .normal)
        button.tintColor = .black
        
        return button
    }()

    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "검색해주세요."
        searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)  // 서치바 라인 삭제
        return searchBar
    }()
    
    private let viewModel: MainViewModel
    private let viewDidLoadTrigger = PublishRelay<Void>()
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, ProjectItems>
    typealias SectionSnapshot = NSDiffableDataSourceSectionSnapshot<ProjectItems>
    private var dataSource: DataSource?
    
    // MARK: - Initializer
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDidLoadTrigger.accept(())
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
        
        output.hotProjects
            .drive(onNext: { [weak self] hotProjects in
                self?.applySectionSnapshot(to: .hot, with: hotProjects)
            })
            .disposed(by: disposeBag)
        
        output.projects
            .drive(onNext: { [weak self] projects in
                self?.applySectionSnapshot(to: .main, with: projects)
            })
            .disposed(by: disposeBag)
    }
}
// MARK: - CompositionalLayout
extension MainViewController {
    private func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            let section = Section.allCases[sectionIndex]
            
            switch section {
            case .hot: return self?.createHotProjectSection()
            case .main: return self?.createProjectSection()
            }
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
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 30, trailing: 10)
        
        return section
    }
    
    private func createProjectSection() -> NSCollectionLayoutSection {
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
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(180)
        )
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        /// section 설정
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [header]
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 5, trailing: 10)
        
        return section
    }
}

// MARK: - Diffable data source
extension MainViewController {
    enum Section: CaseIterable {
        case hot
        case main
    }
    
    private func configureDataSource() -> DataSource {
        let dataSource = DataSource(
            collectionView: projectCollectionView
        ) { collectionView, indexPath, item in
            
            let section = Section.allCases[indexPath.section]

            switch section {
            case .hot:
                guard let cell = collectionView.dequeueReusableCell(
                    HotProjectCollectionViewCell.self,
                    for: indexPath)
                else { return UICollectionViewCell() }

                if case .hot(let hotProject) = item {
                    cell.configureCell(with: hotProject)
                }
                
                return cell

            case .main:
                guard let cell = collectionView.dequeueReusableCell(
                    ProjectCollectionViewCell.self,
                    for: indexPath)
                else { return UICollectionViewCell() }

                if case .main(let project) = item {
                    cell.configureCell(with: project)
                }
                
                return cell
            }
        }

        dataSource.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            self?.createSectionHeader(collectionView: collectionView, kind: kind, indexPath: indexPath)
        }
        
        return dataSource
    }
    
    private func createSectionHeader(
        collectionView: UICollectionView,
        kind: String,
        indexPath: IndexPath
    ) -> UICollectionReusableView? {
        if kind == UICollectionView.elementKindSectionHeader {
            
            guard let headerView = collectionView.dequeueReusableSupplementaryView(
                ProjectSectionHeaderView.self,
                ofKind: kind,
                for: indexPath
            ) else {
                return UICollectionReusableView()
            }
            
            let section = Section.allCases[indexPath.section]
            
            switch section {
            case .hot:
                headerView.configureHeader(titleText: "인기 폭발 프로젝트", subText: "HOT")
                
            case .main:
                headerView.configureHeader(titleText: "모집중인 프로젝트", subText: "NEW")
            }
    
            return headerView
        }
        return UICollectionReusableView()
    }
    
    private func applySectionSnapshot(to section: Section, with projects: [ProjectItems]) {
        var snapshot = SectionSnapshot()
        snapshot.append(projects)
        dataSource?.apply(snapshot, to: section)
    }
}
