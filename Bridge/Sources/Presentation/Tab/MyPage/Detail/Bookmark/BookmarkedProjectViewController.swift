//
//  BookmarkedProjectViewController.swift
//  Bridge
//
//  Created by 정호윤 on 12/14/23.
//

import UIKit

final class BookmarkedProjectViewController: BaseViewController {
    // MARK: - UI
    
    // MARK: - Property
    private let viewModel: BookmarkedProjectViewModel
    
    // MARK: - Init
    init(viewModel: BookmarkedProjectViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Configuration
    override func configureAttributes() {
        navigationItem.title = "관심공고"
    }
    
    // MARK: - Layout
    override func configureLayouts() {
        
    }
    
    // MARK: - Binding
    override func bind() {
        let input = BookmarkedProjectViewModel.Input()
        let output = viewModel.transform(input: input)
    }
}
