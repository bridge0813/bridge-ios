//
//  MyPageViewController.swift
//  Bridge
//
//  Created by 정호윤 on 11/6/23.
//

import UIKit
import FlexLayout
import PinLayout
import RxCocoa
import RxSwift

final class MyPageViewController: BaseViewController {
    // MARK: - UI
    private let navigationTitleView = BridgeNavigationTitleView(title: "MY PAGE")
    
    private let bellButton: UIButton = {
        let button = UIButton()
        button.setImage(
            UIImage(named: "bell")?.resize(to: CGSize(width: 24, height: 24)),
            for: .normal
        )
        return button
    }()
    
    private let rootFlexContainer = UIView()
    
    private let profileHeaderView = ProfileHeaderView()
    
    private lazy var myPageTableView: UITableView = {
        let tableView = UITableView()
        profileHeaderView.flex.height(233)
        tableView.tableHeaderView = profileHeaderView
        tableView.register(MenuCell.self)
        tableView.rowHeight = 44
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        return tableView
    }()
    
    // MARK: - Property
    private let viewModel: MyPageViewModel
    
    // MARK: - Init
    init(viewModel: MyPageViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureTransparentNavigationBarAppearance()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        configureDefaultNavigationBarAppearance()
    }
    
    // MARK: - Configuration
    override func configureAttributes() {
        view.backgroundColor = BridgeColor.primary3
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: navigationTitleView)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: bellButton)
    }
    
    // MARK: - Layout
    override func configureLayouts() {
        view.addSubview(rootFlexContainer)
        
        rootFlexContainer.flex.define { flex in
            flex.addItem(myPageTableView).grow(1)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        rootFlexContainer.pin.all(view.pin.safeArea)
        rootFlexContainer.flex.layout()
    }
    
    // MARK: - Binding
    override func bind() {
        let input = MyPageViewModel.Input(
            viewWillAppear: self.rx.viewWillAppear.asObservable(),
            bellButtonTapped: bellButton.rx.tap.asObservable(),
            interestedFieldButtonTapped: profileHeaderView.interestedFieldButtonTapped,
            bookmarkedProjectButtonTapped: profileHeaderView.bookmarkedProjectButtonTapped,
            itemSelected: myPageTableView.rx.itemSelected.map { $0.row }
        )
        let output = viewModel.transform(input: input)

        output.menus
            .bind(to: myPageTableView.rx.items(
                cellIdentifier: MenuCell.reuseIdentifier,
                cellType: MenuCell.self
            )) { _, element, cell in
                cell.configure(with: element)
            }
            .disposed(by: disposeBag)
    }
}
