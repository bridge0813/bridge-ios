//
//  UpdateMemberRequirementViewController.swift
//  Bridge
//
//  Created by 엄지호 on 2/9/24.
//

import UIKit
import FlexLayout
import PinLayout
import RxCocoa
import RxSwift

/// 팀원의 요구사항(스펙)을 수정하는 VC
final class UpdateMemberRequirementViewController: BaseViewController {
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
    private let addTechStackButton = BridgeAddButton(titleFont: BridgeFont.body1.font)
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
    private let viewModel: UpdateMemberRequirementViewModel

    // MARK: - Init
    init(viewModel: UpdateMemberRequirementViewModel) {
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
        navigationItem.title = "모집글 수정"
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
                .alignItems(.center)
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
        let input = UpdateMemberRequirementViewModel.Input(
            viewDidLayoutSubviews: self.rx.viewDidLayoutSubviews.asObservable().take(1),
            recruitNumber: setRecruitmentNumberView.completeButtonTapped,
            techTags: addTechTagPopUpView.completeButtonTapped,
            requirementText: requirementTextView.resultText,
            nextButtonTapped: nextButton.rx.tap.asObservable()
        )
        let output = viewModel.transform(input: input)

        output.currentMemberRequirement
            .skip(1)
            .drive(onNext: { [weak self] requirement in
                guard let self else { return }

                // 분야
                self.fieldTagButton.updateTitle(
                    with: requirement.field.convertToDisplayFormat(), textColor: BridgeColor.primary1
                )
                self.fieldTagButton.flex.width(fieldTagButton.intrinsicContentSize.width).height(38).markDirty()

                // 기술 스택들의 분야
                self.addTechTagPopUpView.fieldUpdated.onNext(
                    TechStack(rawValue: requirement.field.convertToDisplayFormat())?.techStacks ?? []
                )

                // 모집 인원
                self.setRecruitNumberButton.updateTitle(
                    requirement.recruitNumber == 0 ? "몇 명을 모집할까요?" : "\(requirement.recruitNumber)명",
                    textColor: requirement.recruitNumber == 0 ? BridgeColor.gray04 : BridgeColor.gray02
                )

                // 기술 태그
                self.addTechStackButton.isAdded = true
                self.addedTechTagView.tagNames = requirement.requiredSkills
                self.addedTechTagView.flex.markDirty()

                // 바라는 점
                if !requirement.requirementText.isEmpty {
                    self.requirementTextView.text = requirement.requirementText
                }

                // 다음 버튼 활성화 여부
                // 바라는 점이 비어있다는 것은 아직 작성되지 않은 데이터 == 비활성화
                self.nextButton.isEnabled = !requirement.requirementText.isEmpty
                self.view.setNeedsLayout()
            })
            .disposed(by: disposeBag)

        // 다음 버튼 활성화
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
