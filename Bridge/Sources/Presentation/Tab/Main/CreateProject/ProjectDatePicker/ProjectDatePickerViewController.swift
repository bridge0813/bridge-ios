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

/// 날짜(모집 마감일, 시작일, 완료일)를 설정하는 VC
final class ProjectDatePickerViewController: BaseViewController {
    // MARK: - UI
    private let rootFlexContainer = UIView()
    
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
        
        return scrollView
    }()
    
    private let contentContainer = UIView()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
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
        label.text = "모집 마감일"
        label.font = BridgeFont.subtitle2.font
        label.textColor = BridgeColor.gray01
        
        return label
    }()
    private let setDeadlineButton = BridgeSetDisplayButton("프로젝트 모집 마감일은 언제인가요?")
    
    private let startLabel: UILabel = {
        let label = UILabel()
        label.text = "시작일"
        label.font = BridgeFont.subtitle2.font
        label.textColor = BridgeColor.gray01
        
        return label
    }()
    private let setStartDateButton = BridgeSetDisplayButton("미정")
    
    private let endLabel: UILabel = {
        let label = UILabel()
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
    private let viewModel: ProjectDatePickerViewModel
    
    // MARK: - Init
    init(viewModel: ProjectDatePickerViewModel) {
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
    }
    
    private func configureNavigationUI() {
        navigationItem.title = "모집글 작성"
    }
    
    // MARK: - Layout
    override func configureLayouts() {
        view.addSubview(rootFlexContainer)
        scrollView.addSubview(contentContainer)
       
        rootFlexContainer.flex.define { flex in
            flex.addItem(progressView).height(6).marginTop(10).marginHorizontal(16)
            flex.addItem(dividerView).height(1).marginTop(18)
            
            flex.addItem().grow(1)
            
            // grow(1)로 레이아웃을 배치하면, height가 원활하게 잡히지 않고 화면 밖을 벗어나는 문제가 발생.(디바이스)
            flex.addItem(scrollView).position(.absolute).width(100%).top(35).bottom(91)
            
            flex.addItem(nextButton).height(52).marginBottom(24).marginHorizontal(16)
        }
        
        contentContainer.flex.paddingHorizontal(16).define { flex in
            flex.addItem(descriptionLabel).width(190).height(60).marginTop(21)
            flex.addItem(tipMessageBox).height(38).marginTop(16)
            
            flex.addItem(deadlineLabel).width(73).height(24).marginTop(40)
            flex.addItem(setDeadlineButton).height(52).marginTop(14)
            
            flex.addItem(startLabel).width(42).height(24).marginTop(32)
            flex.addItem(setStartDateButton).height(52).marginTop(14)
            
            flex.addItem(endLabel).width(73).height(24).marginTop(32)
            flex.addItem(setEndDateButton).height(52).marginTop(14).marginBottom(20)
        }
    }
    
    override func viewDidLayoutSubviews() {
        rootFlexContainer.pin.all(view.pin.safeArea)
        rootFlexContainer.flex.layout()
        
        contentContainer.pin.all()
        contentContainer.flex.layout(mode: .adjustHeight)
        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: contentContainer.frame.height)
    }
    
    // MARK: - Bind
    override func bind() {
        let input = ProjectDatePickerViewModel.Input(
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
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.datePickerPopUpView.setDateType = .deadline
            })
            .disposed(by: disposeBag)
        
        // 시작일 선택 팝업 뷰 보여주기
        setStartDateButton.rx.tap
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.datePickerPopUpView.setDateType = .start
            })
            .disposed(by: disposeBag)
        
        // 완료일 선택 팝업 뷰 보여주기
        setEndDateButton.rx.tap
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.datePickerPopUpView.setDateType = .end
            })
            .disposed(by: disposeBag)
        
        // 구분선 등장
        scrollView.rx.contentOffset
            .map { $0.y > 0 }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { owner, shouldHidden in
                owner.dividerView.isHidden = !shouldHidden
            })
            .disposed(by: disposeBag)
    }
}
