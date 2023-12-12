//
//  ApplicantListViewController.swift
//  Bridge
//
//  Created by 엄지호 on 12/12/23.
//

import UIKit
import FlexLayout
import PinLayout
import RxCocoa
import RxSwift

final class ApplicantListViewController: BaseViewController {
    // MARK: - UI
    private let rootFlexContainer = UIView()
   
    private let placeholderView: BridgePlaceholderView = {
        let view = BridgePlaceholderView()
        view.configurePlaceholderView(for: .emptyApplicantList)
        view.isHidden = true
        return view
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: configureLayout())
        collectionView.backgroundColor = BridgeColor.gray09
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(ApplicantCell.self)
        collectionView.register(
            ApplicantNumberHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader
        )
        
        return collectionView
    }()
    
    // MARK: - Property
    private let viewModel: ApplicantListViewModel
    
    private typealias DataSource = UICollectionViewDiffableDataSource<ApplicantListViewModel.Section, ApplicantProfile>
    private typealias SectionSnapshot = NSDiffableDataSourceSectionSnapshot<ApplicantProfile>
    
    private var dataSource: DataSource?
    
    private let startChatButtonTapped = PublishSubject<UserID>()
    private let acceptButtonTapped = PublishSubject<UserID>()
    private let rejectButtonTapped = PublishSubject<UserID>()
    
    // MARK: - Init
    init(viewModel: ApplicantListViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Configuration
    override func configureAttributes() {
        navigationItem.title = "지원자 목록"
    }
    
    // MARK: - Layout
    override func configureLayouts() {
        view.addSubview(rootFlexContainer)
        rootFlexContainer.flex.define { flex in
            flex.addItem(collectionView).grow(1).isIncludedInLayout(true)
            flex.addItem(placeholderView).grow(1).isIncludedInLayout(false)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        rootFlexContainer.pin.all(view.pin.safeArea)
        rootFlexContainer.flex.layout()
    }
    
    // MARK: - Binding
    override func bind() {
        let input = ApplicantListViewModel.Input(
            viewWillAppear: self.rx.viewWillAppear.asObservable()
        )
        let output = viewModel.transform(input: input)
        
        // test
        let testArray: [ApplicantProfile] = [
            ApplicantProfile(userID: 0, name: "엄지호", fields: ["iOS", "UIUX"], career: "취준생"),
            ApplicantProfile(userID: 1, name: "정호윤", fields: ["iOS", "UIUX"], career: "학생"),
            ApplicantProfile(userID: 2, name: "고경", fields: ["영상/모션", "UIUX"], career: "취준생"),
            ApplicantProfile(userID: 3, name: "김교연", fields: ["BIBX", "UIUX"], career: "취준생"),
            ApplicantProfile(userID: 4, name: "이지민", fields: ["백엔드", "PM"], career: "학생"),
            ApplicantProfile(userID: 5, name: "이규현", fields: ["프론트엔드", "백엔드"], career: "취준생")
        ]
        
        configureDataSource()
        configureSupplementaryView(with: testArray.count)
        applySectionSnapshot(with: testArray)

//        self.collectionView.flex.isIncludedInLayout(false).markDirty()
//        self.placeholderView.flex.isIncludedInLayout(true).markDirty()
//        self.placeholderView.isHidden = false
//        self.rootFlexContainer.flex.layout()
//
//
//        self.collectionView.flex.isIncludedInLayout(true).markDirty()
//        self.placeholderView.flex.isIncludedInLayout(false).markDirty()
//        self.placeholderView.isHidden = true
//        self.rootFlexContainer.flex.layout()
    }
}

// MARK: - CompositionalLayout
extension ApplicantListViewController {
    private func configureLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )

        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(150)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = .init(top: 0, leading: 16, bottom: 0, trailing: 16)
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(38)
        )
        
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        header.contentInsets = .init(top: 0, leading: 16, bottom: 0, trailing: 16)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 12
        section.boundarySupplementaryItems = [header]
        section.contentInsets = NSDirectionalEdgeInsets(top: 24, leading: 0, bottom: 30, trailing: 0)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}

// MARK: - Data source
extension ApplicantListViewController {
    private func configureDataSource() {
        dataSource = DataSource(
            collectionView: collectionView
        ) { [weak self] collectionView, indexPath, profile in
            guard let cell = collectionView.dequeueReusableCell(ApplicantCell.self, for: indexPath) else {
                return UICollectionViewCell()
            }
            
            guard let self else { return UICollectionViewCell() }
           
            cell.configureCell(with: profile)
            
            // 채팅하기 or 수락하기 or 거절하기
            cell.buttonGroupTapped
                .withUnretained(self)
                .subscribe(onNext: { owner, data in
                    let (title, userID) = data
                    
                    switch title {
                    case "채팅하기": owner.startChatButtonTapped.onNext(userID)
                    case "수락하기": owner.acceptButtonTapped.onNext(userID)
                    case "거절하기": owner.rejectButtonTapped.onNext(userID)
                    default: print("Error")
                    }
                })
                .disposed(by: cell.disposeBag)
            
            return cell
        }
    }
    
    private func configureSupplementaryView(with applicantNumber: Int) {
        dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard let headerView = collectionView.dequeueReusableSupplementaryView(
                ApplicantNumberHeaderView.self,
                ofKind: kind,
                for: indexPath
            ) else { return UICollectionReusableView() }
            
            headerView.configureLabel(with: applicantNumber)
            
            return headerView
        }
    }
    
    private func applySectionSnapshot(with applicantList: [ApplicantProfile]) {
        var snapshot = SectionSnapshot()
        snapshot.append(applicantList)
        dataSource?.apply(snapshot, to: .main, animatingDifferences: false)
    }
}
