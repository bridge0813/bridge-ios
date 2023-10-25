//
//  MemberFieldSelectionViewController.swift
//  Bridge
//
//  Created by 엄지호 on 2023/09/11.
//

import UIKit
import FlexLayout
import PinLayout
import RxCocoa
import RxSwift

final class MemberFieldSelectionViewController: BaseViewController {
    // MARK: - UI
    private lazy var dismissButton: UIBarButtonItem = {
        let image = UIImage(named: "xmark")?.resize(to: CGSize(width: 24, height: 24))
        let button = UIBarButtonItem(
            image: image,
            style: .done,
            target: self,
            action: nil
        )
        return button
    }()
    
    private let rootFlexContainer = UIView()
    
    private let progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.progress = 0.2
        progressView.progressTintColor = BridgeColor.primary1
        progressView.backgroundColor = BridgeColor.gray7
        
        return progressView
    }()
    
    private let dividerView: UIView = {
        let divider = UIView()
        divider.backgroundColor = BridgeColor.gray6
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
        label.configureTextWithLineHeight(text: "어떤 분야의 팀원을\n찾고 있나요?", lineHeight: 30)
        label.font = BridgeFont.headline1Long.font
        label.textColor = BridgeColor.gray1
        label.numberOfLines = 2
        
        return label
    }()
    
    private let tipMessageBox = BridgeTipMessageBox("복수 선택이 가능해요")
    
    private let setFieldView = BridgeSetFieldView()
    
    private let nextButton = BridgeButton(
        title: "다음",
        font: BridgeFont.button1.font,
        backgroundColor: BridgeColor.gray4
    )
    
    // MARK: - Properties
    private let viewModel: MemberFieldSelectionViewModel
    
    // MARK: - Initializer
    init(viewModel: MemberFieldSelectionViewModel) {
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
        
        // 130은 스크롤 뷰의 스크롤이 가장 아래로 내려갔을 때, padding 값(피그마 스크롤 처리 참고).
        scrollView.contentSize = CGSize(
            width: scrollView.frame.width,
            height: contentContainer.frame.height + 130
        )
    }
    
    // MARK: - Methods
    private func configureNavigationUI() {
        navigationItem.leftBarButtonItem = dismissButton
        navigationItem.title = "모집글 작성"
    }
    
    override func configureLayouts() {
        view.addSubview(rootFlexContainer)
        scrollView.addSubview(contentContainer)
        
        rootFlexContainer.flex.define { flex in
            flex.addItem(progressView).height(6).marginTop(10).marginHorizontal(16)
            
            flex.addItem(dividerView).height(1).marginTop(18)
            
            flex.addItem().grow(1)  // ScrollView의 사이즈만큼 빈 공간.
            
            // grow(1)로 레이아웃을 배치하면, height가 원활하게 잡히지 않고 화면 밖을 벗어나는 문제가 발생.(디바이스)
            flex.addItem(scrollView).position(.absolute).width(100%).top(35).bottom(84).marginHorizontal(16)
            
            flex.addItem(nextButton).height(52).marginBottom(24).marginHorizontal(16)
        }
        
        contentContainer.flex.define { flex in
            flex.addItem(descriptionLabel).width(148).height(60).marginTop(16)
            flex.addItem(tipMessageBox).height(38).marginTop(16)
            flex.addItem(setFieldView).height(396).marginTop(40)
        }
    }
    
    override func configureAttributes() {
        configureNavigationUI()
    }
    
    override func bind() {
        let input = MemberFieldSelectionViewModel.Input(
            dismissButtonTapped: dismissButton.rx.tap.asObservable(),
            fieldTagButtonTapped: setFieldView.fieldTagButtonTapped,
            nextButtonTapped: nextButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        output.isNextButtonEnabled
            .drive(onNext: { [weak self] isCompleteButtonEnabled in
                self?.nextButton.isEnabled = isCompleteButtonEnabled
            })
            .disposed(by: disposeBag)
        
        scrollView.rx.contentOffset.asDriver()
            .drive(onNext: { [weak self] offSet in
                let shouldHidden = offSet.y > 0
                self?.dividerView.isHidden = !shouldHidden
            })
            .disposed(by: disposeBag)
    }
}
