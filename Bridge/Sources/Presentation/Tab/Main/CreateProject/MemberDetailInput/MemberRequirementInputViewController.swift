//
//  MemberDetailInputViewController.swift
//  Bridge
//
//  Created by 엄지호 on 2023/09/11.
//

import UIKit
import FlexLayout
import PinLayout
import RxCocoa
import RxSwift

/// 선택한 분야에서 모집하는 팀원의 요구사항을 기입하는 컨트롤러
final class MemberRequirementInputViewController: BaseViewController {
    // MARK: - UI
    private let rootFlexContainer = UIView()
   
    private let progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.progress = 0.4
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
        label.configureTextWithLineHeight(text: "당신이 찾고 있는 팀원의\n정보를 알려주세요!", lineHeight: 30)
        label.font = BridgeFont.headline1Long.font
        label.textColor = BridgeColor.gray1
        label.numberOfLines = 2
        
        return label
    }()
    
    private let fieldTagButton: BridgeFieldTagButton = {
        let button = BridgeFieldTagButton("")
        button.changesSelectionAsPrimaryAction = false
        button.isSelected = true
        
        return button
    }()
    
    
    private let recruitLabel: UILabel = {
        let label = UILabel()
        label.text = "모집 인원"
        label.font = BridgeFont.subtitle2.font
        label.textColor = BridgeColor.gray1
        
        return label
    }()
    private let setRecruitNumberButton = BridgeSetDisplayButton("몇 명을 모집할까요?")
    
    
    private let memberTechStackLabel: UILabel = {
        let label = UILabel()
        label.text = "팀원 스택"
        label.font = BridgeFont.subtitle2.font
        label.textColor = BridgeColor.gray1
        
        return label
    }()
    private let addTechStackButton = AddTechStackButton()
    private let addedTechTagView = AddedTechTagView()
    
    
    private let requirementLabel: UILabel = {
        let label = UILabel()
        label.text = "바라는 점"
        label.font = BridgeFont.subtitle2.font
        label.textColor = BridgeColor.gray1
        
        return label
    }()
    private let requirementTextView = BridgeTextView(textViewPlaceholder: "팀원들에게 나를 소개해보세요.", maxCount: 100)
    
    private let nextButton = BridgeButton(
        title: "다음",
        font: BridgeFont.button1.font,
        backgroundColor: BridgeColor.gray4
    )
   
    // MARK: - Properties
    private let viewModel: MemberRequirementInputViewModel
    
    // MARK: - Initializer
    init(viewModel: MemberRequirementInputViewModel) {
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
    
    // MARK: - Methods
    private func configureNavigationUI() {
        navigationItem.title = "모집글 작성"
    }
    
    override func configureLayouts() {
        view.addSubview(rootFlexContainer)
        scrollView.addSubview(contentContainer)
        
        rootFlexContainer.flex.justifyContent(.spaceBetween).marginHorizontal(16).define { flex in
            flex.addItem(progressView).height(6).marginTop(10)
            
            // grow(1)로 레이아웃을 배치하면, height가 원활하게 잡히지 않고 화면 밖을 벗어나는 문제가 발생.(디바이스)
            flex.addItem(scrollView).position(.absolute).width(100%).top(26).bottom(98)
            
            flex.addItem(nextButton).height(52).marginBottom(24)
        }
        
        configureContentLayout()
    }
    
    private func configureContentLayout() {
        contentContainer.flex.define { flex in
            flex.addItem(descriptionLabel).width(187).height(60).marginTop(30)
            flex.addItem(fieldTagButton).alignSelf(.start).marginTop(40)
            
            flex.addItem(recruitLabel).width(60).height(24).marginTop(20)
            flex.addItem(setRecruitNumberButton).alignSelf(.start).height(52).marginTop(14)
        
            flex.addItem().direction(.row).alignItems(.center).marginTop(32).define { flex in
                flex.addItem(memberTechStackLabel).width(60).height(24)
                flex.addItem().grow(1)
                flex.addItem(addTechStackButton).marginRight(0)
            }
            flex.addItem(addedTechTagView).marginTop(14)
            
            flex.addItem(requirementLabel).width(60).height(24).marginTop(32)
            flex.addItem(requirementTextView).height(106).marginTop(14)
        }
    }
    
    override func configureAttributes() {
        configureNavigationUI()
    }
    
    override func bind() {
        let input = MemberRequirementInputViewModel.Input(
            viewDidLoad: .just(()),
            nextButtonTapped: nextButton.rx.tap.asObservable(),
            recruitNumberButtonTapped: .just(2),
            skillTagButtonTapped: .just(["Swift", "UIKit", "MVVM"])
//            requirementsTextChanged: requirementsTextView.rx.didEndEditing
//                .withLatestFrom(requirementsTextView.rx.text.orEmpty)
//                .distinctUntilChanged()
        )
        let output = viewModel.transform(input: input)
        
        output.selectedField
            .drive(onNext: { [weak self] field in
                self?.fieldTagButton.updateTitle(field)
                // 분야에 맞는 기술 스택 주입.
            })
            .disposed(by: disposeBag)
        
        // 테스트용
        addTechStackButton.rx.tap.asDriver()
            .drive(onNext: { [weak self] _ in
                self?.addTechStackButton.isAdded.toggle()
                self?.addTechStackButton.flex.markDirty()
                self?.view.setNeedsLayout()
            })
            .disposed(by: disposeBag)
        
        // 테스트용
        setRecruitNumberButton.rx.tap.asDriver()
            .drive(onNext: { [weak self] _ in
                self?.setRecruitNumberButton.updateTitle("2명")
            })
            .disposed(by: disposeBag)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
