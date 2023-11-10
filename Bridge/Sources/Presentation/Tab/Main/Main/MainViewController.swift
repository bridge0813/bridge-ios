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
    
    private let placeholderView: PlaceholderView = {
        let placeholderView = PlaceholderView()
        placeholderView.backgroundColor = BridgeColor.gray09
        placeholderView.isHidden = true
        
        return placeholderView
    }()
    
    private let fieldCategoryAnchorButton = FieldCategoryAnchorButton()
    private lazy var fieldDropdown: DropDown = {
        let dropdown = DropDown(
            anchorView: fieldCategoryAnchorButton,
            bottomOffset: CGPoint(x: 0, y: 10),
            dataSource: ["UI/UX", "전체"],
            cellHeight: 46,
            itemTextColor: BridgeColor.gray3,
            itemTextFont: BridgeFont.body2.font,
            selectedItemTextColor: BridgeColor.gray1,
            dimmedBackgroundColor: .black.withAlphaComponent(0.3),
            width: 147,
            cornerRadius: 4
        )
        
        return dropdown
    }()
    
    private let filterButton: UIButton = {
        let buttonImage = UIImage(named: "hamburger")?
            .resize(to: CGSize(width: 24, height: 24))
        
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = .clear
        configuration.baseForegroundColor = .clear
        configuration.image = buttonImage
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 8)
        
        let button = UIButton()
        button.configuration = configuration
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
    
    private let categoryView = MainCategoryView()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
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
    
    typealias DataSource = UICollectionViewDiffableDataSource<MainViewModel.Section, Project>
    typealias SectionSnapshot = NSDiffableDataSourceSectionSnapshot<Project>
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        rootFlexContainer.pin.all(view.pin.safeArea)
        rootFlexContainer.flex.layout()
    }
    
    // MARK: - Configuration
    override func configureAttributes() {
        configureNavigationUI()
    }
    
    private func configureNavigationUI() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: fieldCategoryAnchorButton)
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(customView: searchButton),
            UIBarButtonItem(customView: filterButton)
        ]
    }
    
    // MARK: - Layout
    override func configureLayouts() {
        view.addSubview(rootFlexContainer)
        rootFlexContainer.flex.direction(.column).define { flex in
            flex.addItem(categoryView)
                .position(.absolute)
                .height(102)
            
            flex.addItem(collectionView)
                .position(.absolute)
            
            flex.addItem(placeholderView)
                .position(.absolute)
                .width(100%)
                .height(75%)
                .top(102)
            
            flex.addItem(createProjectButton)
                .position(.absolute)
                .right(15)
                .bottom(15)
                .width(106)
                .height(48)
        }
    }
    
    // MARK: - Binding
    override func bind() {
        let input = MainViewModel.Input(
            viewWillAppear: self.rx.viewWillAppear.asObservable(),
            didScroll: collectionView.rx.contentOffset.asObservable(),
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
        let dividerColor = categoryMargin == -102.0 ? BridgeColor.gray6 : nil
        
        navigationController?.navigationBar.standardAppearance.shadowColor = dividerColor
        navigationController?.navigationBar.scrollEdgeAppearance?.shadowColor = dividerColor
        
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
        placeholderView.configureHolderView(.emptyProject)
        placeholderView.projectCountLabel.isHidden = true
        placeholderView.isHidden = !projects.isEmpty
        configureDataSource()
        collectionView.collectionViewLayout = configureCompositionalLayoutForNew()
        applySectionSnapshot(to: .main, with: projects)
    }
    
    private func configureCompositionalLayoutForNew() -> UICollectionViewLayout {
        let config = CompositionalLayoutConfiguration(
            groupHeight: 160,
            sectionContentInsets: NSDirectionalEdgeInsets(top: 24, leading: 0, bottom: 80, trailing: 0),
            headerHeight: nil
        )
        
        return config.configureCompositionalLayout()
    }
}

// MARK: - 카테고리 -> 인기일 경우
extension MainViewController {
    private func updateCollectionViewForHot(with projects: [Project]) {
        placeholderView.configureHolderView(.emptyProject)
        placeholderView.projectCountLabel.isHidden = false
        placeholderView.isHidden = !projects.isEmpty
        configureDataSourceForHot()
        configureSupplementaryViewForHot(projects.count)
        collectionView.collectionViewLayout = configureCompositionalLayoutForHot()
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
            groupHeight: 110,
            sectionContentInsets: NSDirectionalEdgeInsets(top: 16.2, leading: 0, bottom: 0, trailing: 0),
            headerHeight: 38
        )
        
        let mainSectionConfig = CompositionalLayoutConfiguration(
            groupHeight: 160,
            sectionContentInsets: NSDirectionalEdgeInsets(top: 26.2, leading: 0, bottom: 80, trailing: 0),
            headerHeight: 42
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
        placeholderView.configureHolderView(.emptyProject)
        placeholderView.projectCountLabel.isHidden = false
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
            groupHeight: 160,
            sectionContentInsets: NSDirectionalEdgeInsets(top: 16.2, leading: 0, bottom: 80, trailing: 0),
            headerHeight: 38
        )
        
        return config.configureCompositionalLayout()
    }
}

// MARK: - 카테고리 -> 출시예정일 경우
extension MainViewController {
    private func updateCollectionViewForComingSoon(with projects: [Project]) {
        placeholderView.configureHolderView(.comingSoon)
        placeholderView.projectCountLabel.isHidden = true
        placeholderView.isHidden = false
        configureDataSource()
        collectionView.collectionViewLayout = configureCompositionalLayoutForNew()
        applySectionSnapshot(to: .main, with: projects)
    }
}
