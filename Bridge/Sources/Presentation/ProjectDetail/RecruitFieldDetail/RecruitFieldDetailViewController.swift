//
//  RecruitFieldDetailViewController.swift
//  Bridge
//
//  Created by 엄지호 on 2023/11/12.
//

import UIKit
import FlexLayout
import PinLayout
import RxCocoa
import RxSwift

/// 모집중인 분야의 상세한 내용이 담긴 컨트롤러
final class RecruitFieldDetailViewController: BaseViewController {
    // MARK: - UI
    private let rootFlexContainer: UIView = {
        let view = UIView()
        view.backgroundColor = BridgeColor.gray09
        
        return view
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = BridgeColor.gray09
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(RecruitFieldDetailCell.self)
        collectionView.register(
            TotalRecruitNumberHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader
        )
        
        return collectionView
    }()
    
    private let menuBar = ProjectDetailMenuBar()
    
    // MARK: - Property
    private typealias DataSource = UICollectionViewDiffableDataSource<RecruitFieldDetailViewModel.Section, MemberRequirement>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<RecruitFieldDetailViewModel.Section, MemberRequirement>
    private var dataSource: DataSource?
    
    private let viewModel: RecruitFieldDetailViewModel
    
    // MARK: - Init
    init(viewModel: RecruitFieldDetailViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNoShadowNavigationBarAppearance(with: BridgeColor.gray09)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        configureDefaultNavigationBarAppearance()
        tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - Configuration
    override func configureAttributes() {
        navigationItem.title = "모집중인 분야"
    }
    
    // MARK: - Layout
    override func configureLayouts() {
        view.addSubview(rootFlexContainer)
        
        rootFlexContainer.flex.define { flex in
            flex.addItem(collectionView).grow(1)
            flex.addItem(menuBar)
        }
    }
    
    override func viewDidLayoutSubviews() {
        rootFlexContainer.pin.top(view.pin.safeArea.top).left().bottom().right()
        rootFlexContainer.flex.layout()
    }
    
    // MARK: - Binding
    override func bind() {
        let input = RecruitFieldDetailViewModel.Input(
        )
        let output = viewModel.transform(input: input)
        
        output.projectDetail
            .drive(onNext: { [weak self] projectDetail in
                guard let self else { return }
                
                self.menuBar.configureContents(with: projectDetail)
                self.menuBar.flex.isIncludedInLayout(!projectDetail.isMyProject).markDirty()
                self.menuBar.isHidden = projectDetail.isMyProject
                
                self.collectionView.collectionViewLayout = configureLayout(with: projectDetail.isMyProject)
                self.configureDataSource()
                self.configureSupplementaryView(with: projectDetail.totalRecruitNumber)
                self.applySnapshot(with: projectDetail.memberRequirements)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - CompositionalLayout
extension RecruitFieldDetailViewController {
    private func configureLayout(with isMyProject: Bool) -> UICollectionViewLayout {
        let bottomInset: CGFloat = isMyProject ? 54 : 20
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(330)
        )

        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(330)
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
        section.boundarySupplementaryItems = [header]
        section.interGroupSpacing = 12
        section.contentInsets = NSDirectionalEdgeInsets(top: 24, leading: 16, bottom: bottomInset, trailing: 16)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}

// MARK: - Data source
extension RecruitFieldDetailViewController {
    private func configureDataSource() {
        dataSource = DataSource(
            collectionView: collectionView
        ) { collectionView, indexPath, requirement in
            guard let cell = collectionView.dequeueReusableCell(RecruitFieldDetailCell.self, for: indexPath) else {
                return UICollectionViewCell()
            }
            
            cell.configureCell(with: requirement)
            return cell
        }
    }
    
    private func configureSupplementaryView(with totalNumber: Int) {
        dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard let headerView = collectionView.dequeueReusableSupplementaryView(
                TotalRecruitNumberHeaderView.self,
                ofKind: kind,
                for: indexPath
            ) else { return UICollectionReusableView() }
            
            headerView.configureLabel(with: totalNumber)
            
            return headerView
        }
    }
    
    private func applySnapshot(with requirements: [MemberRequirement]) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(requirements)
        dataSource?.apply(snapshot)
    }
}
