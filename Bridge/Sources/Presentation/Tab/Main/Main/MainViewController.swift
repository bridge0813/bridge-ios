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
    
    private let placeholderView: BridgePlaceholderView = {
        let view = BridgePlaceholderView()
        view.isHidden = true
        
        return view
    }()
    
    private let fieldCategoryAnchorButton = FieldCategoryAnchorButton()
    private lazy var fieldDropdown: DropDown = {
        let dropdown = DropDown(
            anchorView: fieldCategoryAnchorButton,
            bottomOffset: CGPoint(x: 0, y: 10),
            dataSource: ["UI/UX", "전체"],
            cellHeight: 46,
            itemTextColor: BridgeColor.gray03,
            itemTextFont: BridgeFont.body2.font,
            selectedItemTextColor: BridgeColor.gray01,
            dimmedBackgroundColor: .black.withAlphaComponent(0.3),
            width: 147,
            cornerRadius: 4
        )
        
        return dropdown
    }()
    
    private lazy var filterButton = UIBarButtonItem(
        image: UIImage(named: "hamburger")?
            .resize(to: CGSize(width: 24, height: 24))
            .withRenderingMode(.alwaysTemplate)
            .withAlignmentRectInsets(UIEdgeInsets(top: 0, left: 35, bottom: 0, right: 0)),
        style: .plain,
        target: self,
        action: nil
    )
    
    private lazy var searchButton = UIBarButtonItem(
        image: UIImage(named: "magnifyingglass")?
            .resize(to: CGSize(width: 24, height: 24))
            .withRenderingMode(.alwaysTemplate)
            .withAlignmentRectInsets(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)),
        style: .plain,
        target: self,
        action: nil
    )
    
    private let dividerView: UIView = {
        let divider = UIView()
        divider.flex.width(100%).height(1)
        divider.backgroundColor = BridgeColor.gray06
        
        return divider
    }()
    
    private let categoryView: MainCategoryView = {
        let view = MainCategoryView()
        view.flex.width(100%).height(102)
        
        return view
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.flex.width(100%).height(100%)
        collectionView.backgroundColor = BridgeColor.gray09
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

        return collectionView
    }()
    
    private let createProjectButton = BridgeCreateProjectButton()
    
    // MARK: - Property
    private let viewModel: MainViewModel
    
    private typealias DataSource = UICollectionViewDiffableDataSource<MainViewModel.Section, ProjectPreview>
    private typealias SectionSnapshot = NSDiffableDataSourceSectionSnapshot<ProjectPreview>
    private var dataSource: DataSource?
    
    // MARK: - Init
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNoShadowNavigationBarAppearance()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        configureDefaultNavigationBarAppearance()
    }
    
    // MARK: - Configuration
    override func configureAttributes() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: fieldCategoryAnchorButton)
        navigationItem.rightBarButtonItems = [searchButton, filterButton]
    }
    
    // MARK: - Layout
    override func configureLayouts() {
        view.addSubview(rootFlexContainer)
        rootFlexContainer.flex.define { flex in
            flex.addItem(categoryView).position(.absolute)
            flex.addItem(collectionView).position(.absolute)
              
            flex.addItem(dividerView)
            flex.addItem(placeholderView).grow(1).marginTop(102)
            
            flex.addItem(createProjectButton).position(.absolute).right(15).bottom(15)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        rootFlexContainer.pin.all(view.pin.safeArea)
        rootFlexContainer.flex.layout()
    }
    
    // MARK: - Binding
    override func bind() {
        let input = MainViewModel.Input(
            viewWillAppear: self.rx.viewWillAppear.asObservable(),
            filterButtonTapped: filterButton.rx.tap.asObservable(),
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
        
        // 카테고리 버튼에 따라 컬렉션뷰(DataSource, Layout) 변경
//        output.buttonTypeAndProjects
//            .drive(onNext: { [weak self] type, projects in
//                switch type {
//                case "new":
//                    self?.updateCollectionViewForNew(with: projects)
//
//                case "hot":
//                    self?.updateCollectionViewForHot(with: projects)
//                    self?.applySectionSnapshot(to: .hot, with: Array(projects.prefix(3)))
//                    self?.applySectionSnapshot(to: .main, with: Array(projects.dropFirst(3)))
//
//                case "deadlineApproach":
//                    self?.updateCollectionViewForDeadline(with: projects)
//
//                case "comingSoon", "comingSoon2":
//                    self?.updateCollectionViewForComingSoon(with: projects)
//
//                default:
//                    print(type)
//                }
//
//                self?.categoryView.updateButtonState(type)  // 버튼 상태 변경
//            })
//            .disposed(by: disposeBag)
        
        // 스크롤에 따른 레이아웃 처리
        collectionView.rx.contentOffset
            .observe(on: MainScheduler.asyncInstance)
            .withUnretained(self)
            .subscribe(onNext: { owner, offset in
                let categoryHeight: CGFloat = 102
                let minAlpha: CGFloat = 0.0
                let maxAlpha: CGFloat = 1.0
                let minCategoryMargin: CGFloat = -categoryHeight

                // 글쓰기 버튼 애니메이션 처리
                owner.animateCreateButton(for: offset.y <= 0)

                // 카테고리 헤더 뷰의 알파값 조정
                let alphaOffset = offset.y / categoryHeight
                let alpha = max(minAlpha, maxAlpha - alphaOffset)
                owner.categoryView.alpha = alpha

                // 컬렉션뷰 마진 계산
                let collectionViewMargin = min(categoryHeight, max(0, categoryHeight - offset.y))

                // 카테고리 마진 계산
                let categoryMargin = min(0, max(minCategoryMargin, -offset.y))
                owner.updateTopMargin(categoryMargin: categoryMargin, collectionViewMargin: collectionViewMargin)
            })
            .disposed(by: disposeBag)
        
        // 드롭다운 Show
        fieldCategoryAnchorButton.rx.tap.asDriver()
            .drive(onNext: { [weak self] in
                self?.fieldDropdown.show()
            })
            .disposed(by: disposeBag)
            
        // TODO: - 바인딩 처리 예정
        fieldDropdown.itemSelected.asDriver(onErrorJustReturn: (0, ""))
            .drive(onNext: { [weak self] item in
                self?.fieldCategoryAnchorButton.updateTitle(item.title)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - 글쓰기버튼 애니메이션
extension MainViewController {
    private func animateCreateButton(for isExpanded: Bool) {
        UIView.animate(
            withDuration: 0.2,
            animations: { [weak self] in
                self?.createProjectButton.updateButtonConfiguration(for: isExpanded)
                self?.updateButtonLayout(for: isExpanded)
            },
            completion: { [weak self] _ in
                self?.createProjectButton.updateButtonTitle(for: isExpanded)
                self?.createProjectButton.contentHorizontalAlignment = .center
            }
        )
    }
    
    private func updateButtonLayout(for isExpanded: Bool) {
        let buttonWidth: CGFloat = isExpanded ? 106 : 48
        
        createProjectButton.flex.width(buttonWidth).height(48)
        rootFlexContainer.flex.layout()
    }
}

// MARK: - 컬렉션 뷰 및 헤더 뷰 애니메이션
extension MainViewController {
    func updateTopMargin(categoryMargin: CGFloat, collectionViewMargin: CGFloat) {
        dividerView.isHidden = categoryMargin != -102
        
        categoryView.flex.top(categoryMargin)
        collectionView.flex.top(collectionViewMargin)
        rootFlexContainer.flex.layout()
    }
}

// MARK: - 카테고리 -> 신규일 경우
extension MainViewController {
    private func applySectionSnapshot(to section: MainViewModel.Section, with projects: [ProjectPreview]) {
        var snapshot = SectionSnapshot()
        snapshot.append(projects)
        dataSource?.apply(snapshot, to: section)
    }
    
    /// 섹션이 하나일 때, 기본적인 DataSource(신규, 마감임박, 출시예정에서 사용됨)
    private func configureDataSource() {
        dataSource = DataSource(
            collectionView: collectionView
        ) { collectionView, indexPath, project in
            guard let cell = collectionView.dequeueReusableCell(ProjectCell.self, for: indexPath) else {
                return UICollectionViewCell()
            }
            cell.configureCell(with: project)
            return cell
        }
    }
    
    private func updateCollectionViewForNew(with projects: [ProjectPreview]) {
        placeholderView.configurePlaceholderView(for: .emptyProject)
        placeholderView.isHidden = !projects.isEmpty
        
        configureDataSource()
        collectionView.collectionViewLayout = configureCompositionalLayoutForNew()
        applySectionSnapshot(to: .main, with: projects)
    }
    
    private func configureCompositionalLayoutForNew() -> UICollectionViewLayout {
        let config = CompositionalLayoutConfiguration(
            groupHeight: 149,
            sectionContentInsets: NSDirectionalEdgeInsets(top: 24, leading: 0, bottom: 30, trailing: 0),
            headerHeight: nil
        )
        
        return config.configureCompositionalLayout()
    }
}

// MARK: - 카테고리 -> 인기일 경우
extension MainViewController {
    private func updateCollectionViewForHot(with projects: [ProjectPreview]) {
        placeholderView.configurePlaceholderView(for: .emptyProject)
        placeholderView.isHidden = !projects.isEmpty
        
        configureDataSourceForHot()
        configureSupplementaryViewForHot(projects.count)
        collectionView.collectionViewLayout = configureCompositionalLayoutForHot()
    }
    
    private func configureDataSourceForHot() {
        dataSource = DataSource(
            collectionView: collectionView
        ) { collectionView, indexPath, project in
            
            let section = MainViewModel.Section.allCases[indexPath.section]
            
            switch section {
            case .hot:
                guard let cell = collectionView.dequeueReusableCell(HotProjectCell.self, for: indexPath) else {
                    return UICollectionViewCell()
                }
                
                cell.configureCell(with: project)
                return cell
                
            case .main:
                guard let cell = collectionView.dequeueReusableCell(ProjectCell.self, for: indexPath) else {
                    return UICollectionViewCell()
                }
                
                cell.configureCell(with: project)
                return cell
            }
        }
    }
    
    private func configureSupplementaryViewForHot(_ count: Int) {
        dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath in
            let section = MainViewModel.Section.allCases[indexPath.section]
            
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
        }
    }
    
    private func configureCompositionalLayoutForHot() -> UICollectionViewLayout {
        let hotSectionConfig = CompositionalLayoutConfiguration(
            groupHeight: 100,
            sectionContentInsets: NSDirectionalEdgeInsets(top: 24, leading: 0, bottom: 34, trailing: 0),
            headerHeight: 38
        )
        
        let mainSectionConfig = CompositionalLayoutConfiguration(
            groupHeight: 149,
            sectionContentInsets: NSDirectionalEdgeInsets(top: 34, leading: 0, bottom: 30, trailing: 0),
            headerHeight: 8
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
    private func updateCollectionViewForDeadline(with projects: [ProjectPreview]) {
        placeholderView.configurePlaceholderView(for: .emptyProject)
        placeholderView.isHidden = !projects.isEmpty
        
        configureDataSource()
        configureSupplementaryViewForDeadline(projects.count)
        collectionView.collectionViewLayout = configureCompositionalLayoutForDeadline()
        applySectionSnapshot(to: .main, with: projects)
    }
    
    private func configureSupplementaryViewForDeadline(_ count: Int) {
        dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard let headerView = collectionView.dequeueReusableSupplementaryView(
                ProjectCountHeaderView.self,
                ofKind: kind,
                for: indexPath
            ) else { return UICollectionReusableView() }
            
            headerView.configureCountLabel(with: String(count))
            
            return headerView
        }
    }
    
    private func configureCompositionalLayoutForDeadline() -> UICollectionViewLayout {
        let config = CompositionalLayoutConfiguration(
            groupHeight: 149,
            sectionContentInsets: NSDirectionalEdgeInsets(top: 24, leading: 0, bottom: 30, trailing: 0),
            headerHeight: 38
        )
        
        return config.configureCompositionalLayout()
    }
}

// MARK: - 카테고리 -> 출시예정일 경우
extension MainViewController {
    private func updateCollectionViewForComingSoon(with projects: [ProjectPreview]) {
        placeholderView.configurePlaceholderView(for: .comingSoon)
        placeholderView.isHidden = false
        
        configureDataSource()
        collectionView.collectionViewLayout = configureCompositionalLayoutForNew()
        applySectionSnapshot(to: .main, with: projects)
    }
}
