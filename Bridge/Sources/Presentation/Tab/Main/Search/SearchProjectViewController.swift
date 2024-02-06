//
//  SearchProjectViewController.swift
//  Bridge
//
//  Created by 엄지호 on 2/5/24.
//

import UIKit
import FlexLayout
import PinLayout
import RxCocoa
import RxSwift

final class SearchProjectViewController: BaseViewController {
    // MARK: - UI
    private let rootFlexContainer: UIView = {
        let view = UIView()
        view.backgroundColor = BridgeColor.gray09
        return view
    }()
    
    private let searchContainer: UIView = {
        let view = UIView()
        view.flex.height(88)
        view.backgroundColor = BridgeColor.gray10
        return view
    }()
    private let searchBar = BridgeSearchBar()
    
    private let cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("취소", for: .normal)
        button.setTitleColor(BridgeColor.secondary1, for: .normal)
        button.titleLabel?.font = BridgeFont.body2.font
        return button
    }()
    
    private let recentSearchesView = RecentSearchesView()
    
    // MARK: - Property
    private let viewModel: SearchProjectViewModel
    
    // MARK: - Init
    init(viewModel: SearchProjectViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
        tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - Configuration
    override func configureAttributes() {
        
    }
    
    // MARK: - Layout
    override func configureLayouts() {
        view.addSubview(rootFlexContainer)
        
        rootFlexContainer.flex.define { flex in
            flex.addItem(searchContainer).direction(.row).alignItems(.center).padding(22, 15, 22, 15).define { flex in
                flex.addItem(searchBar).grow(1).height(44)
                flex.addItem(cancelButton).marginLeft(16)
            }
            
            flex.addItem(recentSearchesView).grow(1).marginTop(4)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        rootFlexContainer.pin.all(view.pin.safeArea)
        rootFlexContainer.flex.layout()
    }
    
    // MARK: - Binding
    override func bind() {
        let input = SearchProjectViewModel.Input(
            textFieldEditingDidBegin: searchBar.editingDidBegin,
            searchButtonTapped: searchBar.searchButtonTapped,
            cancelButtonTapped: cancelButton.rx.tap
        )
        let output = viewModel.transform(input: input)
    }
}
