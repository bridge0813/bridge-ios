//
//  ProjectOverviewInputViewController.swift
//  Bridge
//
//  Created by 엄지호 on 2023/09/11.
//

import UIKit
import FlexLayout
import PinLayout
import RxCocoa
import RxSwift

final class ProjectDescriptionInputViewController: BaseViewController {
    // MARK: - UI
    private let rootFlexContainer = UIView()
    
    private let progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.progress = 1
        progressView.progressTintColor = BridgeColor.primary1
        progressView.backgroundColor = BridgeColor.gray7
        
        return progressView
    }()
    
    private let contentContainer = UIView()  // 키보드에 반응하여 컨텐츠들을 위로 올려주는 역할의 뷰
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.configureTextWithLineHeight(text: "당신의 프로젝트를\n소개해주세요!", lineHeight: 30)
        label.font = BridgeFont.headline1Long.font
        label.textColor = BridgeColor.gray1
        label.numberOfLines = 2
        
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "제목"
        label.font = BridgeFont.subtitle2.font
        label.textColor = BridgeColor.gray1
        
        return label
    }()
    
    private let titleTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(
            string: "글의 제목을 입력해주세요.",
            attributes: [.foregroundColor: BridgeColor.gray4]
        )
        textField.font = BridgeFont.body2.font
        textField.textColor = BridgeColor.gray1
        
        return textField
    }()
    
    private let introductionLabel: UILabel = {
        let label = UILabel()
        label.text = "소개"
        label.font = BridgeFont.subtitle2.font
        label.textColor = BridgeColor.gray1
        
        return label
    }()
    
    private let introductionTextView: UITextView = {
        let textView = UITextView()
        textView.text = "프로젝트에 대해 소개해 주세요."  // Placeholder
        textView.font = BridgeFont.body2.font
        textView.textColor = BridgeColor.gray4
        textView.textContainerInset = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 0)
        
        return textView
    }()
    
    private let nextButton: BridgeButton = {
        let button = BridgeButton(
            title: "다음",
            font: BridgeFont.button1.font,
            backgroundColor: BridgeColor.gray4
        )
        button.isEnabled = false
        
        return button
    }()
    
    // MARK: - Properties
    private let viewModel: ProjectDescriptionInputViewModel
    
    // MARK: - Initializer
    init(viewModel: ProjectDescriptionInputViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        rootFlexContainer.pin.all(view.pin.safeArea)
        rootFlexContainer.flex.layout()
    }
    
    // MARK: - Layout
    override func configureLayouts() {
        view.addSubview(rootFlexContainer)
        
        rootFlexContainer.flex.justifyContent(.spaceBetween).paddingHorizontal(16).define { flex in
            // 뷰 계층 상 progressView가 상단에 위치할 수 있도록
            flex.addItem(contentContainer)
                .position(.absolute)
                .width(100%)
                .height(470)
                .top(26)
                .marginHorizontal(16)
            
            flex.addItem().backgroundColor(BridgeColor.gray10).height(16).justifyContent(.end).define { flex in
                flex.addItem(progressView).height(6)
            }
            
            flex.addItem(nextButton).height(52).marginBottom(24)
        }
        
        contentContainer.flex.define { flex in
            flex.addItem(descriptionLabel).width(143).height(60).marginTop(40)
            
            flex.addItem(titleLabel).width(28).height(24).marginTop(40)
            flex.addItem()
                .border(1, BridgeColor.gray6)
                .cornerRadius(8)
                .height(52)
                .padding(17, 16, 17, 16)
                .marginTop(14)
                .define { flex in
                    flex.addItem(titleTextField)
                }
            
            flex.addItem(introductionLabel).width(28).height(24).marginTop(32)
            flex.addItem()
                .border(1, BridgeColor.gray6)
                .cornerRadius(8)
                .height(155)
                .padding(16)
                .marginTop(14)
                .define { flex in
                    flex.addItem(introductionTextView)
                }
        }
    }
    
    // MARK: - Configure
    override func configureAttributes() {
        configureNavigationUI()
        enableKeyboardHiding()
    }
    
    private func configureNavigationUI() {
        navigationItem.title = "모집글 작성"
    }
    
    // MARK: - Bind
    override func bind() {
        let input = ProjectDescriptionInputViewModel.Input(
            nextButtonTapped: nextButton.rx.tap.asObservable(),
            titleTextChanged: titleTextField.rx.controlEvent(.editingDidEnd)
                .withLatestFrom(titleTextField.rx.text.orEmpty)
                .distinctUntilChanged(),
            descriptionTextChanged: introductionTextView.rx.didEndEditing
                .withLatestFrom(introductionTextView.rx.text.orEmpty)
                .distinctUntilChanged()
        )
        
        let output = viewModel.transform(input: input)
        
        introductionTextView.rx.didBeginEditing
            .asDriver()
            .drive(onNext: { [weak self] in
                guard let self else { return }
                
                if self.introductionTextView.text == "프로젝트에 대해 소개해 주세요." {
                    self.introductionTextView.text = nil
                    self.introductionTextView.textColor = BridgeColor.gray1
                }
            })
            .disposed(by: disposeBag)
        
        introductionTextView.rx.didEndEditing
            .asDriver()
            .drive(onNext: { [weak self] in
                guard let self else { return }
                
                if self.introductionTextView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    self.introductionTextView.text = "프로젝트에 대해 소개해 주세요."
                    self.introductionTextView.textColor = BridgeColor.gray4
                }
            })
            .disposed(by: disposeBag)
        
        contentContainer.rx.keyboardLayoutChanged
            .bind(to: contentContainer.rx.yPosition)
            .disposed(by: disposeBag)
    }
}
