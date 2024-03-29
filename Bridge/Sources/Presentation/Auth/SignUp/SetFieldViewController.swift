//
//  SetFieldViewController.swift
//  Bridge
//
//  Created by 정호윤 on 2023/09/12.
//

import UIKit
import PinLayout
import FlexLayout
import RxSwift

final class SetFieldViewController: BaseViewController {
    // MARK: - UI
    private let rootFlexContainer = UIView()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private let contentView = UIView()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.configureTextWithLineHeight(text: "당신의 관심 프로젝트는\n어떤 분야인가요?", lineHeight: 30)
        label.font = BridgeFont.headline1Long.font
        label.textColor = BridgeColor.gray01
        label.numberOfLines = 0
        return label
    }()
    
    private let tipMessageBox = BridgeTipMessageBox("관심분야 설정하고 맞춤 홈화면 받아보세요!")
    
    private let setFieldView = BridgeSetFieldView()
    
    private let completeButton = BridgeButton(
        title: "관심분야 설정하기",
        font: BridgeFont.button1.font,
        backgroundColor: BridgeColor.gray04
    )
    
    // MARK: - Property
    private let viewModel: SetFieldViewModel
    
    // MARK: - Init
    init(viewModel: SetFieldViewModel) {
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
        navigationItem.title = "관심분야"
        navigationItem.hidesBackButton = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false  // 밀어서 뒤로가기 제한
    }
    
    override func configureLayouts() {
        view.addSubview(rootFlexContainer)
        rootFlexContainer.addSubview(scrollView)
        rootFlexContainer.addSubview(completeButton)
        scrollView.addSubview(contentView)
        
        contentView.flex.paddingHorizontal(16).define { flex in
            flex.addItem(descriptionLabel).marginTop(32).marginBottom(16)
            flex.addItem(tipMessageBox).marginBottom(40)
            flex.addItem(setFieldView).marginBottom(35)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        rootFlexContainer.pin.all(view.pin.safeArea)
        completeButton.pin.horizontally(16).bottom(view.pin.safeArea + 24).height(52)
        scrollView.pin.top().horizontally().above(of: completeButton).marginBottom(20)
        
        contentView.pin.top().horizontally()
        contentView.flex.layout(mode: .adjustHeight)
        
        scrollView.contentSize = contentView.frame.size
    }
    
    // MARK: - Binding
    override func bind() {
        let input = SetFieldViewModel.Input(
            fieldTagButtonTapped: setFieldView.fieldTagButtonTapped,
            completeButtonTapped: completeButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        output.isCompleteButtonEnabled
            .drive(onNext: { [weak self] isCompleteButtonEnabled in
                self?.completeButton.isEnabled = isCompleteButtonEnabled
            })
            .disposed(by: disposeBag)
    }
}
