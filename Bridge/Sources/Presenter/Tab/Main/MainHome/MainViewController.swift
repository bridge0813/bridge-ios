//
//  MainViewController.swift
//  Bridge
//
//  Created by 엄지호 on 2023/08/28.
//

import UIKit
import RxCocoa
import RxSwift

final class MainViewController: UIViewController {
    // MARK: - Properties
    let viewModel: MainViewModel
    
    // MARK: - Initializer
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        let n = viewModel.transform(input: MainViewModel.Input(viewDidLoadTrigger: PublishRelay<Void>()))
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .green
    }
    
    // MARK: - Methods
}
