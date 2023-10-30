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

final class ApplicantRestrictionViewController: BaseViewController {
    // MARK: - UI
    private let rootFlexContainer = UIView()
    
    private let progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.progress = 0.2
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
    private let restrictionDropdownAnchorView = BridgeDropdownAnchorView("제한 없음")
    private lazy var restrictionDropdown: DropDown = {
        let dropdown = DropDown(
            anchorView: restrictionDropdownAnchorView,
            bottomOffset: CGPoint(x: 0, y: 8),
            dataSource: ["제한없음", "학생", "현직자", "취준생"],
            itemTextColor: BridgeColor.gray3,
            itemTextFont: BridgeFont.body2.font,
            selectedItemTextColor: BridgeColor.gray1,
            selectedItemBackgroundColor: BridgeColor.primary3
        )
        dropdown.selectedItemIndexRow = 0
        
        return dropdown
    }()
    
    private let nextButton: BridgeButton = {
        let button = BridgeButton(
            title: "다음",
            font: BridgeFont.button1.font,
            backgroundColor: BridgeColor.gray4
        )
        button.isEnabled = true
        
        return button
    }()
    
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
            flex.addItem(restrictionDropdownAnchorView).height(52).marginTop(14)
            flex.addItem().grow(1)
            flex.addItem(nextButton).height(52).marginBottom(24)
        }
    }
    
    // MARK: - Configure
    override func configureAttributes() {
        configureNavigationUI()
        restrictionDropdownAnchorView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(anchorViewTapped)))
    }
    
    private func configureNavigationUI() {
        navigationItem.title = "모집글 작성"
    }
    
    @objc private func anchorViewTapped(_ sender: UITapGestureRecognizer) {
        restrictionDropdownAnchorView.isActive = true
        restrictionDropdown.show()
    }
    
    // MARK: - Bind
    override func bind() {
        let input = ApplicantRestrictionViewModel.Input(
            nextButtonTapped: nextButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(input: input)
     
        restrictionDropdown.willHide.asDriver(onErrorJustReturn: ())
            .drive(onNext: { [weak self] in
                self?.restrictionDropdownAnchorView.isActive = false
            })
            .disposed(by: disposeBag)
    }
}
