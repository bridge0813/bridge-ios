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
    
    private let tipMessageBox = TipMessageBox("관심 분야 설정하고 맞춤 홈화면 확인하세요!")
    private let warningMessageBox = WarningMessageBox("이 프로젝트는 학생, 취준생의 지원이 제한되어 있습니다.")
    
    private let completeButton: UIButton = {
        let button = UIButton(configuration: .filled())
        button.configuration?.baseBackgroundColor = BridgeColor.primary1
        button.setTitle("완료", for: .normal)
        button.setTitleColor(.white, for: .normal)
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
        
        rootFlexViewContainer.flex.direction(.column).justifyContent(.center).alignItems(.center).define { flex in
            flex.addItem(tipMessageBox)
            flex.addItem().size(40)
            flex.addItem(warningMessageBox)
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
        let input = SelectFieldViewModel.Input(
            completeButtonTapped: completeButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(input: input)
    }
}
