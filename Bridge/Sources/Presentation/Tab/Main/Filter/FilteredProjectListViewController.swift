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
    private let rootFlexContainer = UIView()
    
    
    // MARK: - Property
    private let viewModel: FilteredProjectListViewModel
    
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
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        configureDefaultNavigationBarAppearance()
    }
    
    // MARK: - Configuration
    override func configureAttributes() {
        
    }
    
    // MARK: - Layout
    override func configureLayouts() {
        view.addSubview(rootFlexContainer)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        rootFlexContainer.pin.all(view.pin.safeArea)
        rootFlexContainer.flex.layout()
    }
    
    // MARK: - Binding
    override func bind() {
        let input = FilteredProjectListViewModel.Input(
            viewWillAppear: self.rx.viewWillAppear.asObservable()
        )
        let output = viewModel.transform(input: input)
    }
}
