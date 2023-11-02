//
//  ApplicantRestrictionViewController.swift
//  Bridge
//
//  Created by 엄지호 on 2023/09/14.
//

import UIKit
import FlexLayout
import PinLayout
import RxCocoa
import RxSwift

/// 지원을 제한하는 VC
final class ApplicantRestrictionViewController: BaseViewController {
    // MARK: - UI
    private let rootFlexContainer = UIView()
    
    private let progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.progress = 0.5
        progressView.progressTintColor = BridgeColor.primary1
        progressView.backgroundColor = BridgeColor.gray7
        
        return progressView
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.configureTextWithLineHeight(text: "제한하고 싶은\n팀원을 알려주세요!", lineHeight: 30)
        label.font = BridgeFont.headline1Long.font
        label.textColor = BridgeColor.gray1
        label.numberOfLines = 2
        
        return label
    }()
    
    private let tipMessageBox = BridgeTipMessageBox("지원 가능한 팀원을 제한 할 수 있습니다.")
    
    private let restrictionLabel: UILabel = {
        let label = UILabel()
        label.text = "지원 제한"
        label.font = BridgeFont.subtitle2.font
        label.textColor = BridgeColor.gray1
        
        return label
    }()
    
    private let studentButton = BridgeFieldTagButton("학생")
    private let currentEmployeeButton = BridgeFieldTagButton("현직자")
    private let jobSeekerButton = BridgeFieldTagButton("취준생")
    private let noRestrictionButton = BridgeFieldTagButton("제한없음")
    
    private let nextButton = BridgeButton(
        title: "다음",
        font: BridgeFont.button1.font,
        backgroundColor: BridgeColor.gray4
    )
    
    // MARK: - Properties
    private let viewModel: ApplicantRestrictionViewModel
    
    // MARK: - Initializer
    init(viewModel: ApplicantRestrictionViewModel) {
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
            flex.addItem(descriptionLabel).width(150).height(60).marginTop(40)
            flex.addItem(tipMessageBox).height(38).marginTop(16)
            
            flex.addItem(restrictionLabel).width(60).height(24).marginTop(40)
            
            flex.addItem().direction(.row).marginTop(14).define { flex in
                flex.addItem(studentButton).height(38)
                flex.addItem(currentEmployeeButton).height(38).marginLeft(14)
            }
            flex.addItem().direction(.row).marginTop(14).define { flex in
                flex.addItem(jobSeekerButton).height(38)
                flex.addItem(noRestrictionButton).height(38).marginLeft(14)
            }
            
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
        let input = ApplicantRestrictionViewModel.Input(
            selectedRestriction: restrictionButtonTapped,
            nextButtonTapped: nextButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        // 제한없음을 누르면 다른 버튼들은 선택되지 않도록,
        // 다른 버튼들을 누르면 제한없음 버튼이 선택되지 않도록
        // 저장된 데이터가 없을 경우 다음버튼 비활성화
        output.selectedRestrictions
            .drive(onNext: { [weak self] restrictions in
                guard let self else { return }
                let buttons = [self.studentButton, self.currentEmployeeButton, self.jobSeekerButton]
                
                if restrictions.contains("제한없음") {
                    buttons.forEach { $0.isEnabled = false }
                    self.noRestrictionButton.isEnabled = true
                    
                } else {
                    buttons.forEach { $0.isEnabled = true }
                    self.noRestrictionButton.isEnabled = restrictions.isEmpty
                }
                
                self.nextButton.isEnabled = !restrictions.isEmpty
            })
            .disposed(by: disposeBag)
    }
}

extension ApplicantRestrictionViewController {
    private var restrictionButtonTapped: Observable<String> {
        Observable.merge(
            studentButton.rx.tap.map { "학생" },
            currentEmployeeButton.rx.tap.map { "현직자" },
            jobSeekerButton.rx.tap.map { "취준생" },
            noRestrictionButton.rx.tap.map { "제한없음" }
        )
    }
}
