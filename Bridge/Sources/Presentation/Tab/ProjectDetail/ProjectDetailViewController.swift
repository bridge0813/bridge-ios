//
//  ProjectDetailViewController.swift
//  Bridge
//
//  Created by 엄지호 on 2023/11/10.
//

import UIKit
import FlexLayout
import PinLayout
import RxCocoa
import RxSwift

/// 모집글 상세뷰
final class ProjectDetailViewController: BaseViewController {
    // MARK: - UI
    private let rootFlexContainer = UIView()
    
    private lazy var menuButton = UIBarButtonItem(
        image: UIImage(named: "kebab")?
            .resize(to: CGSize(width: 24, height: 24))
            .withRenderingMode(.alwaysTemplate)
            .withAlignmentRectInsets(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -8)),
        style: .plain,
        target: self,
        action: nil
    )
    
    /// 프로젝트 관리 메뉴
    private let projectManagementActionSheet = BridgeActionSheet(
        titles: ("수정하기", "마감하기", "삭제하기"),
        isCheckmarked: false
    )
    
    private let dividerView: UIView = {
        let divider = UIView()
        divider.backgroundColor = BridgeColor.gray06
        divider.isHidden = true
        
        return divider
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(RecruitFieldCell.self)
        collectionView.register(
            ProjectDetailHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader
        )
        
        return collectionView
    }()
    
    private let menuBar = ProjectDetailMenuBar()
    
    // MARK: - Property
    private let viewModel: ProjectDetailViewModel
    
    private typealias DataSource = UICollectionViewDiffableDataSource<ProjectDetailViewModel.Section, MemberRequirement>
    private typealias SectionSnapshot = NSDiffableDataSourceSectionSnapshot<MemberRequirement>
    private var dataSource: DataSource?
    
    private var goToDetailButtonTapped = PublishRelay<Void>()
    
    // MARK: - Init
    init(viewModel: ProjectDetailViewModel) {
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
        navigationItem.title = "프로젝트 상세"
    }
    
    /// 컬렉션 뷰의 레이아웃 및 데이터소스를 설정
    private func configureCollectionView(with data: Project) {
        collectionView.collectionViewLayout = configureLayout(with: data.isMyProject)
        configureDataSource()
        configureSupplementaryView(with: data)
        applySectionSnapshot(with: data.memberRequirements)
    }
    
    /// MenuBar의 컨텐츠 설정 및 해당 모집글이 자신의 글인지 여부에 따라 MenuBar의 유무를 결정
    private func configureMenuBar(with data: Project) {
        menuBar.isBookmarked = data.isBookmarked
        menuBar.flex.display(data.isMyProject ? .none : .flex)
        menuBar.isHidden = data.isMyProject
        rootFlexContainer.flex.layout()
    }
    
    // MARK: - Layout
    override func configureLayouts() {
        view.addSubview(rootFlexContainer)
        rootFlexContainer.flex.define { flex in
            flex.addItem(dividerView).height(1)
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
        let input = ProjectDetailViewModel.Input(
            viewWillAppear: self.rx.viewWillAppear.asObservable(),
            goToDetailButtonTapped: goToDetailButtonTapped.asObservable(),
            projectManagementActionTapped: projectManagementActionSheet.actionButtonTapped,
            applyButtonTapped: menuBar.applyButtonTapped,
            bookmarkButtonTapped: menuBar.bookmarkButtonTapped,
            viewDidDisappear: self.rx.viewDidDisappear.asObservable()
        )
        let output = viewModel.transform(input: input)
        
        output.project
            .skip(1)
            .drive(onNext: { [weak self] project in
                guard let self else { return }

                self.navigationItem.rightBarButtonItem = project.isMyProject ? menuButton : nil
                self.configureMenuBar(with: project)
                self.configureCollectionView(with: project)
            })
            .disposed(by: disposeBag)
        
        // 구분선 등장
        collectionView.rx.contentOffset
            .map { $0.y > 0 }
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe(onNext: { owner, shouldHidden in
                owner.dividerView.isHidden = !shouldHidden
            })
            .disposed(by: disposeBag)
        
        // 메뉴 팝업 뷰 보여주기
        menuButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.projectManagementActionSheet.show()
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - CompositionalLayout
extension ProjectDetailViewController {
    private func configureLayout(with isMyProject: Bool) -> UICollectionViewLayout {
        let bottomInset: CGFloat = isMyProject ? 59 : 20  // 현재 모집글이 내 글인지 여부에 따라 bottomInset을 조절해줌.
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )

        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(190),
            heightDimension: .absolute(127)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(640)
        )
        
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        header.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: -16, bottom: 0, trailing: -16)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        section.boundarySupplementaryItems = [header]
        section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 16, bottom: bottomInset, trailing: 16)
        section.orthogonalScrollingBehavior = .continuous
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}

// MARK: - Data source
extension ProjectDetailViewController {
    private func configureDataSource() {
        dataSource = DataSource(
            collectionView: collectionView
        ) { collectionView, indexPath, requirement in
            guard let cell = collectionView.dequeueReusableCell(RecruitFieldCell.self, for: indexPath) else {
                return UICollectionViewCell()
            }
            cell.configureCell(with: requirement)
            
            return cell
        }
    }
    
    private func configureSupplementaryView(with project: Project) {
        dataSource?.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            guard let headerView = collectionView.dequeueReusableSupplementaryView(
                ProjectDetailHeaderView.self,
                ofKind: kind,
                for: indexPath
            ) else { return UICollectionReusableView() }
            
            guard let self else { return UICollectionReusableView() }
            
            headerView.configureContents(with: project)
            headerView.goToDetailButtonTapped
                .bind(to: self.goToDetailButtonTapped)
                .disposed(by: headerView.disposeBag)
            
            return headerView
        }
    }
    
    private func applySectionSnapshot(with requirements: [MemberRequirement]) {
        var snapshot = SectionSnapshot()
        snapshot.append(requirements)
        dataSource?.apply(snapshot, to: .main)
    }
}
