//
//  SetMemberRequirementViewController.swift
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
final class SetMemberRequirementViewController: BaseViewController {
    // MARK: - UI
    private let progressContainer: UIView = {
        let view = UIView()
        view.backgroundColor = BridgeColor.gray10
        return view
    }()

    private let progressView: BridgeProgressView = {
        let view = BridgeProgressView(0.4)
        view.flex.height(6)
        return view
    }()

    private let dividerView: UIView = {
        let divider = UIView()
        divider.flex.width(100%).height(1)
        divider.backgroundColor = BridgeColor.gray06
        divider.isHidden = true

        return divider
    }()

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .clear
        scrollView.alwaysBounceVertical = true
        scrollView.showsVerticalScrollIndicator = false

        return scrollView
    }()

    private let contentContainer = UIView()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.flex.width(187).height(60)
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
        label.flex.width(60).height(24)
        label.text = "모집 인원"
        label.font = BridgeFont.subtitle2.font
        label.textColor = BridgeColor.gray01

        return label
    }()
    private let setRecruitNumberButton: BridgeSetDisplayButton = {
        let button = BridgeSetDisplayButton("몇 명을 모집할까요?")
        button.flex.width(150).height(52)
        return button
    }()
    private let setRecruitmentNumberView = SetRecruitmentNumberPopUpView()

    private let memberTechStackLabel: UILabel = {
        let label = UILabel()
        label.flex.width(60).height(24)
        label.text = "팀원 스택"
        label.font = BridgeFont.subtitle2.font
        label.textColor = BridgeColor.gray01

        return label
    }()
    
    private let addTechStackButton: BridgeAddButton = {
        let button = BridgeAddButton(titleFont: BridgeFont.body1.font)
        button.flex.width(100).height(24)
        button.contentHorizontalAlignment = .right
        return button
    }()
    private let addedTechTagView = AddedTechTagView()
    private let addTechTagPopUpView = AddTechTagPopUpView()

    private let requirementLabel: UILabel = {
        let label = UILabel()
        label.flex.width(60).height(24)
        label.text = "바라는 점"
        label.font = BridgeFont.subtitle2.font
        label.textColor = BridgeColor.gray01

        return label
    }()
    private let requirementTextView: BridgeTextView = {
        let textView = BridgeTextView(placeholder: "이런 팀원이었으면 좋겠어요.", maxCount: 100)
        textView.flex.width(100%).height(106)
        return textView
    }()
    
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
    private let viewModel: SetMemberRequirementViewModel
    
    // MARK: - Init
    init(viewModel: SetMemberRequirementViewModel) {
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
        view.addSubview(scrollView)
        view.addSubview(progressContainer)
        view.addSubview(nextButton)
        scrollView.addSubview(contentContainer)

        progressContainer.flex.define { flex in
            flex.addItem(progressView).marginTop(10).marginHorizontal(16)
            flex.addItem(dividerView).marginTop(18)
        }

        contentContainer.flex.paddingHorizontal(16).define { flex in
            flex.addItem(descriptionLabel).marginTop(21)
            flex.addItem(fieldTagButton).marginTop(40)

            flex.addItem(recruitLabel).marginTop(20)
            flex.addItem(setRecruitNumberButton).marginTop(14)

            flex.addItem()
                .direction(.row)
                .justifyContent(.spaceBetween)
                .marginTop(32)
                .define { flex in
                    flex.addItem(memberTechStackLabel)
                    flex.addItem(addTechStackButton).marginRight(0)
                }
            flex.addItem(addedTechTagView).marginTop(14)

            flex.addItem(requirementLabel).marginTop(32)
            flex.addItem(requirementTextView).marginTop(14).marginBottom(24)
        }
    }

    override func viewDidLayoutSubviews() {
        progressContainer.pin.top(view.pin.safeArea.top).horizontally().height(35)
        progressContainer.flex.layout()

        scrollView.pin.below(of: progressContainer).horizontally().bottom(view.pin.safeArea + 101)
        nextButton.pin.below(of: scrollView).marginTop(25).horizontally(16).height(52)

        contentContainer.pin.all()
        contentContainer.flex.layout(mode: .adjustHeight)

        scrollView.contentSize = contentContainer.frame.size
    }
    
    // MARK: - Bind
    override func bind() {
        let input = SetMemberRequirementViewModel.Input(
            recruitNumber: setRecruitmentNumberView.completeButtonTapped,
            techTags: addTechTagPopUpView.completeButtonTapped,
            requirementText: requirementTextView.resultText,
            nextButtonTapped: nextButton.rx.tap.asObservable()
        )
        let output = viewModel.transform(input: input)
        
        // 현재 모집하려는 분야
        output.selectedField
            .drive(onNext: { [weak self] field in
                guard let self else { return }
                self.fieldTagButton.updateTitle(with: field, textColor: BridgeColor.primary1)
                self.fieldTagButton.flex.width(fieldTagButton.intrinsicContentSize.width).height(38).markDirty()
                self.addTechTagPopUpView.fieldUpdated.onNext(TechStack(rawValue: field)?.techStacks ?? [])
                self.contentContainer.flex.layout()
            })
            .disposed(by: disposeBag)
        
        // 모집인원 선택완료 이벤트.
        output.recruitNumber
            .drive(onNext: { [weak self] number in
                guard let self else { return }
                self.setRecruitNumberButton.updateTitle("\(number)명")
            })
            .disposed(by: disposeBag)
        
        // 기술태그 선택완료 이벤트.
        output.techTags
            .drive(onNext: { [weak self] tagNames in
                guard let self else { return }
                self.addTechStackButton.isAdded = true
                self.addedTechTagView.tagNames = tagNames
                self.addedTechTagView.flex.markDirty()
                self.view.setNeedsLayout()
            })
            .disposed(by: disposeBag)
        
        output.isNextButtonEnabled
            .drive(onNext: { [weak self] isNextButtonEnabled in
                guard let self else { return }
                self.nextButton.isEnabled = isNextButtonEnabled
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
        contentContainer.rx.keyboardLayoutChanged
            .withUnretained(self)
            .subscribe(onNext: { owner, keyboardHeight in
                UIView.animate(withDuration: 0.3) {
                    if keyboardHeight == 0 {
                        owner.contentContainer.transform = CGAffineTransform.identity
                    } else {
                        // contentContainer가 아래에서 어느정도 띄워져있는지 체크
                        let window = UIWindow.visibleWindow() ?? UIWindow()
                        let contentContainerMaxY = owner.contentContainer.windowFrame?.maxY ?? 550
                        let windowMaxY = window.bounds.maxY
                        let contentContainerBottomMargin = windowMaxY - contentContainerMaxY

                        let yPosition = keyboardHeight - (contentContainerBottomMargin)
                        owner.contentContainer.transform = CGAffineTransform(translationX: 0, y: -yPosition)
                    }
                }
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
