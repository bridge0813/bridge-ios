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
    // MARK: - UI
    private let rootFlexContainer = UIView()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = BridgeColor.gray9
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(MainProjectCell.self)
        collectionView.register(MainHotProjectCell.self)
        collectionView.register(
            ProjectCountHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader
        )
        
        collectionView.register(
            SectionDividerHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader
        )
        collectionView.register(
            ComingSoonPlaceholderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter
        )
        
        collectionView.register(
            EmptyProjectPlaceholderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter
        )
        return collectionView
    }()
    
    private let mainFieldCategoryAnchorButton = MainFieldCategoryAnchorButton()
    // TODO: - DataSource 동적으로 변경될 수 있도록 조정
    private lazy var mainFieldCategoryDropdown = DropDown(
        anchorView: mainFieldCategoryAnchorButton,
        bottomOffset: CGPoint(x: 10, y: 0),
        dataSource: ["UI/UX", "전체"],
        cellHeight: 46,
        itemTextColor: BridgeColor.gray3,
        itemTextFont: BridgeFont.body2.font,
        selectedItemTextColor: BridgeColor.gray1,
        dimmedBackgroundColor: .black.withAlphaComponent(0.3),
        width: 147,
        cornerRadius: 4
    )
    
    private let filterButton: UIButton = {
        let buttonImage = UIImage(named: "hamburger")?
            .resize(to: CGSize(width: 24, height: 24))
            
        let button = UIButton()
        button.setImage(buttonImage, for: .normal)
        return button
    }()
    
    private let searchButton: UIButton = {
        let buttonImage = UIImage(named: "magnifyingglass")?
            .resize(to: CGSize(width: 24, height: 24))
            
        let button = UIButton()
        button.setImage(buttonImage, for: .normal)
        return button
    }()

    private let mainCategoryHeaderView = MainCategoryHeaderView()
    
    private let createProjectButton = BridgeCreateProjectButton()
    
    // MARK: - Properties
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        rootFlexContainer.pin.all(view.pin.safeArea)
        rootFlexContainer.flex.layout()
    }
    
    // MARK: - Configure
    private func configureNavigationUI() {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func configureLayouts() {
        view.addSubview(rootFlexContainer)
        
        rootFlexContainer.flex.direction(.column).define { flex in
            flex.addItem().direction(.row).alignItems(.center).height(48).define { flex in
                flex.addItem(mainFieldCategoryAnchorButton).marginLeft(5)
                flex.addItem().grow(1)
                flex.addItem(filterButton).size(24).marginRight(8)
                flex.addItem(searchButton).size(24).marginRight(15)
            }
            
            flex.addItem(collectionView)
                .position(.absolute)
                .top(150)
            
            flex.addItem(mainCategoryHeaderView).height(102)
            
            flex.addItem(createProjectButton)
                .position(.absolute)
                .right(15)
                .bottom(15)
                .width(106)
                .height(48)
        }
    }
    
    override func configureAttributes() {
        configureNavigationUI()
    }
    
    // MARK: - Bind
    override func bind() {
        let input = MainViewModel.Input(
            viewWillAppear: self.rx.viewWillAppear.asObservable(),
            didScroll: collectionView.rx.contentOffset.asObservable(),
            filterButtonTapped: filterButton.rx.tap.asObservable(),
            itemSelected: collectionView.rx.itemSelected.asObservable(),
            createButtonTapped: createProjectButton.rx.tap.asObservable(),
            categoryButtonTapped: mainCategoryHeaderView.categoryButtonTapped
        )
        let output = viewModel.transform(input: input)
        
        // MARK: - Project 데이터
        // viewWillAppear에 의해서 가져온 데이터로 기본값은 신규 데이터.
        output.projects
            .drive(onNext: { [weak self] projects in
                self?.updateCollectionViewForNew(with: projects)
                self?.mainCategoryHeaderView.updateButtonState(.new)
            })
            .disposed(by: disposeBag)
        
        // MARK: - 카테고리 버튼에 따라 컬렉션뷰(DataSource, Layout) 변경
        output.buttonTypeAndProjects
            .drive(onNext: { [weak self] type, projects in
                switch type {
                case .new:
                    self?.updateCollectionViewForNew(with: projects)
                    
                case .hot:
                    self?.updateCollectionViewForHot(with: projects)
                    // 랭킹 3까지만 인기 섹션으로 이동
                    self?.applySectionSnapshot(to: .hot, with: Array(projects.prefix(3)))
                    
                    // 인기순위 3개를 제외한 나머지 데이터
                    self?.applySectionSnapshot(to: .main, with: Array(projects.dropFirst(3)))
                    
                case .deadlineApproach:
                    self?.updateCollectionViewForDeadline(with: projects)
                    
                case .comingSoon, .comingSoon2:
                    self?.updateCollectionViewForComingSoon(with: projects)
                }
                
                self?.mainCategoryHeaderView.updateButtonState(type)  // 버튼 상태 변경
            })
            .disposed(by: disposeBag)
        
        // MARK: - 스크롤에 따른 레이아웃 처리(버튼, Header 처리)
        output.buttonDisplayMode
            .drive(onNext: { [weak self] mode in
                self?.animateLayoutChange(to: mode)
            })
            .disposed(by: disposeBag)
        
        output.headerAlpha
            .drive(onNext: { [weak self] alpha in
                self?.mainCategoryHeaderView.alpha = alpha
            })
            .disposed(by: disposeBag)
        
        output.collectionViewTopMargin
            .drive(onNext: { [weak self] topMargin in
                self?.updateCollectionViewTopMargin(topMargin)
            })
            .disposed(by: disposeBag)
        
        // TODO: - 바인딩 처리 예정
        mainFieldCategoryAnchorButton.rx.tap.asDriver()
            .drive(onNext: { [weak self] in
                self?.mainFieldCategoryDropdown.show()
            })
            .disposed(by: disposeBag)
        
        mainFieldCategoryDropdown.itemSelected
            .withUnretained(self)
            .subscribe(onNext: { owner, item in
                owner.mainFieldCategoryAnchorButton.updateTitle(item.title)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - CreateProjectButtonAnimation
extension MainViewController {
    private func animateLayoutChange(to mode: MainViewModel.CreateButtonDisplayState) {
        UIView.animate(
            withDuration: 0.2,
            animations: { [weak self] in
                self?.createProjectButton.updateButtonConfiguration(for: mode)
                self?.updateButtonLayout(for: mode)
            },
            completion: { [weak self] _ in
                self?.createProjectButton.updateButtonTitle(for: mode)
                self?.createProjectButton.contentHorizontalAlignment = .center
            }
        )
    }
    
    // MARK: - Button Layout
    private func updateButtonLayout(for state: MainViewModel.CreateButtonDisplayState) {
        let buttonWidth: CGFloat = state == .both ? 106 : 48
        
        createProjectButton.flex
            .position(.absolute)
            .cornerRadius(24)
            .width(buttonWidth)
            .height(48)
        
        rootFlexContainer.flex.layout()
    }
}

// MARK: - Sticky Header
extension MainViewController {
    func updateCollectionViewTopMargin(_ topMargin: CGFloat) {
        collectionView.flex
            .position(.absolute)
            .width(100%)
            .height(100%)
            .top(topMargin)
    
        rootFlexContainer.flex.layout()
    }
}

// MARK: - 카테고리 -> 신규일 경우
extension MainViewController {
    private func applySectionSnapshot(to section: MainViewModel.Section, with projects: [Project]) {
        var snapshot = SectionSnapshot()
        snapshot.append(projects)
        dataSource?.apply(snapshot, to: section)
    }
    
    /// 섹션이 하나일 때, 기본적인 DataSource(신규, 마감임박, 출시예정에서 사용됨)
    private func configureDataSource() {
        dataSource = DataSource(
            collectionView: collectionView
        ) { collectionView, indexPath, _ in
            guard let cell = collectionView.dequeueReusableCell(MainProjectCell.self, for: indexPath) else {
                return UICollectionViewCell()
            }
            
            return cell
        }
    }
    
    private func updateCollectionViewForNew(with projects: [Project]) {
        configureDataSource()
        configureSupplementaryViewForNew()
        collectionView.isScrollEnabled = !projects.isEmpty
        collectionView.collectionViewLayout = configureCompositionalLayoutForNew(projects.isEmpty)
        applySectionSnapshot(to: .main, with: projects)
    }
    
    private func configureSupplementaryViewForNew() {
        dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard let footerView = collectionView.dequeueReusableSupplementaryView(
                EmptyProjectPlaceholderView.self,
                ofKind: kind,
                for: indexPath
            ) else { return UICollectionReusableView() }
            
            return footerView
        }
    }
    
    private func configureCompositionalLayoutForNew(_ isFooterNeed: Bool) -> UICollectionViewLayout {
        let config = CompositionalLayoutConfiguration(
            groupHeight: 160,
            sectionContentInsets: NSDirectionalEdgeInsets(top: 24.2, leading: 0, bottom: 80, trailing: 0),
            boundaryItemKinds: isFooterNeed ? [.footer] : []
        )
        
        return config.configureCompositionalLayout()
    }
}

// MARK: - 카테고리 -> 인기일 경우
extension MainViewController {
    private func updateCollectionViewForHot(with projects: [Project]) {
        configureDataSourceForHot()
        configureSupplementaryViewForHot(projects.count)
        collectionView.isScrollEnabled = !projects.isEmpty
        collectionView.collectionViewLayout = configureCompositionalLayoutForHot(projects.isEmpty)
    }
    
    private func configureDataSourceForHot() {
        dataSource = DataSource(
            collectionView: collectionView
        ) { collectionView, indexPath, _ in
            
            let section = MainViewModel.Section.allCases[indexPath.section]
            
            switch section {
            case .hot:
                guard let cell = collectionView.dequeueReusableCell(MainHotProjectCell.self, for: indexPath) else {
                    return UICollectionViewCell()
                }
                
                return cell
                
            case .main:
                guard let cell = collectionView.dequeueReusableCell(MainProjectCell.self, for: indexPath) else {
                    return UICollectionViewCell()
                }
                
                return cell
            }
        }
    }
    
    private func configureSupplementaryViewForHot(_ count: Int) {
        dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath in
            
            let section = MainViewModel.Section.allCases[indexPath.section]
            
            switch kind {
                
            case UICollectionView.elementKindSectionHeader:
                switch section {
                case .hot:
                    guard let headerView = collectionView.dequeueReusableSupplementaryView(
                        ProjectCountHeaderView.self,
                        ofKind: kind,
                        for: indexPath
                    ) else { return UICollectionReusableView() }
                    
                    headerView.configureCountLabel(with: String(count))
                    
                    return headerView
            
                case .main:
                    guard let headerView = collectionView.dequeueReusableSupplementaryView(
                        SectionDividerHeaderView.self,
                        ofKind: kind,
                        for: indexPath
                    ) else { return UICollectionReusableView() }
                    
                    return headerView
                }
                
            case UICollectionView.elementKindSectionFooter:
                guard let footerView = collectionView.dequeueReusableSupplementaryView(
                    EmptyProjectPlaceholderView.self,
                    ofKind: kind,
                    for: indexPath
                ) else { return UICollectionReusableView() }
                
                return footerView
                
                
            default:
                return UICollectionReusableView()
            }
        }
    }
    
    private func configureCompositionalLayoutForHot(_ isFooterNeed: Bool) -> UICollectionViewLayout {
        let hotSectionConfig = CompositionalLayoutConfiguration(
            groupHeight: 110,
            sectionContentInsets: NSDirectionalEdgeInsets(top: 16.2, leading: 0, bottom: 0, trailing: 0),
            boundaryItemKinds: [.header(height: 38)]
        )
        
        let mainSectionConfig = CompositionalLayoutConfiguration(
            groupHeight: 160,
            sectionContentInsets: NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 80, trailing: 0),
            boundaryItemKinds: isFooterNeed ? [.footer] : [.header(height: 70)]
        )
        
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            let section = MainViewModel.Section.allCases[sectionIndex]
            
            switch section {
            case .hot:
                return hotSectionConfig.configureSectionLayout()
                
            case .main:
                return mainSectionConfig.configureSectionLayout()
            }
        }
        
        return layout
    }
}

// MARK: - 카테고리 -> 마감임박일 경우
extension MainViewController {
    private func updateCollectionViewForDeadline(with projects: [Project]) {
        configureDataSource()
        configureSupplementaryViewForDeadline(projects.count)
        collectionView.isScrollEnabled = !projects.isEmpty
        collectionView.collectionViewLayout = configureCompositionalLayoutForDeadline(projects.isEmpty)
        applySectionSnapshot(to: .main, with: projects)
    }
    
    private func configureSupplementaryViewForDeadline(_ count: Int) {
        dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath in
            switch kind {
                
            case UICollectionView.elementKindSectionHeader:
                guard let headerView = collectionView.dequeueReusableSupplementaryView(
                    ProjectCountHeaderView.self,
                    ofKind: kind,
                    for: indexPath
                ) else { return UICollectionReusableView() }
                
                headerView.configureCountLabel(with: String(count))
                
                return headerView
                
            case UICollectionView.elementKindSectionFooter:
                guard let footerView = collectionView.dequeueReusableSupplementaryView(
                    EmptyProjectPlaceholderView.self,
                    ofKind: kind,
                    for: indexPath
                ) else { return UICollectionReusableView() }
                
                return footerView
                
            default:
                return UICollectionReusableView()
            }
        }
    }
    
    private func configureCompositionalLayoutForDeadline(_ isFooterNeed: Bool) -> UICollectionViewLayout {
        let config = CompositionalLayoutConfiguration(
            groupHeight: 160,
            sectionContentInsets: NSDirectionalEdgeInsets(top: 16.2, leading: 0, bottom: 80, trailing: 0),
            boundaryItemKinds: isFooterNeed ? [.header(height: 38), .footer] : [.header(height: 38)]
        )
        
        return config.configureCompositionalLayout()
    }
}

// MARK: - 카테고리 -> 출시예정일 경우
extension MainViewController {
    private func updateCollectionViewForComingSoon(with projects: [Project]) {
        configureDataSource()
        configureSupplementaryViewForComingSoon()
        collectionView.isScrollEnabled = false
        collectionView.collectionViewLayout = configureCompositionalLayoutForNew(projects.isEmpty)
        applySectionSnapshot(to: .main, with: projects)
    }
    
    private func configureSupplementaryViewForComingSoon() {
        dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard let footerView = collectionView.dequeueReusableSupplementaryView(
                ComingSoonPlaceholderView.self,
                ofKind: kind,
                for: indexPath
            ) else { return UICollectionReusableView() }
            
            return footerView
        }
    }
}
