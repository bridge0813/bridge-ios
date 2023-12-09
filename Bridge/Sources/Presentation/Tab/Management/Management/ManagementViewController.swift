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
    
    private let applyTapButton: ManagementTapButton = {
        let button = ManagementTapButton("지원")
        button.isSelected = true
        button.configuration?.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        return button
    }()
    private let recruitmentTapButton: ManagementTapButton = {
        let button = ManagementTapButton("모집")
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
    
    private let filterMenuPopUpView = MenuPopUpView(titles: ("전체", "결과 대기", "완료"), isCheckmarked: true)
    
    // MARK: - Property
    private let viewModel: ManagementViewModel
    
    private typealias DataSource = UICollectionViewDiffableDataSource<ManagementViewModel.Section, ProjectPreview>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<ManagementViewModel.Section, ProjectPreview>
    private var dataSource: DataSource?
    
    private let goToDetailTapped = PublishSubject<Int>()
    private let goToApplyListTapped = PublishSubject<Int>()
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
            UIBarButtonItem(customView: applyTapButton),
            UIBarButtonItem(customView: recruitmentTapButton)
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
                applyTapButton.rx.tap.map { .apply },
                recruitmentTapButton.rx.tap.map { .recruitment }
            ),
            filterMenuTapped: filterMenuPopUpView.menuTapped
        )
        let output = viewModel.transform(input: input)
        
        output.projects
            .drive(onNext: { [weak self] projects in
                guard let self else { return }
                
                let currentTap = self.applyTapButton.isSelected
                
                configureDataSource()
                configureSupplementaryView(with: projects)
                applySnapshot(with: projects)
            })
            .disposed(by: disposeBag)
        
        // 탭 전환
        output.selectedTap
            .skip(1)
            .drive(onNext: { [weak self] tapType in
                guard let self else { return }
               
                switch tapType {
                case .apply: 
                    recruitmentTapButton.isSelected = false
                    applyTapButton.isSelected = true
                    
                case .recruitment:
                    applyTapButton.isSelected = false
                    recruitmentTapButton.isSelected = true
                }
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
        ) { collectionView, indexPath, project in
            guard let cell = collectionView.dequeueReusableCell(ManagementProjectCell.self, for: indexPath) else {
                return UICollectionViewCell()
            }
            // Cell 구성
            cell.configureCell(with: project, currentTap: .recruitment)
            
            // 지원자 목록 or 프로젝트 상세
            cell.buttonGroupTapped
                .withUnretained(self)
                .subscribe(onNext: { owner, data in
                    let (title, projectID) = data
                    
                    if let title, title == "프로젝트 상세" {
                        owner.goToDetailTapped.onNext(projectID)
                    } else {
                        owner.goToApplyListTapped.onNext(projectID)
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
                    owner.goToDetailTapped.onNext(projectID)
                })
                .disposed(by: cell.disposeBag)
            
            return cell
        }
    }
    
    private func configureSupplementaryView(with projects: [ProjectPreview]) {
        dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard let headerView = collectionView.dequeueReusableSupplementaryView(
                ManagementHeaderView.self,
                ofKind: kind,
                for: indexPath
            ) else { return UICollectionReusableView() }
            
            headerView.configureHeaderView(projects: projects, currentTap: .apply)
            headerView.filterButtonTapped
                .withUnretained(self)
                .subscribe(onNext: { owner, _ in
                    owner.filterMenuPopUpView.show()
                })
                .disposed(by: headerView.disposeBag)
            
            return headerView
        }
    }
    
    private func applySnapshot(with projects: [ProjectPreview]) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(projects)
        dataSource?.apply(snapshot)
    }
}
