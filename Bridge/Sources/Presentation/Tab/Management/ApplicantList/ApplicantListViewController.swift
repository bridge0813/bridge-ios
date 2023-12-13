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
            flex.addItem(collectionView).grow(1).display(.flex)
            flex.addItem(placeholderView).grow(1).display(.none)
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
            viewWillAppear: self.rx.viewWillAppear.asObservable(),
            startChatButtonTapped: startChatButtonTapped,
            acceptButtonTapped: acceptButtonTapped,
            rejectButtonTapped: rejectButtonTapped
        )
        let output = viewModel.transform(input: input)
        
        // 가져온 모집글에 맞게 DataSource 적용 및 UI 업데이트
        output.applicantList
            .drive(onNext: { [weak self] applicantList in
                guard let self else { return }
                
                // 빈 데이터일 경우 플레이스홀더 보여주기
                self.collectionView.flex.display(applicantList.isEmpty ? .none : .flex)
                self.placeholderView.flex.display(applicantList.isEmpty ? .flex : .none)
                self.placeholderView.isHidden = !applicantList.isEmpty
                self.rootFlexContainer.flex.layout()
                
                // CollectionView Configure
                self.configureDataSource()
                self.configureSupplementaryView(with: applicantList.count)
                self.applySectionSnapshot(with: applicantList)
            })
            .disposed(by: disposeBag)
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
