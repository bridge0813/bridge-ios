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
            
        )
        let output = viewModel.transform(input: input)
    }
}
