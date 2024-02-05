//
//  FilteredProjectListViewController.swift
//  Bridge
//
//  Created by 엄지호 on 2/4/24.
//

import UIKit
import FlexLayout
import PinLayout
import RxCocoa
import RxSwift

final class FilteredProjectListViewController: BaseViewController {
    // MARK: - UI
    private lazy var searchButton = UIBarButtonItem(
        image: UIImage(named: "magnifyingglass")?
            .resize(to: CGSize(width: 24, height: 24))
            .withRenderingMode(.alwaysTemplate),
        style: .plain,
        target: self,
        action: nil
    )
    
    private lazy var filterOptionListCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: configureFilterOptionListCollectionViewLayout())
        collectionView.backgroundColor = BridgeColor.gray10
        collectionView.register(FilterOptionCell.self)
        
        return collectionView
    }()
    
    private lazy var projectListCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: configureProjectListCollectionViewLayout())
        collectionView.backgroundColor = BridgeColor.gray09
        collectionView.register(ProjectCell.self)
        collectionView.register(
            ProjectCountHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader
        )
        
        return collectionView
    }()
    
    // MARK: - Property
    private let viewModel: FilteredProjectListViewModel
    
    // Filter Option List
    private typealias FilterOptionListDataSource =
    UICollectionViewDiffableDataSource<FilteredProjectListViewModel.Section, String>
    private typealias FilterOptionListSectionSnapshot = NSDiffableDataSourceSectionSnapshot<String>
    
    private var filterOptionListDataSource: FilterOptionListDataSource?
    private let optionDeleteButtonTapped = PublishSubject<String>()
    
    // ProjectList
    private typealias ProjectListDataSource =
    UICollectionViewDiffableDataSource<FilteredProjectListViewModel.Section, ProjectPreview>
    private typealias ProjectListSectionSnapshot = NSDiffableDataSourceSectionSnapshot<ProjectPreview>
    private var projectListDataSource: ProjectListDataSource?
    
    // MARK: - Init
    init(viewModel: FilteredProjectListViewModel) {
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
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        configureDefaultNavigationBarAppearance()
        tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - Configuration
    override func configureAttributes() {
        navigationItem.rightBarButtonItem = searchButton
        configureFilterOptionListDataSource()
        configureProjectListDataSource()
    }
    
    // MARK: - Layout
    override func configureLayouts() {
        view.addSubview(filterOptionListCollectionView)
        view.addSubview(projectListCollectionView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        filterOptionListCollectionView.pin.top(view.pin.safeArea).left().right().height(86)
        projectListCollectionView.pin.below(of: filterOptionListCollectionView).left().bottom().right()
    }
    
    // MARK: - Binding
    override func bind() {
        let input = FilteredProjectListViewModel.Input(
            viewWillAppear: self.rx.viewWillAppear.asObservable(), 
            optionDeleteButtonTapped: optionDeleteButtonTapped
        )
        let output = viewModel.transform(input: input)
        
        output.fieldTechStack
            .drive(onNext: { [weak self] fieldTechStack in
                guard let self else { return }
                self.navigationItem.title = self.configureNavigationTitle(from: fieldTechStack.field)
                self.applyFilterOptionListSectionSnapshot(with: fieldTechStack.techStacks)
            })
            .disposed(by: disposeBag)
        
        output.projects
            .drive(onNext: { [weak self] projects in
                guard let self else { return }
                self.configureProjectListSupplementaryView(projectCount: projects.count)
                self.applyProjectListSectionSnapshot(with: projects)
            })
            .disposed(by: disposeBag)
    }
}

extension FilteredProjectListViewController {
    private func configureNavigationTitle(from field: String) -> String {
        switch field {
        case "iOS": return "iOS 개발자"
        case "안드로이드": return "안드로이드 개발자"
        case "프론트엔드": return "프론트엔드 개발자"
        case "백엔드": return "백엔드 개발자"
        case "UI/UX": return "UI/UX 디자이너"
        case "BI/BX": return "BI/BX 디자이너"
        case "영상/모션": return "영상/모션 디자이너"
        case "PM": return "기획자"
        default: return "Error"
        }
    }
}

// MARK: - 필터링 옵션에 대한 레이아웃 구성
extension FilteredProjectListViewController {
    private func configureFilterOptionListCollectionViewLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .estimated(120),
            heightDimension: .absolute(38)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .estimated(120),
            heightDimension: .fractionalHeight(1.0)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 12
        section.contentInsets = NSDirectionalEdgeInsets(top: 24, leading: 15, bottom: 24, trailing: 15)
        section.orthogonalScrollingBehavior = .continuous
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}

// MARK: - 필터링 옵션에 대한 데이터소스 구성
extension FilteredProjectListViewController {
    private func configureFilterOptionListDataSource() {
        filterOptionListDataSource = FilterOptionListDataSource(
            collectionView: filterOptionListCollectionView
        ) { [weak self] collectionView, indexPath, option in
            guard let cell = collectionView.dequeueReusableCell(FilterOptionCell.self, for: indexPath) else {
                return UICollectionViewCell()
            }
            
            guard let self else { return UICollectionViewCell() }
           
            // Cell 구성
            cell.configure(with: option)
            cell.deleteButtonTapped
                .bind(to: self.optionDeleteButtonTapped)
                .disposed(by: cell.disposeBag)
            
            return cell
        }
    }
    
    private func applyFilterOptionListSectionSnapshot(with options: [String]) {
        var snapshot = FilterOptionListSectionSnapshot()
        snapshot.append(options)
        filterOptionListDataSource?.apply(snapshot, to: .main, animatingDifferences: true)
    }
}

// MARK: - 프로젝트 리스트에 대한 레이아웃
extension FilteredProjectListViewController {
    private func configureProjectListCollectionViewLayout() -> UICollectionViewLayout {
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

// MARK: - 프로젝트 리스트에 대한 데이터소스 구성
extension FilteredProjectListViewController {
    private func configureProjectListDataSource() {
        projectListDataSource = ProjectListDataSource(
            collectionView: projectListCollectionView
        ) { collectionView, indexPath, project in
            guard let cell = collectionView.dequeueReusableCell(ProjectCell.self, for: indexPath) else {
                return UICollectionViewCell()
            }
            cell.configureCell(with: project)
            
            return cell
        }
    }
    
    private func configureProjectListSupplementaryView(projectCount: Int) {
        projectListDataSource?.supplementaryViewProvider = { collectionView, kind, indexPath in
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
    
    private func applyProjectListSectionSnapshot(with projectList: [ProjectPreview]) {
        var snapshot = ProjectListSectionSnapshot()
        snapshot.append(projectList)
        projectListDataSource?.apply(snapshot, to: .main, animatingDifferences: true)
    }
}
