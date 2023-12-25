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
    
    private let placeholderView = BridgePlaceholderView()
    
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
    
    private let filterProjectActionSheet = BridgeActionSheet(titles: ("전체", "결과 대기", "완료"), isCheckmarked: true)
    
    // MARK: - Property
    private let viewModel: ManagementViewModel
    
    private typealias DataSource = UICollectionViewDiffableDataSource<ManagementViewModel.Section, ProjectPreview>
    private typealias SectionSnapshot = NSDiffableDataSourceSectionSnapshot<ProjectPreview>
    
    private var dataSource: DataSource?
    
    private let goToDetailButtonTapped = PublishSubject<ProjectID>()
    private let goToApplicantListButtonTapped = PublishSubject<ProjectID>()
    private let deleteButtonTapped = PublishSubject<ProjectID>()
    private let cancelApplicationButtonTapped = PublishSubject<ProjectID>()

    // MARK: - Init
    init(viewModel: ManagementViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
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
            flex.addItem(placeholderView).position(.absolute).all(0)
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
            deleteButtonTapped: deleteButtonTapped, 
            cancelApplicationButtonTapped: cancelApplicationButtonTapped
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
                    resultProjects = projects.filter { $0.status == "현재 모집중" }
                    
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
        
        // 모집글 필터옵션 변경
        output.filterOption
            .drive(onNext: { [weak self] option in
                guard let self else { return }
                self.updateFilterButtonTitleInHeaderView(option)
            })
            .disposed(by: disposeBag)
        
        // 뷰 상태 전환
        output.viewState
            .drive { [weak self] viewState in
                guard let self else { return }
                self.handleViewState(viewState)
            }
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
            heightDimension: .absolute(150)
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
            
            // 프로젝트 삭제 or 지원 취소
            cell.deleteButtonTapped
                .withUnretained(self)
                .subscribe(onNext: { owner, projectID in
                    // 지원 탭에서 삭제 버튼이 클릭되었다면 -> 지원취소
                    // 모집 탭에서 삭제 버튼이 클릭되었다면 -> 모집글 삭제
                    if self.applyTabButton.isSelected {
                        owner.cancelApplicationButtonTapped.onNext(projectID)
                    } else {
                        owner.deleteButtonTapped.onNext(projectID)
                    }
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

// MARK: - View state handling
private extension ManagementViewController {
    /// 뷰의 상태에 따라 화면에 표시되는 컴포넌트를 설정하는 함수
    func handleViewState(_ viewState: ManagementViewModel.ViewState) {
        collectionView.isScrollEnabled = true
        collectionView.isHidden = true
        placeholderView.isHidden = false
        var placeholderTopMargin: CGFloat = 0  // 플레이스 홀더 뷰의 탑 마진(뷰의 상태에 따라 변경됨)
        
        switch viewState {
        case .general:
            configureNoShadowNavigationBarAppearance()
            collectionView.isHidden = false
            placeholderView.isHidden = true
            
        case .signInNeeded:
            configureDefaultNavigationBarAppearance()
            placeholderView.configurePlaceholderView(
                for: .needSignIn,
                configuration: BridgePlaceholderView.PlaceholderConfiguration(
                    title: "로그인 후 사용 가능해요!",
                    description: "프로젝트를 관리해 보세요."
                )
            )
            
        case .empty:
            configureNoShadowNavigationBarAppearance()
            collectionView.isScrollEnabled = false
            collectionView.isHidden = false
            
            placeholderView.configurePlaceholderView(
                // 지원탭 버튼이 선택되어 있으면, 지원한 모집글이 없다는 플레이스 홀더 보여주기.
                // 모집탭 버튼이 선택되어 있으면, 작성한 모집글이 없다는 플레이스 홀더 보여주기.
                for: applyTabButton.isSelected ? .emptyAppliedProject : .emptyMyProject
            )
            placeholderTopMargin = 150
            
        case .error:
            configureDefaultNavigationBarAppearance()
            placeholderView.configurePlaceholderView(for: .error)
        }
        
        placeholderView.flex.top(placeholderTopMargin)
        rootFlexContainer.flex.layout()
    }
}
