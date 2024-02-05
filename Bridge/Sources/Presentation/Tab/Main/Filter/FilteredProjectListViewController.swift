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
    
    private lazy var filterOptionCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: configureLayout())
        collectionView.backgroundColor = BridgeColor.gray10
        collectionView.register(FilterOptionCell.self)
        
        return collectionView
    }()
    
    // MARK: - Property
    private let viewModel: FilteredProjectListViewModel
    
    private typealias FilterOptionDataSource = UICollectionViewDiffableDataSource<FilteredProjectListViewModel.FilterOptionSection, String>
    private typealias FilterOptionSectionSnapshot = NSDiffableDataSourceSectionSnapshot<String>
    
    private var filterOptionDataSource: FilterOptionDataSource?
    private let optionDeleteButtonTapped = PublishSubject<String>()
    
    
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
        configureFilterOptionDataSource()
    }
    
    // MARK: - Layout
    override func configureLayouts() {
        view.addSubview(filterOptionCollectionView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        filterOptionCollectionView.pin.top(view.pin.safeArea).left().right().height(86)
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
                self.applyFilterOptionSectionSnapshot(with: fieldTechStack.techStacks)
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

// MARK: - 필터링 옵션 컬렉션뷰에 대한 레이아웃 구성
extension FilteredProjectListViewController {
    private func configureLayout() -> UICollectionViewLayout {
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

// MARK: - 필터링 옵션 컬렉션뷰에 대한 데이터소스 구성
extension FilteredProjectListViewController {
    private func configureFilterOptionDataSource() {
        filterOptionDataSource = FilterOptionDataSource(
            collectionView: filterOptionCollectionView
        ) { [weak self] collectionView, indexPath, option in
            guard let cell = collectionView.dequeueReusableCell(FilterOptionCell.self, for: indexPath) else {
                return UICollectionViewCell()
            }
            
            guard let self else { return UICollectionViewCell() }
           
            // Cell 구성
            cell.configure(with: option)
            cell.deleteButtonTapped
                .bind(to: optionDeleteButtonTapped)
                .disposed(by: cell.disposeBag)
            
            return cell
        }
    }
    
    private func applyFilterOptionSectionSnapshot(with options: [String]) {
        var snapshot = FilterOptionSectionSnapshot()
        snapshot.append(options)
        filterOptionDataSource?.apply(snapshot, to: .main, animatingDifferences: true)
    }
}
