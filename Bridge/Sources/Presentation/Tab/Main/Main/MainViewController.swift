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
    
    private let createProjectButton = BrideCreateProjectButton()
    
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
            flex.addItem().direction(.row).alignItems(.center).define { flex in
                flex.addItem(mainFieldCategoryAnchorButton).marginLeft(5)
                flex.addItem().grow(1)
                flex.addItem(filterButton).size(24).marginRight(15)
                flex.addItem(searchButton).size(24).marginRight(15)
            }
            
            flex.addItem(mainCategoryHeaderView).height(68).marginTop(15).marginHorizontal(5)
            
            flex.addItem(projectCollectionView).grow(1).marginTop(20)
            
            flex.addItem(createProjectButton)
                .position(.absolute)
                .right(15)
                .bottom(15)
                .width(106)
                .height(48)
        }
    }
    
    override func configureAttributes() {
        configureCellDataSource()
        configureHeaderDataSource()
        configureNavigationUI()
    }
    
    // MARK: - Bind
    override func bind() {
        let input = MainViewModel.Input(
            viewWillAppear: self.rx.viewWillAppear.asObservable(),
            didScroll: projectCollectionView.rx.contentOffset.asObservable(),
            filterButtonTapped: filterButton.rx.tap.asObservable(),
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
            
        mainCategoryHeaderView.categoryButtonTapped
            .withUnretained(self)
            .subscribe(onNext: { owner, type in
                owner.mainCategoryHeaderView.updateButtonState(type)
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

// MARK: - CreateProjectButtonAnimation
extension MainViewController {
    private func animateLayoutChange(to mode: MainViewModel.CreateButtonDisplayState) {
        UIView.animate(
            withDuration: 0.2,
            animations: { [weak self] in
                self?.updateButtonConfiguration(for: mode)
                self?.updateButtonLayout(for: mode)
            },
            completion: { [weak self] _ in
                self?.updateButtonTitle(for: mode)
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
    
    // MARK: - Button Configuration
    private func updateButtonConfiguration(for state: MainViewModel.CreateButtonDisplayState) {
        switch state {
        case .both:
            createProjectButton.titleLabel?.alpha = 1
            updateButtonTitle(for: state)
            
        case .only:
            createProjectButton.titleLabel?.alpha = 0
            createProjectButton.contentHorizontalAlignment = .left
        }
    }
    
    // MARK: - Button Title
    private func updateButtonTitle(for state: MainViewModel.CreateButtonDisplayState) {
        var updatedConfiguration = createProjectButton.configuration
        
        switch state {
        case .both:
            var titleContainer = AttributeContainer()
            titleContainer.font = BridgeFont.subtitle1.font
            titleContainer.foregroundColor = BridgeColor.gray10
            updatedConfiguration?.attributedTitle = AttributedString("글쓰기", attributes: titleContainer)
            
        case .only:
            updatedConfiguration?.attributedTitle = nil
        }
        
        createProjectButton.configuration = updatedConfiguration
    }
}
