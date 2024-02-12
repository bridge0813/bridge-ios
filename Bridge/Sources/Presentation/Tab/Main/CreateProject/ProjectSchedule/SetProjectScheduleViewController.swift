//
//  SetProjectScheduleViewController.swift
//  Bridge
//
//  Created by 엄지호 on 2023/09/11.
//

import UIKit
import FlexLayout
import PinLayout
import RxCocoa
import RxSwift

/// 날짜(모집 마감일, 시작일, 완료일)를 설정하는 VC
final class SetProjectScheduleViewController: BaseViewController {
    // MARK: - UI
    private let progressView = BridgeProgressView(0.6)
    
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
        label.flex.width(190).height(60)
        label.configureTextWithLineHeight(text: "당신의 프로젝트에 대한\n기본 정보를 알려주세요!", lineHeight: 30)
        label.font = BridgeFont.headline1Long.font
        label.textColor = BridgeColor.gray01
        label.numberOfLines = 2
        
        return label
    }()
    
    private let tipMessageBox = BridgeTipMessageBox("시작일과 예상 완료일은 미선택 시 미정으로 표시됩니다.")
    
    private let datePickerPopUpView = DatePickerPopUpView()
    
    private let deadlineLabel: UILabel = {
        let label = UILabel()
        label.flex.width(73).height(24)
        label.text = "모집 마감일"
        label.font = BridgeFont.subtitle2.font
        label.textColor = BridgeColor.gray01
        
        return label
    }()
    private let setDeadlineButton = BridgeSetDisplayButton("프로젝트 모집 마감일은 언제인가요?")
    
    private let startLabel: UILabel = {
        let label = UILabel()
        label.flex.width(42).height(24)
        label.text = "시작일"
        label.font = BridgeFont.subtitle2.font
        label.textColor = BridgeColor.gray01
        
        return label
    }()
    private let setStartDateButton = BridgeSetDisplayButton("미정")
    
    private let endLabel: UILabel = {
        let label = UILabel()
        label.flex.width(73).height(24)
        label.text = "예상 완료일"
        label.font = BridgeFont.subtitle2.font
        label.textColor = BridgeColor.gray01
        
        return label
    }()
    private let setEndDateButton = BridgeSetDisplayButton("미정")
    
    private let nextButton: BridgeButton = {
        let button = BridgeButton(
            title: "다음",
            font: BridgeFont.button1.font,
            backgroundColor: BridgeColor.gray04
        )
        button.isEnabled = false
        
        return button
    }()
    
    // MARK: - Property
    private let viewModel: SetProjectScheduleViewModel
    
    // MARK: - Init
    init(viewModel: SetProjectScheduleViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Configuration
    override func configureAttributes() {
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
            flex.addItem(descriptionLabel).marginTop(21)
            flex.addItem(tipMessageBox).height(38).marginTop(16)
            
            flex.addItem(deadlineLabel).marginTop(40)
            flex.addItem(setDeadlineButton).height(52).marginTop(14)
            
            flex.addItem(startLabel).marginTop(32)
            flex.addItem(setStartDateButton).height(52).marginTop(14)
            
            flex.addItem(endLabel).marginTop(32)
            flex.addItem(setEndDateButton).height(52).marginTop(14).marginBottom(20)
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
    
    // MARK: - Bind
    override func bind() {
        let input = SetProjectScheduleViewModel.Input(
            date: datePickerPopUpView.completeButtonTapped,
            nextButtonTapped: nextButton.rx.tap.asObservable()
        )
        let output = viewModel.transform(input: input)
        
        output.date
            .drive(onNext: { [weak self] result in
                switch result.type {
                case "deadline":
                    self?.setDeadlineButton.updateTitle(result.date.toString(format: "yyyy년 MM월 dd일"))
                    self?.nextButton.isEnabled = true
                    
                case "start":
                    self?.setStartDateButton.updateTitle(result.date.toString(format: "yyyy년 MM월 dd일"))
                    
                case "end":
                    self?.setEndDateButton.updateTitle(result.date.toString(format: "yyyy년 MM월 dd일"))
                    
                default: return
                }
            })
            .disposed(by: disposeBag)
        
        // 모집 마감일 선택 팝업 뷰 보여주기
        setDeadlineButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.datePickerPopUpView.setDateType = .deadline
            })
            .disposed(by: disposeBag)
        
        // 시작일 선택 팝업 뷰 보여주기
        setStartDateButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.datePickerPopUpView.setDateType = .start
            })
            .disposed(by: disposeBag)
        
        // 완료일 선택 팝업 뷰 보여주기
        setEndDateButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.datePickerPopUpView.setDateType = .end
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
