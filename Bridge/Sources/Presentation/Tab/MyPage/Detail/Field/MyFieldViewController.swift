//
//  MyFieldViewController.swift
//  Bridge
//
//  Created by 정호윤 on 12/14/23.
//

import UIKit

final class MyFieldViewController: BaseViewController {
    // MARK: - UI
    
    // MARK: - Property
    private let viewModel: MyFieldViewModel
    
    // MARK: - Init
    init(viewModel: MyFieldViewModel) {
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
        let input = MyFieldViewModel.Input()
        let output = viewModel.transform(input: input)
    }
}
