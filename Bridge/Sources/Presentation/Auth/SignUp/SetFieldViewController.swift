//
//  SetFieldViewController.swift
//  Bridge
//
//  Created by 정호윤 on 2023/09/12.
//

import UIKit
import PinLayout
import FlexLayout
import RxCocoa
import RxSwift

final class SetFieldViewController: BaseViewController {
    // MARK: - UI
    private let rootFlexViewContainer = UIView()
    
    private let tipMessageBox = TipMessageBox("관심분야 설정하고 맞춤 홈화면 받아보세요!")
    private let completeButton = NextButton()
    
    private let viewModel: SetFieldViewModel
    
    init(viewModel: SetFieldViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Configurations
    override func configureAttributes() {
        navigationItem.title = "관심분야"
        navigationItem.hidesBackButton = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false  // 밀어서 뒤로가기 제한
    }
    
    override func configureLayouts() {
        view.addSubview(rootFlexViewContainer)
        
        rootFlexViewContainer.flex.direction(.column).justifyContent(.center).alignItems(.center).define { flex in
            flex.addItem(tipMessageBox)
            flex.addItem().size(40)
            flex.addItem(completeButton).width(343).height(52)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        rootFlexViewContainer.pin.all()
        rootFlexViewContainer.flex.layout()
    }
    
    override func bind() {
        let input = SetFieldViewModel.Input(
            completeButtonTapped: completeButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(input: input)
    }
}
