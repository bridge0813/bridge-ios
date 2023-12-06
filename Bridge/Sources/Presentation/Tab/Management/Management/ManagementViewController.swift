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
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = BridgeColor.gray09
        collectionView.showsVerticalScrollIndicator = false

        return collectionView
    }()
    
    // MARK: - Property
    private let viewModel: ManagementViewModel
    
    private typealias DataSource = UITableViewDiffableDataSource<ManagementViewModel.Section, ProjectPreview>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<ManagementViewModel.Section, ProjectPreview>
    private var dataSource: DataSource?
    
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
        
    }
}
