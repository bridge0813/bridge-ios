//
//  SetMemberFieldViewController.swift
//  Bridge
//
//  Created by 엄지호 on 2023/09/11.
//

import UIKit
import FlexLayout
import PinLayout
import RxCocoa
import RxSwift

/// 모집하려는 팀원의 분야를 선택하는 VC
final class SetMemberFieldViewController: BaseViewController {
    // MARK: - UI
    private lazy var dismissButton: UIBarButtonItem = {
        let image = UIImage(named: "xmark")?.resize(to: CGSize(width: 24, height: 24))
            .withAlignmentRectInsets(UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 0))
        let button = UIBarButtonItem(
            image: image,
            style: .done,
            target: self,
            action: nil
        )
        return button
    }()

    private let progressView = BridgeProgressView(0.2)

    private let dividerView: UIView = {
        let divider = UIView()
        divider.backgroundColor = BridgeColor.gray06
        divider.isHidden = true

        return divider
    }()

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .clear
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = true
        return scrollView
    }()

    private let contentContainer = UIView()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.flex.width(148).height(60)
        label.configureTextWithLineHeight(text: "어떤 분야의 팀원을\n찾고 있나요?", lineHeight: 30)
        label.font = BridgeFont.headline1Long.font
        label.textColor = BridgeColor.gray01
        label.numberOfLines = 2

        return label
    }()

    private let tipMessageBox = BridgeTipMessageBox("복수 선택이 가능해요")

    private let setFieldView = BridgeSetFieldView()

    private let nextButton = BridgeButton(
        title: "다음",
        font: BridgeFont.button1.font,
        backgroundColor: BridgeColor.gray04
    )
    
    // MARK: - Property
    private let viewModel: SetMemberFieldViewModel
    
    // MARK: - Init
    init(viewModel: SetMemberFieldViewModel) {
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
        navigationItem.leftBarButtonItem = dismissButton
        navigationItem.title = "모집글 작성"
    }
    
    // MARK: - Layout
    override func configureLayouts() {
        view.addSubview(progressView)
        view.addSubview(dividerView)
        view.addSubview(scrollView)
        view.addSubview(nextButton)
        scrollView.addSubview(contentContainer)

        contentContainer.flex.paddingHorizontal(16).define { flex in
            flex.addItem(descriptionLabel).marginTop(16)
            flex.addItem(tipMessageBox).height(38).marginTop(16)
            flex.addItem(setFieldView).height(396).marginTop(40).marginBottom(15)
        }
    }

    override func viewDidLayoutSubviews() {
        progressView.pin.top(view.pin.safeArea.top + 10).horizontally(16).height(6)
        dividerView.pin.below(of: progressView).marginTop(18).horizontally().height(1)
        scrollView.pin.below(of: dividerView).horizontally().bottom(view.pin.safeArea + 101)
        nextButton.pin.below(of: scrollView).marginTop(25).horizontally(16).height(52)
        
        contentContainer.pin.all()
        contentContainer.flex.layout(mode: .adjustHeight)
        
        scrollView.contentSize = contentContainer.frame.size
    }
    
    // MARK: - Binding
    override func bind() {
        let input = SetMemberFieldViewModel.Input(
            dismissButtonTapped: dismissButton.rx.tap,
            fieldTagButtonTapped: setFieldView.fieldTagButtonTapped,
            nextButtonTapped: nextButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        output.isNextButtonEnabled
            .drive(onNext: { [weak self] isNextButtonEnabled in
                self?.nextButton.isEnabled = isNextButtonEnabled
            })
            .disposed(by: disposeBag)
        
        // 구분선 등장
        scrollView.rx.contentOffset
            .map { $0.y > 0 }
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe(onNext: { owner, shouldHidden in
                owner.dividerView.isHidden = !shouldHidden
            })
            .disposed(by: disposeBag)
    }
}
