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
        label.textColor = BridgeColor.gray1
        label.numberOfLines = 2
        
        return label
    }()
    
    private let tipMessageBox = BridgeTipMessageBox("시작일과 예상 완료일은 미선택 시 미정으로 표시됩니다.")
    
    private let setDatePopUpView = SetDatePopUpView()
    
    private let deadlineLabel: UILabel = {
        let label = UILabel()
        label.text = "모집 마감일"
        label.font = BridgeFont.subtitle2.font
        label.textColor = BridgeColor.gray1
        
        return label
    }()
    private let setDeadlineButton = BridgeSetDisplayButton("프로젝트 모집 마감일은 언제인가요?")
    
    private let startLabel: UILabel = {
        let label = UILabel()
        label.text = "시작일"
        label.font = BridgeFont.subtitle2.font
        label.textColor = BridgeColor.gray1
        
        return label
    }()
    private let setStartDateButton = BridgeSetDisplayButton("미정")
    
    private let endLabel: UILabel = {
        let label = UILabel()
        label.text = "예상 완료일"
        label.font = BridgeFont.subtitle2.font
        label.textColor = BridgeColor.gray1
        
        return label
    }()
    private let setEndDateButton = BridgeSetDisplayButton("미정")
    
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
        
        contentContainer.pin.all()
        contentContainer.flex.layout(mode: .adjustHeight)
        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: contentContainer.frame.height)
    }
    
    // MARK: - Layout
    override func configureLayouts() {
        view.addSubview(rootFlexContainer)
        scrollView.addSubview(contentContainer)
        
        rootFlexContainer.flex.marginHorizontal(16).define { flex in
            flex.addItem(progressView).height(6).marginTop(10)
            
            flex.addItem().grow(1)
            
            // grow(1)로 레이아웃을 배치하면, height가 원활하게 잡히지 않고 화면 밖을 벗어나는 문제가 발생.(디바이스)
            flex.addItem(scrollView).position(.absolute).width(100%).top(36).bottom(91)
            
            flex.addItem(nextButton).height(52).marginBottom(24)
        }
        
        contentContainer.flex.define { flex in
            flex.addItem(descriptionLabel).width(190).height(60).marginTop(20)
            flex.addItem(tipMessageBox).height(38).marginTop(16)
            
            flex.addItem(deadlineLabel).width(73).height(24).marginTop(40)
            flex.addItem(setDeadlineButton).height(52).marginTop(14)
            
            flex.addItem(startLabel).width(42).height(24).marginTop(32)
            flex.addItem(setStartDateButton).height(52).marginTop(14)
            
            flex.addItem(endLabel).width(73).height(24).marginTop(32)
            flex.addItem(setEndDateButton).height(52).marginTop(14).marginBottom(20)
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
            date: setDatePopUpView.completeButtonTapped,
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
        setDeadlineButton.rx.tap.asDriver()
            .drive(onNext: { [weak self] _ in
                self?.setDatePopUpView.show(for: .deadline)
            })
            .disposed(by: disposeBag)
        
        // 시작일 선택 팝업 뷰 보여주기
        setStartDateButton.rx.tap.asDriver()
            .drive(onNext: { [weak self] _ in
                self?.setDatePopUpView.show(for: .start)
            })
            .disposed(by: disposeBag)
        
        // 완료일 선택 팝업 뷰 보여주기
        setEndDateButton.rx.tap.asDriver()
            .drive(onNext: { [weak self] _ in
                // 시작일이 먼저 지정되어야 완료일을 지정할 수 있음.
                if self?.setStartDateButton.titleLabel?.text != "미정" {
                    self?.setDatePopUpView.show(for: .end)
                }
            })
            .disposed(by: disposeBag)
    }
}
