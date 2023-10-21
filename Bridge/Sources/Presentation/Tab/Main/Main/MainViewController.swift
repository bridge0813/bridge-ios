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
    private let rootFlexContainer: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        
        return view
    }()
    
    private let topMenuView = TopMenuView()
    private let categoryView = MainCategoryView()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = BridgeColor.gray9
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(ProjectCell.self)
        collectionView.register(HotProjectCell.self)
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        rootFlexContainer.pin.all(view.pin.safeArea)
        rootFlexContainer.bringSubviewToFront(topMenuView)
        rootFlexContainer.flex.layout()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    // MARK: - Configure
    
    override func configureLayouts() {
        view.addSubview(rootFlexContainer)
    
        rootFlexContainer.flex.direction(.column).define { flex in
            flex.addItem(topMenuView)
            
            flex.addItem(categoryView)
                .position(.absolute)
                .height(102)
                .top(44)
            
            flex.addItem(collectionView)
                .position(.absolute)
                .top(146)
            
            flex.addItem(createProjectButton)
                .position(.absolute)
                .right(15)
                .bottom(15)
                .width(106)
                .height(48)
        }
    }
    
    // MARK: - Bind
    override func bind() {
        let input = MainViewModel.Input(
            viewWillAppear: self.rx.viewWillAppear.asObservable(),
            didScroll: collectionView.rx.contentOffset.asObservable(),
            filterButtonTapped: topMenuView.filterButton.rx.tap.asObservable(),
            itemSelected: collectionView.rx.itemSelected.asObservable(),
            createButtonTapped: createProjectButton.rx.tap.asObservable(),
            categoryButtonTapped: categoryView.categoryButtonTapped
        )
        let output = viewModel.transform(input: input)
        
        // MARK: - Project 데이터
        // viewWillAppear에 의해서 가져온 데이터로 기본값은 신규 데이터.
        output.projects
            .drive(onNext: { [weak self] projects in
                self?.updateCollectionViewForNew(with: projects)
                self?.categoryView.updateButtonState("new")
            })
            .disposed(by: disposeBag)
        
        // MARK: - 카테고리 버튼에 따라 컬렉션뷰(DataSource, Layout) 변경
        output.buttonTypeAndProjects
            .drive(onNext: { [weak self] type, projects in
                switch type {
                case "new":
                    self?.updateCollectionViewForNew(with: projects)
                    
                case "hot":
                    self?.updateCollectionViewForHot(with: projects)
                    self?.applySectionSnapshot(to: .hot, with: Array(projects.prefix(3)))
                    self?.applySectionSnapshot(to: .main, with: Array(projects.dropFirst(3)))
                    
                case "deadlineApproach":
                    self?.updateCollectionViewForDeadline(with: projects)
                    
                case "comingSoon", "comingSoon2":
                    self?.updateCollectionViewForComingSoon(with: projects)
                    
                default:
                    print(type)
                }
                
                self?.categoryView.updateButtonState(type)  // 버튼 상태 변경
            })
            .disposed(by: disposeBag)
        
        // MARK: - 스크롤에 따른 레이아웃 처리(버튼, Header 처리)
        output.buttonDisplayMode
            .drive(onNext: { [weak self] mode in
                self?.animateLayoutChange(to: mode)
            })
            .disposed(by: disposeBag)
        
        output.categoryAlpha
            .drive(onNext: { [weak self] alpha in
                self?.categoryView.alpha = alpha
            })
            .disposed(by: disposeBag)
        
        output.topMargins
            .drive(onNext: { [weak self] categoryMargin, collectionViewMargin in
                self?.updateTopMargin(categoryMargin: categoryMargin, collectionViewMargin: collectionViewMargin)
            })
            .disposed(by: disposeBag)
        
        // TODO: - 바인딩 처리 예정
        topMenuView.fieldCategoryAnchorButton.rx.tap.asDriver()
            .drive(onNext: { [weak self] in
                self?.topMenuView.fieldDropdown.show()
            })
            .disposed(by: disposeBag)
            
        
        topMenuView.fieldDropdown.itemSelected
            .withUnretained(self)
            .subscribe(onNext: { owner, item in
                owner.topMenuView.fieldCategoryAnchorButton.updateTitle(item.title)
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

// MARK: - 컬렉션 뷰의 Scroll 처리
extension MainViewController {
    func updateTopMargin(categoryMargin: CGFloat, collectionViewMargin: CGFloat) {
        topMenuView.dividerView.isHidden = categoryMargin == -58.0 ? false : true
        
        categoryView.flex
            .position(.absolute)
            .width(100%)
            .height(102)
            .top(categoryMargin)
        
        collectionView.flex
            .position(.absolute)
            .width(100%)
            .height(100%)
            .top(collectionViewMargin)
    
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
            guard let cell = collectionView.dequeueReusableCell(ProjectCell.self, for: indexPath) else {
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
            sectionContentInsets: NSDirectionalEdgeInsets(top: 24, leading: 0, bottom: 80, trailing: 0),
            boundaryItemKinds: isFooterNeed ? [.footer(topInset: 80)] : []
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
                guard let cell = collectionView.dequeueReusableCell(HotProjectCell.self, for: indexPath) else {
                    return UICollectionViewCell()
                }
                
                return cell
                
            case .main:
                guard let cell = collectionView.dequeueReusableCell(ProjectCell.self, for: indexPath) else {
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
            sectionContentInsets: NSDirectionalEdgeInsets(top: 26.2, leading: 0, bottom: 80, trailing: 0),
            boundaryItemKinds: isFooterNeed ? [.footer(topInset: 26)] : [.header(height: 42)]
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
            boundaryItemKinds: isFooterNeed ? [.header(height: 38), .footer(topInset: 52.2)] : [.header(height: 38)]
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
