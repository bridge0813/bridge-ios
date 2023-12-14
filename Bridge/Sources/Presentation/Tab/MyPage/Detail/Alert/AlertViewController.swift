//
//  AlertViewController.swift
//  Bridge
//
//  Created by 정호윤 on 12/14/23.
//

import UIKit

final class AlertViewController: BaseViewController {
    // MARK: - UI
    
    // MARK: - Property
    private let viewModel: AlertViewModel
    
    // MARK: - Init
    init(viewModel: AlertViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Layout
    override func configureLayouts() {
        
    }
    
    // MARK: - Binding
    override func bind() {
        let input = AlertViewModel.Input()
        let output = viewModel.transform(input: input)
    }
}
