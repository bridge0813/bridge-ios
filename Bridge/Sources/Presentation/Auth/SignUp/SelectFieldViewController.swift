//
//  SelectFieldViewController.swift
//  Bridge
//
//  Created by 정호윤 on 2023/09/12.
//

import UIKit
import PinLayout
import FlexLayout
import RxCocoa
import RxSwift

final class SelectFieldViewController: BaseViewController {
    // MARK: - UI
    private let rootFlexViewContainer = UIView()
    private let completeButton: UIButton = {
        let button = UIButton()
        button.setTitle("완료", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    private let viewModel: SelectFieldViewModel
    
    init(viewModel: SelectFieldViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Configurations
    override func configureLayouts() {
        view.addSubview(rootFlexViewContainer)
        
        rootFlexViewContainer.flex
            .direction(.column)
            .justifyContent(.center)
            .alignItems(.center)
            .define { flex in
                flex.addItem(completeButton).size(100)
            }
    }
    
    override func viewDidLayoutSubviews() {
        rootFlexViewContainer.pin.all()
        rootFlexViewContainer.flex.layout()
    }
    
    override func bind() {
        let input = SelectFieldViewModel.Input(
            completeButtonTapped: completeButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(input: input)
    }
}
