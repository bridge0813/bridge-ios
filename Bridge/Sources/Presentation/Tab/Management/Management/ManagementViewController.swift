//
//  ManagementViewController.swift
//  Bridge
//
//  Created by 엄지호 on 12/6/23.
//

import UIKit
import FlexLayout
import PinLayout
import RxCocoa
import RxSwift

final class ManagementViewController: BaseViewController {
    // MARK: - UI
    private let rootFlexContainer = UIView()
    
    private let applyTabButton: ManagementTabButton = {
        let button = ManagementTabButton("지원")
        button.isSelected = true
        button.configuration?.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        return button
    }()
    private let recruitmentTabButton: ManagementTabButton = {
        let button = ManagementTabButton("모집")
        button.configuration?.contentInsets = .init(top: 0, leading: 8, bottom: 0, trailing: 0)
        return button
        
    }()
    
    private let placeholderView: BridgePlaceholderView = {
        let view = BridgePlaceholderView()
        view.isHidden = true
        
        return view
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: configureLayout())
        collectionView.backgroundColor = BridgeColor.gray09
        collectionView.bounces = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(ManagementProjectCell.self)
        collectionView.register(
            ManagementHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader
        )
        
        return collectionView
    }()
    private lazy var headerView: UICollectionReusableView = {
        let view = self.collectionView.supplementaryView(
        forElementKind: UICollectionView.elementKindSectionHeader,
        at: IndexPath(item: 0, section: 0)) as? ManagementHeaderView
        
        return view ?? UICollectionReusableView()
    }()
    private let filterProjectActionSheet = BridgeActionSheet(titles: ("전체", "결과 대기", "완료"), isCheckmarked: true)
    
    // MARK: - Property
    private let viewModel: ManagementViewModel
    
    private typealias DataSource = UICollectionViewDiffableDataSource<ManagementViewModel.Section, ProjectPreview>
    private typealias SectionSnapshot = NSDiffableDataSourceSectionSnapshot<ProjectPreview>
    
    private var dataSource: DataSource?
    
    private let goToDetailButtonTapped = PublishSubject<Int>()
    private let goToApplicantListButtonTapped = PublishSubject<Int>()
    private let deleteButtonTapped = PublishSubject<Int>()

    // MARK: - Init
    init(viewModel: ManagementViewModel) {
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
        navigationItem.leftBarButtonItems = [
            UIBarButtonItem(customView: applyTabButton),
            UIBarButtonItem(customView: recruitmentTabButton)
        ]
    }
    
    // MARK: - Layout
    override func configureLayouts() {
        view.addSubview(rootFlexContainer)
        rootFlexContainer.flex.define { flex in
            flex.addItem(collectionView).grow(1)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        rootFlexContainer.pin.all(view.pin.safeArea)
        rootFlexContainer.flex.layout()
    }
    
    // MARK: - Binding
    override func bind() {
        let input = ManagementViewModel.Input(
            viewWillAppear: self.rx.viewWillAppear.asObservable(), 
            managementTabButtonTapped: Observable.merge(
                applyTabButton.rx.tap.map { .apply },
                recruitmentTabButton.rx.tap.map { .recruitment }
            ),
            filterActionTapped: filterProjectActionSheet.actionButtonTapped,
            goToDetailButtonTapped: goToDetailButtonTapped,
            goToApplicantListButtonTapped: goToApplicantListButtonTapped,
            deleteButtonTapped: deleteButtonTapped
        )
        let output = viewModel.transform(input: input)
        
        output.projects
            .drive(onNext: { [weak self] projects in
                guard let self else { return }
                
                var resultProjects: [ProjectPreview]
            
                switch self.viewModel.selectedFilterOption {
                case .all:
                    resultProjects = projects
                    
                case .pendingResult:
                    resultProjects = projects.filter { $0.status == "결과 대기중" }
                    
                case .onGoing:
                    resultProjects = projects.filter { $0.status == "현재 진행중" }
                    
                case .complete:
                    resultProjects = projects.filter {
                        $0.status == "모집완료" || $0.status == "수락" || $0.status == "거절"
                    }
                }
                
                self.configureDataSource()
                self.configureSupplementaryView(with: projects)
                self.applySectionSnapshot(with: resultProjects)
            })
            .disposed(by: disposeBag)
        
        // 탭 전환
        output.selectedTab
            .skip(1)
            .drive(onNext: { [weak self] tabType in
                guard let self else { return }
               
                switch tabType {
                case .apply: 
                    recruitmentTabButton.isSelected = false
                    applyTabButton.isSelected = true
                    self.filterProjectActionSheet.titles = ("전체", "결과 대기", "완료")  // 필터링 메뉴 변경
                    
                case .recruitment:
                    applyTabButton.isSelected = false
                    recruitmentTabButton.isSelected = true
                    self.filterProjectActionSheet.titles = ("전체", "현재 진행", "완료")
                }
                
                // 탭 전환 시 "전체"로 초기화
                self.updateFilterButtonTitleInHeaderView("전체")
            })
            .disposed(by: disposeBag)
        
        output.filterOption
            .drive(onNext: { [weak self] option in
                guard let self else { return }
                self.updateFilterButtonTitleInHeaderView(option)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - CompositionalLayout
extension ManagementViewController {
    private func configureLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )

        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(256)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = .init(top: 0, leading: 16, bottom: 0, trailing: 16)
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(150)
        )
        
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 12
        section.boundarySupplementaryItems = [header]
        section.contentInsets = NSDirectionalEdgeInsets(top: 24, leading: 0, bottom: 30, trailing: 0)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}

// MARK: - Data source
extension ManagementViewController {
    private func configureDataSource() {
        dataSource = DataSource(
            collectionView: collectionView
        ) { [weak self] collectionView, indexPath, project in
            guard let cell = collectionView.dequeueReusableCell(ManagementProjectCell.self, for: indexPath) else {
                return UICollectionViewCell()
            }
            
            guard let self else { return UICollectionViewCell() }
           
            // Cell 구성
            cell.configureCell(with: project, selectedTab: self.applyTabButton.isSelected ? .apply : .recruitment)
            
            // 지원자 목록 or 프로젝트 상세
            cell.buttonGroupTapped
                .withUnretained(self)
                .subscribe(onNext: { owner, data in
                    let (title, projectID) = data
                    
                    if title == "프로젝트 상세" {
                        owner.goToDetailButtonTapped.onNext(projectID)
                    } else {
                        owner.goToApplicantListButtonTapped.onNext(projectID)
                    }
                })
                .disposed(by: cell.disposeBag)
            
            // 프로젝트 삭제
            cell.deleteButtonTapped
                .withUnretained(self)
                .subscribe(onNext: { owner, projectID in
                    owner.deleteButtonTapped.onNext(projectID)
                })
                .disposed(by: cell.disposeBag)
            
            // 프로젝트 상세
            cell.detailButtonTapped
                .withUnretained(self)
                .subscribe(onNext: { owner, projectID in
                    owner.goToDetailButtonTapped.onNext(projectID)
                })
                .disposed(by: cell.disposeBag)
            
            return cell
        }
    }
    
    private func configureSupplementaryView(with projects: [ProjectPreview]) {
        dataSource?.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            guard let headerView = collectionView.dequeueReusableSupplementaryView(
                ManagementHeaderView.self,
                ofKind: kind,
                for: indexPath
            ) else { return UICollectionReusableView() }
            
            guard let self else { return UICollectionViewCell() }
           
            headerView.configureHeaderView(
                projects: projects,
                selectedTab: self.applyTabButton.isSelected ? .apply : .recruitment
            )
            
            headerView.filterButtonTapped
                .withUnretained(self)
                .subscribe(onNext: { owner, _ in
                    owner.filterProjectActionSheet.show()
                })
                .disposed(by: headerView.disposeBag)
            
            return headerView
        }
    }
    
    private func applySectionSnapshot(with projects: [ProjectPreview]) {
        var snapshot = SectionSnapshot()
        snapshot.append(projects)
        dataSource?.apply(snapshot, to: .main, animatingDifferences: false)
    }
}

// MARK: - Methods
extension ManagementViewController {
    private func updateFilterButtonTitleInHeaderView(_ title: String) {
        if let headerView = collectionView.supplementaryView(
            forElementKind: UICollectionView.elementKindSectionHeader,
            at: IndexPath(item: 0, section: 0)
        ) as? ManagementHeaderView {
            headerView.filterButtonTitle = title
        }
    }
}
