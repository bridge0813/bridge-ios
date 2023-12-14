//
//  ProfileViewController.swift
//  Bridge
//
//  Created by 정호윤 on 12/14/23.
//

import UIKit

final class ProfileViewController: BaseViewController {
    // MARK: - UI
    
    // MARK: - Property
    private let viewModel: ProfileViewModel
    
    // MARK: - Init
    init(viewModel: ProfileViewModel) {
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
        let input = ProfileViewModel.Input()
        let output = viewModel.transform(input: input)
    }
}
