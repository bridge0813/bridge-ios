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

/// 선택한 분야에서 모집하는 팀원의 요구사항(모집인원, 기술스택, 바라는 점)을 기입하는 VC
final class MemberRequirementInputViewController: BaseViewController {
    // MARK: - UI
    private let rootFlexContainer = UIView()
   
    private let progressView = BridgeProgressView(0.4)
    
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
        label.configureTextWithLineHeight(text: "당신이 찾고 있는 팀원의\n정보를 알려주세요!", lineHeight: 30)
        label.font = BridgeFont.headline1Long.font
        label.textColor = BridgeColor.gray01
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
        label.textColor = BridgeColor.gray01
        
        return label
    }()
    private let setRecruitNumberButton = BridgeSetDisplayButton("몇 명을 모집할까요?")
    private let setRecruitmentNumberView = SetRecruitmentNumberPopUpView()
    
    
    private let memberTechStackLabel: UILabel = {
        let label = UILabel()
        label.text = "팀원 스택"
        label.font = BridgeFont.subtitle2.font
        label.textColor = BridgeColor.gray01
        
        return label
    }()
    private let addTechStackButton = AddTechStackButton()
    private let addedTechTagView = AddedTechTagView()
    private let addTechTagPopUpView = AddTechTagPopUpView()
    
    private let requirementLabel: UILabel = {
        let label = UILabel()
        label.text = "바라는 점"
        label.font = BridgeFont.subtitle2.font
        label.textColor = BridgeColor.gray01
        
        return label
    }()
    private let requirementTextView = BridgeTextView(textViewPlaceholder: "이런 팀원이었으면 좋겠어요.", maxCount: 100)
    
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
    private let viewModel: MemberRequirementInputViewModel
    
    // MARK: - Init
    init(viewModel: MemberRequirementInputViewModel) {
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
    
    // MARK: - Configuration
    override func configureAttributes() {
        navigationItem.title = "모집글 작성"
        enableKeyboardHiding()
    }
    
    // MARK: - Layout
    override func configureLayouts() {
        view.addSubview(rootFlexContainer)
        scrollView.addSubview(contentContainer)
        
        rootFlexContainer.flex.justifyContent(.spaceBetween).define { flex in
            // grow(1)로 레이아웃을 배치하면, height가 원활하게 잡히지 않고 화면 밖을 벗어나는 문제가 발생.(디바이스)
            flex.addItem(scrollView).position(.absolute).width(100%).top(35).bottom(101)
            
            flex.addItem().backgroundColor(BridgeColor.gray10).height(35).define { flex in
                flex.addItem(progressView).height(6).marginTop(10).marginHorizontal(16)
                flex.addItem(dividerView).height(1).marginTop(18)
            }
            
            flex.addItem(nextButton).height(52).marginBottom(24).marginHorizontal(16)
        }
        
        contentContainer.flex.paddingHorizontal(16).define { flex in
            flex.addItem(descriptionLabel).width(187).height(60).marginTop(21)
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
            flex.addItem(requirementTextView).height(106).marginTop(14).marginBottom(15)
        }
    }
    
    override func viewDidLayoutSubviews() {
        rootFlexContainer.pin.all(view.pin.safeArea)
        rootFlexContainer.flex.layout()
        
        contentContainer.pin.all()
        contentContainer.flex.layout(mode: .adjustHeight)
        scrollView.contentSize = contentContainer.frame.size
    }
    
    // MARK: - Bind
    override func bind() {
        let input = MemberRequirementInputViewModel.Input(
            recruitNumber: setRecruitmentNumberView.completeButtonTapped,
            techTags: addTechTagPopUpView.completeButtonTapped,
            requirementText: requirementTextView.resultText,
            nextButtonTapped: nextButton.rx.tap.asObservable()
        )
        let output = viewModel.transform(input: input)
        
        // 현재 모집하려는 분야
        output.selectedField
            .drive(onNext: { [weak self] field in
                self?.fieldTagButton.updateTitle(with: field, textColor: BridgeColor.primary1)
                self?.addTechTagPopUpView.field = field  // 기술 태그 선택하는 팝업 뷰에 선택된 분야를 전달
            })
            .disposed(by: disposeBag)
        
        // 모집인원 선택완료 이벤트.
        output.recruitNumber
            .drive(onNext: { [weak self] number in
                self?.setRecruitNumberButton.updateTitle("\(number)명")
            })
            .disposed(by: disposeBag)
        
        // 기술태그 선택완료 이벤트.
        output.techTags
            .drive(onNext: { [weak self] tagNames in
                self?.addTechStackButton.isAdded = true
                self?.addedTechTagView.tagNames = tagNames
                self?.view.setNeedsLayout()
            })
            .disposed(by: disposeBag)
        
        output.isNextButtonEnabled
            .drive(onNext: { [weak self] isNextButtonEnabled in
                self?.nextButton.isEnabled = isNextButtonEnabled
            })
            .disposed(by: disposeBag)
        
        // 모집인원 선택 팝업 뷰 보여주기
        setRecruitNumberButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.setRecruitmentNumberView.show()
            })
            .disposed(by: disposeBag)
        
        // 기술태그 추가 팝업 뷰 보여주기
        addTechStackButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.addTechTagPopUpView.show()
            })
            .disposed(by: disposeBag)
        
        // 키보드에 맞춰 뷰 이동
        scrollView.rx.keyboardLayoutChanged
            .bind(to: scrollView.rx.yPosition)
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
