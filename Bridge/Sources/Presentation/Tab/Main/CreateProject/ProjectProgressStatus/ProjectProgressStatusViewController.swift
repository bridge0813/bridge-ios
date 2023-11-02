//
//  ProjectProgressStatusViewController.swift
//  Bridge
//
//  Created by 엄지호 on 2023/09/11.
//

import UIKit
import FlexLayout
import PinLayout
import RxCocoa
import RxSwift

/// 프로젝트의 진행상황(진행방식, 진행단계)을 기입하는 VC
final class ProjectProgressStatusViewController: BaseViewController {
    // MARK: - UI
    private let rootFlexContainer = UIView()
    
    private let progressView = BridgeProgressView(0.8)
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.configureTextWithLineHeight(text: "당신의 프로젝트에 대한\n기본 정보를 알려주세요!", lineHeight: 30)
        label.font = BridgeFont.headline1Long.font
        label.textColor = BridgeColor.gray1
        label.numberOfLines = 2
        
        return label
    }()
    
    private let progressMethodLabel: UILabel = {
        let label = UILabel()
        label.text = "진행 방식"
        label.font = BridgeFont.subtitle2.font
        label.textColor = BridgeColor.gray1
        
        return label
    }()
    
    private let onlineButton: BridgeFieldTagButton = {
        let button = BridgeFieldTagButton("온라인")
        button.changesSelectionAsPrimaryAction = false
        
        return button
    }()
    
    private let offlineButton: BridgeFieldTagButton = {
        let button = BridgeFieldTagButton("오프라인")
        button.changesSelectionAsPrimaryAction = false
        
        return button
    }()
    
    private let blendedButton: BridgeFieldTagButton = {
        let button = BridgeFieldTagButton("블렌디드")
        button.changesSelectionAsPrimaryAction = false
        
        return button
    }()
    
    private let progressStepLabel: UILabel = {
        let label = UILabel()
        label.text = "진행 단계"
        label.font = BridgeFont.subtitle2.font
        label.textColor = BridgeColor.gray1
        
        return label
    }()
    
    private let tipMessageBox = BridgeTipMessageBox("현재 프로젝트가 어느정도 진행이 되었나요?")
    
    private let progressStepAnchorView = BridgeDropdownAnchorView("시작하기 전이에요")
    private lazy var progressStepDropdown: DropDown = {
        let dropdown = DropDown(
            anchorView: progressStepAnchorView,
            bottomOffset: CGPoint(x: 0, y: 8),
            dataSource: ["시작하기 전이에요", "기획 중이에요", "기획이 완료됐어요", "디자인 중이에요", "디자인 완료됐어요", "개발 중이에요", "개발이 완료됐어요"],
            itemTextColor: BridgeColor.gray3,
            itemTextFont: BridgeFont.body2.font,
            selectedItemTextColor: BridgeColor.gray1,
            selectedItemBackgroundColor: BridgeColor.primary3,
            cornerRadius: 8,
            borderColor: BridgeColor.gray6.cgColor,
            shadowColor: .clear
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
        button.isEnabled = false
        
        return button
    }()
    
    // MARK: - Properties
    private let viewModel: ProjectProgressStatusViewModel
    
    // MARK: - Initializer
    init(viewModel: ProjectProgressStatusViewModel) {
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
            flex.addItem(descriptionLabel).width(189).height(60).marginTop(40)
            
            flex.addItem(progressMethodLabel).width(60).height(24).marginTop(40)
            flex.addItem().direction(.row).marginTop(14).define { flex in
                flex.addItem(onlineButton).height(38)
                flex.addItem(offlineButton).height(38).marginLeft(14)
                flex.addItem(blendedButton).height(38).marginLeft(14)
            }
            
            flex.addItem(progressStepLabel).width(60).height(24).marginTop(32)
            flex.addItem(tipMessageBox).height(38).marginTop(10)
            flex.addItem(progressStepAnchorView).height(52).marginTop(14)
            
            flex.addItem().grow(1)
            flex.addItem(nextButton).height(52).marginBottom(24)
        }
    }
    
    // MARK: - Configure
    override func configureAttributes() {
        configureNavigationUI()
        progressStepAnchorView.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(anchorViewTapped))
        )
    }
    
    private func configureNavigationUI() {
        navigationItem.title = "모집글 작성"
    }
    
    @objc private func anchorViewTapped(_ sender: UITapGestureRecognizer) {
        progressStepAnchorView.isActive = true
        progressStepDropdown.show()
    }
    
    // MARK: - Bind
    override func bind() {
        let input = ProjectProgressStatusViewModel.Input(
            progressMethodButtonTapped: progressMethodButtonTapped,
            progressStep: progressStepDropdown.itemSelected.map { $0.title },
            nextButtonTapped: nextButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        output.progressMethod
            .drive(onNext: { [weak self] method in
                self?.updateButtonState(for: method)
            })
            .disposed(by: disposeBag)
        
        output.progressStep
            .drive(onNext: { [weak self] step in
                self?.progressStepAnchorView.updateTitle(step)
            })
            .disposed(by: disposeBag)
        
        output.isNextButtonEnabled
            .drive(onNext: { [weak self] isNextButtonEnabled in
                self?.nextButton.isEnabled = isNextButtonEnabled
            })
            .disposed(by: disposeBag)
        
        // Dropdown이 사라질 때, 버튼의 스타일도 원상복구
        progressStepDropdown.willHide
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.progressStepAnchorView.isActive = false
            })
            .disposed(by: disposeBag)
    }
}

extension ProjectProgressStatusViewController {
    private var progressMethodButtonTapped: Observable<String> {
        Observable.merge(
            onlineButton.rx.tap.map { "온라인" },
            offlineButton.rx.tap.map { "오프라인" },
            blendedButton.rx.tap.map { "블렌디드" }
        )
        .distinctUntilChanged()
    }
    
    private func updateButtonState(for type: String) {
        let allButtons = [onlineButton, offlineButton, blendedButton]
        allButtons.forEach { $0.isSelected = false }
        
        switch type {
        case "온라인": onlineButton.isSelected = true
        case "오프라인": offlineButton.isSelected = true
        case "블렌디드": blendedButton.isSelected = true
        default: return
        }
    }
}
