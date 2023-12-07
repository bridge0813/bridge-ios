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
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(ManagementProjectCell.self)
        collectionView.register(
            ManagementHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader
        )
        
        return collectionView
    }()
    
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
            viewWillAppear: self.rx.viewWillAppear.asObservable()
        )
        let output = viewModel.transform(input: input)
        
        let testArray = [
            ProjectPreview(projectID: 0, title: "실제 상업용 여행사 웹사이트 개발할 개발자 구합니다", description: "기획부터 앱 출시깢 ㅣ함께하실 팀원을 모집중입니다이이이", dDays: 0, deadline: "2023.08.20", totalRecruitNumber: 0, rank: 0, deadlineRank: 0, isBookmarked: false),
            ProjectPreview(projectID: 1, title: "팀원 구함", description: "기획부터 앱 출시깢 ㅣ함께하실 팀원을 모집중입니다이이이", dDays: 0, deadline: "2023.08.20", totalRecruitNumber: 0, rank: 0, deadlineRank: 0, isBookmarked: false),
            ProjectPreview(projectID: 2, title: "아아아아아아아이이이이이이이잉오오오오오오에에에에에에에으스슷스ㅡㅅ스구구구구해해해해요요용", description: "구함", dDays: 0, deadline: "2023.12.31", totalRecruitNumber: 0, rank: 0, deadlineRank: 0, isBookmarked: false),
            ProjectPreview(projectID: 3, title: "구함", description: "기획부터 앱 출시깢 ㅣ함께하실 팀원을 모집중입니다이이이이이아아아앙요요요요", dDays: 0, deadline: "2023.08.20", totalRecruitNumber: 0, rank: 0, deadlineRank: 0, isBookmarked: false),
            ProjectPreview(projectID: 4, title: "티티티팀원", description: "기획부터 앱 출시깢 ㅣ함께하실 팀원을 모집중입니다이이이아아아아앙용우웅", dDays: 0, deadline: "2023.08.20", totalRecruitNumber: 0, rank: 0, deadlineRank: 0, isBookmarked: false),
            ProjectPreview(projectID: 5, title: "백겡느드 구해요", description: "기획부터 앱 출시깢 ㅣ함께하실 팀원을 모집중입니다이이이이아아아어요쵼먀야ㅕㅇ", dDays: 0, deadline: "2023.08.20", totalRecruitNumber: 0, rank: 0, deadlineRank: 0, isBookmarked: false)
        ]

        configureDataSource()
        configureSupplementaryView(with: testArray)
        applySnapshot(with: testArray)
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
                    // 팝업뷰 보여주기.
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
