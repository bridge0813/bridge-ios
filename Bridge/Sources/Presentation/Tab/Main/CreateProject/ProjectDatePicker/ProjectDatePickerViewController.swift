//
//  ProjectDatePickerViewController.swift
//  Bridge
//
//  Created by 엄지호 on 2023/09/11.
//

import UIKit
import FlexLayout
import PinLayout
import RxCocoa
import RxSwift

final class ProjectDatePickerViewController: BaseViewController {
    // MARK: - UI
    private let rootFlexContainer = UIView()
    
    private let progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.progress = 0.6
        progressView.progressTintColor = BridgeColor.primary1
        progressView.backgroundColor = BridgeColor.gray7
        
        return progressView
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.configureTextWithLineHeight(text: "당신의 프로젝트에 대한\n기본 정보를 알려주세요!", lineHeight: 30)
        label.font = BridgeFont.headline1Long.font
        label.textColor = BridgeColor.gray1
        label.numberOfLines = 2
        
        return label
    }()
    
    private let deadlineLabel: UILabel = {
        let label = UILabel()
        label.text = "모집 마감일"
        label.font = BridgeFont.subtitle2.font
        label.textColor = BridgeColor.gray1
        
        return label
    }()
    private let setDeadlineButton = BridgeSetDisplayButton("프로젝트 모집 마감일은 언제인가요?")
    private let setDeadlinePopUpView = SetDeadlinePopUpView()
    
    private let startLabel: UILabel = {
        let label = UILabel()
        label.text = "시작일"
        label.font = BridgeFont.subtitle2.font
        label.textColor = BridgeColor.gray1
        
        return label
    }()
    private let setStartDateButton = BridgeSetDisplayButton("프로젝트 시작일은 언제인가요?")
    
    private let endLabel: UILabel = {
        let label = UILabel()
        label.text = "예상 완료일"
        label.font = BridgeFont.subtitle2.font
        label.textColor = BridgeColor.gray1
        
        return label
    }()
    private let setEndDateButton = BridgeSetDisplayButton("프로젝트 예상 완료일은 언제인가요?")
    
    private let nextButton = BridgeButton(
        title: "다음",
        font: BridgeFont.button1.font,
        backgroundColor: BridgeColor.gray4
    )
    
    // MARK: - Properties
    private let viewModel: ProjectDatePickerViewModel
    
    // MARK: - Initializer
    init(viewModel: ProjectDatePickerViewModel) {
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
        
        rootFlexContainer.flex.paddingHorizontal(16).define { flex in
            flex.addItem(progressView).height(6).marginTop(10)
            flex.addItem(descriptionLabel).width(190).height(60).marginTop(40)
            
            flex.addItem(deadlineLabel).width(73).height(24).marginTop(40)
            flex.addItem(setDeadlineButton).height(52).marginTop(14)
            
            flex.addItem(startLabel).width(42).height(24).marginTop(32)
            flex.addItem(setStartDateButton).height(52).marginTop(14)
            
            flex.addItem(endLabel).width(73).height(24).marginTop(32)
            flex.addItem(setEndDateButton).height(52).marginTop(14)
            
            flex.addItem().grow(1)
            flex.addItem(nextButton).height(52).marginBottom(24)
        }
    }
    
    // MARK: - Configure
    override func configureAttributes() {
        configureNavigationUI()
    }
    
    private func configureNavigationUI() {
        navigationItem.title = "모집글 작성"
    }
    
    // MARK: - Bind
    override func bind() {
        let input = ProjectDatePickerViewModel.Input(
            nextButtonTapped: nextButton.rx.tap.asObservable(),
            dueDatePickerChanged: .just(Date()),
            startDatePickerChanged: .just(nil),
            endDatePickerChanged: .just(nil)
        )
        let output = viewModel.transform(input: input)
        
        // 모집 마감일 선택 팝업 뷰 보여주기
        setDeadlineButton.rx.tap.asDriver()
            .drive(onNext: { [weak self] _ in
                self?.setDeadlinePopUpView.show()
            })
            .disposed(by: disposeBag)
    }
}
