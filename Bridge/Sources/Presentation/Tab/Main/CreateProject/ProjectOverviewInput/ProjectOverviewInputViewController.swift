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

/// 프로젝트의 제목과 소개를 기입하는 VC
final class ProjectDescriptionInputViewController: BaseViewController {
    // MARK: - UI
    private let rootFlexContainer = UIView()
    
    private let progressView = BridgeProgressView(1)
    
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
        textField.layer.borderWidth = 1
        textField.layer.borderColor = BridgeColor.gray6.cgColor
        textField.layer.cornerRadius = 8
        textField.clipsToBounds = true
        textField.addLeftPadding(with: 16)
        
        return textField
    }()
    
    private let descriptionTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "소개"
        label.font = BridgeFont.subtitle2.font
        label.textColor = BridgeColor.gray1
        
        return label
    }()
    
    private let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.text = "프로젝트에 대해 소개해 주세요."  // Placeholder
        textView.font = BridgeFont.body2.font
        textView.textColor = BridgeColor.gray4
        textView.textContainerInset = UIEdgeInsets(top: 16, left: 12, bottom: 16, right: 12)
        textView.layer.borderWidth = 1
        textView.layer.borderColor = BridgeColor.gray6.cgColor
        textView.layer.cornerRadius = 8
        textView.clipsToBounds = true
        
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
    
    // MARK: - Property
    private let viewModel: ProjectDescriptionInputViewModel
    
    // MARK: - Init
    init(viewModel: ProjectDescriptionInputViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Configuration
    override func configureAttributes() {
        configureNavigationUI()
        enableKeyboardHiding()
    }
    
    private func configureNavigationUI() {
        navigationItem.title = "모집글 작성"
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
            flex.addItem(titleTextField).height(52).marginTop(14)
            
            flex.addItem(descriptionTitleLabel).width(28).height(24).marginTop(32)
            flex.addItem(descriptionTextView).height(155).marginTop(14)
        }
    }
    
    override func viewDidLayoutSubviews() {
        rootFlexContainer.pin.all(view.pin.safeArea)
        rootFlexContainer.flex.layout()
    }
    
    // MARK: - Bind
    override func bind() {
        let input = ProjectDescriptionInputViewModel.Input(
            titleTextChanged: titleTextField.rx.controlEvent(.editingDidEnd)
                .withLatestFrom(titleTextField.rx.text.orEmpty)
                .distinctUntilChanged(),
            descriptionTextChanged: descriptionTextView.rx.didEndEditing
                .withLatestFrom(descriptionTextView.rx.text.orEmpty)
                .distinctUntilChanged(),
            nextButtonTapped: nextButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        output.isNextButtonEnabled
            .drive(onNext: { [weak self] isNextButtonEnabled in
                self?.nextButton.isEnabled = isNextButtonEnabled
            })
            .disposed(by: disposeBag)
        
        // TextView 플레이스홀더 구현
        descriptionTextView.rx.didBeginEditing
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                if owner.descriptionTextView.text == "프로젝트에 대해 소개해 주세요." {
                    owner.descriptionTextView.text = nil
                    owner.descriptionTextView.textColor = BridgeColor.gray1
                }
            })
            .disposed(by: disposeBag)
        
        
        descriptionTextView.rx.didEndEditing
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                if owner.descriptionTextView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    owner.descriptionTextView.text = "프로젝트에 대해 소개해 주세요."
                    owner.descriptionTextView.textColor = BridgeColor.gray4
                }
            })
            .disposed(by: disposeBag)
        
        // 키보드 반응 구현
        contentContainer.rx.keyboardLayoutChanged
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { owner, keyboardHeight in
                UIView.animate(withDuration: 0.3) {
                    // 키보드가 내려갔을 경우
                    guard keyboardHeight > 0 else {
                        owner.contentContainer.transform = .identity
                        return
                    }
                    
                    // TextView의 반응에만 높이 조절
                    guard owner.descriptionTextView.isFirstResponder else { return }
                    
                    let containerMaxY = owner.contentContainer.windowFrame?.maxY ?? 550
                    let offSet = keyboardHeight - (UIScreen.main.bounds.height - containerMaxY)
                    
                    // 키보드가 텍스트 뷰를 가릴 경우에만 contentContainer의 위치 조정
                    if offSet > 0 {
                        owner.contentContainer.transform = CGAffineTransform(translationX: 0, y: -offSet)
                    }
                }
            })
            .disposed(by: disposeBag)
    }
}
