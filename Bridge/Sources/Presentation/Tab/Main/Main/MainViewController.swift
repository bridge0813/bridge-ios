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
    private let rootFlexContainer = UIView()
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
    
    private let tagButton = TagButton("Java")
    private let outlinedTagButton = OutlinedTagButton("Swift")
    
    private let bookmarkButton = BookmarkButton()
    private let removeButton = RemoveButton()
    private let fieldTagButton = FieldTagButton("프론트엔드")
    private let confirmButton = BridgeButton("보러가기", style: .confirm)
    private let cancelButton = BridgeButton("그만두기", style: .cancel)
    private let applyButton = BridgeButton("지원하기", style: .apply)
    private let detailButton = BridgeButton("프로젝트 상세", style: .detail)
    private let sendMessageButton = SendMessageButton()
    private let nextButton = NextButton()
    
    private let recruiterDecisionMenuView = RecruiterDecisionMenuView()
    private let recruiterMenuView = RecruiterMenuView()
    
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
    
    private lazy var createProjectButton: UIButton = {
        let button = UIButton(configuration: createConfigForBoth())
        button.tintColor = .white
        button.backgroundColor = .gray
        button.clipsToBounds = true
        
        return button
    }()
    
    private let viewModel: MainViewModel
    
    typealias DataSource = UICollectionViewDiffableDataSource<MainViewModel.Section, Project>
    typealias SectionSnapshot = NSDiffableDataSourceSectionSnapshot<Project>
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
        super.viewDidLayoutSubviews()
        rootFlexContainer.pin.all(view.pin.safeArea).marginTop(10)
        rootFlexContainer.flex.layout()
    }
    
    // MARK: - Methods
    private func configureNavigationUI() {
        navigationItem.titleView = NavigationTitleView(title: "Bridge")  // 임의설정
        navigationItem.rightBarButtonItem = goToNotificationButton
        navigationController?.navigationBar.tintColor = .black
    }
    
    override func configureLayouts() {
        view.addSubview(rootFlexContainer)
        
        rootFlexContainer.flex.direction(.column).define { flex in
            // 테스트용
            flex.addItem().height(70).direction(.row).alignItems(.center).define { flex in
                flex.addItem(tagButton).width(70).height(38).marginLeft(15)
                flex.addItem(outlinedTagButton).width(93).height(38).marginLeft(15)
            }
            
            flex.addItem().height(70).direction(.row).alignItems(.center).define { flex in
                flex.addItem(bookmarkButton).width(54).height(52).marginLeft(15)
                flex.addItem(removeButton).width(38).height(38).marginLeft(15)
                flex.addItem(fieldTagButton).width(101).height(37).marginLeft(15)
                flex.addItem(sendMessageButton).width(38).height(38).marginLeft(15)
            }
            
            flex.addItem().height(70).direction(.row).alignItems(.center).define { flex in
                flex.addItem(confirmButton).width(123.5).height(44).marginLeft(15)
                flex.addItem(cancelButton).width(123.5).height(44).marginLeft(15)
            }
            
            flex.addItem().height(70).direction(.row).alignItems(.center).define { flex in
                flex.addItem(nextButton).width(343).height(52).marginLeft(10)
            }
            
            flex.addItem(applyButton).width(277).height(52).marginTop(20).marginLeft(10)
            flex.addItem(detailButton).width(307).height(44).marginTop(20).marginLeft(10)
            flex.addItem(recruiterDecisionMenuView).width(307).height(48).marginTop(20).marginLeft(10)
            flex.addItem(recruiterMenuView).width(307).height(44).marginTop(20).marginLeft(10)
            
            /// 컬렉션 뷰
            flex.addItem(projectCollectionView).grow(1).marginTop(20)
            
            flex.addItem(createProjectButton)
                .cornerRadius(23)
                .position(.absolute)
                .right(15)
                .bottom(15)
                .width(110)
                .height(50)
        }
    }
    
    override func configureAttributes() {
        configureCellDataSource()
        configureHeaderDataSource()
        configureNavigationUI()
    }
    
    override func bind() {
        let input = MainViewModel.Input(
            viewWillAppear: self.rx.viewWillAppear.asObservable(),
            didScroll: projectCollectionView.rx.contentOffset.asObservable(),
            notificationButtonTapped: goToNotificationButton.rx.tap.asObservable(),
            filterButtonTapped: filterButton.rx.tap.asObservable(),
            searchButtonTapped: searchBar.rx.searchButtonClicked.withLatestFrom(searchBar.rx.text),
            itemSelected: projectCollectionView.rx.itemSelected.asObservable(),
            createButtonTapped: createProjectButton.rx.tap.asObservable()
        )
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
        
        output.layoutMode
            .drive(onNext: { [weak self] mode in
                self?.animateLayoutChange(to: mode)
            })
            .disposed(by: disposeBag)
    }
}
// MARK: - CompositionalLayout
extension MainViewController {
    private func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            let section = MainViewModel.Section.allCases[sectionIndex]
            
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
    private func configureCellDataSource() {
        dataSource = DataSource(
            collectionView: projectCollectionView
        ) { collectionView, indexPath, item in
            
            let section = MainViewModel.Section.allCases[indexPath.section]
            
            switch section {
            case .hot:
                guard let cell = collectionView.dequeueReusableCell(
                    HotProjectCollectionViewCell.self,
                    for: indexPath)
                else { return UICollectionViewCell() }
                
                cell.configureCell(with: item)
                return cell
                
            case .main:
                guard let cell = collectionView.dequeueReusableCell(
                    ProjectCollectionViewCell.self,
                    for: indexPath)
                else { return UICollectionViewCell() }
                
                cell.configureCell(with: item)
                return cell
            }
        }
    }
    
    private func configureHeaderDataSource() {
        dataSource?.supplementaryViewProvider = { collectionview, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionHeader else {
                return UICollectionReusableView()
            }
                
            guard let headerView = collectionview.dequeueReusableSupplementaryView(
                ProjectSectionHeaderView.self,
                ofKind: kind,
                for: indexPath
            ) else {
                return UICollectionReusableView()
            }
                
            headerView.configureHeader(with: indexPath)
            
            return headerView
        }
    }
    
    private func applySectionSnapshot(to section: MainViewModel.Section, with projects: [Project]) {
        var snapshot = SectionSnapshot()
        snapshot.append(projects)
        dataSource?.apply(snapshot, to: section)
    }
}

// MARK: - ScrollEvent
extension MainViewController {
    // MARK: - Button Animation
    private func animateLayoutChange(to mode: MainViewModel.CreateButtonDisplayState) {
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.updateButtonLayout(for: mode)
            self?.updateButtonConfig(for: mode)
        }
    }
    
    // MARK: - Button Layout
    private func updateButtonLayout(for state: MainViewModel.CreateButtonDisplayState) {
        switch state {
        case .both:
            layoutCreateButton(width: 110, height: 50, radius: 23)
            
        case .only:
            layoutCreateButton(width: 60, height: 60, radius: 30)
        }
    }
    
    private func layoutCreateButton(width: CGFloat, height: CGFloat, radius: CGFloat) {
        createProjectButton.flex
            .position(.absolute)
            .cornerRadius(radius)
            .width(width)
            .height(height)
        
        rootFlexContainer.flex.layout()
    }
    
    // MARK: - Button Configuration
    private func updateButtonConfig(for state: MainViewModel.CreateButtonDisplayState) {
        switch state {
        case .both:
            createProjectButton.configuration = createConfigForBoth()
            
        case .only:
            createProjectButton.configuration = createConfigForOnly()
        }
    }

    private func createConfigForBoth() -> UIButton.Configuration {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular, scale: .default)
        let image = UIImage(systemName: "plus", withConfiguration: imageConfig)
    
        var configuration = UIButton.Configuration.tinted()
        configuration.image = image
        configuration.imagePlacement = .leading
        configuration.imagePadding = 5
        configuration.title = "글쓰기"
        configuration.attributedTitle?.font = .boldSystemFont(ofSize: 20)
        configuration.baseBackgroundColor = .darkGray
        
        return configuration
    }
    
    private func createConfigForOnly() -> UIButton.Configuration {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .regular, scale: .default)
        let image = UIImage(systemName: "plus", withConfiguration: imageConfig)
        
        var configuration = UIButton.Configuration.tinted()
        configuration.image = image
        configuration.baseBackgroundColor = .darkGray
        
        return configuration
    }
}
