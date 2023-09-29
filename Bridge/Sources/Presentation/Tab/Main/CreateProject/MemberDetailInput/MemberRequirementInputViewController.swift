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

final class MemberRequirementInputViewController: BaseViewController {
    // MARK: - Properties
    private let rootFlexContainer = UIView()
   
    private let instructionLabel: UILabel = {
        let label = UILabel()
        label.configureLabel(
            textColor: .black,
            font: .boldSystemFont(ofSize: 18),
            numberOfLines: 2
        )
        label.text = "당신이 찾고 있는 팀원의 \n정보를 알려주세요!"
    
        return label
    }()

    private let selectedFieldLabel: UILabel = {
        let label = UILabel()
        label.configureLabel(
            textColor: .orange,
            font: .boldSystemFont(ofSize: 15),
            textAlignment: .center
        )
        label.layer.borderColor = UIColor.orange.cgColor
        label.layer.borderWidth = 1
    
        return label
    }()

    private let recruitNumberButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .boldSystemFont(ofSize: 13)
        button.setTitle("몇 명을 모집할까요?", for: .normal)
        button.setTitleColor(.darkGray, for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.darkGray.cgColor
        
        return button
    }()
    private let swiftButton = FieldTagButton("Swift")
    private let uIkitButton = FieldTagButton("UIKit")
    private let mvvmButton = FieldTagButton("MVVM")
    
    private let textViewContainer: UIView = {
        let container = UIView()
        container.layer.borderColor = UIColor.darkGray.cgColor
        container.layer.borderWidth = 1
        
        return container
    }()
    private let requirementsTextView: UITextView = {
        let textView = UITextView()
        textView.showsVerticalScrollIndicator = false
        textView.returnKeyType = .next
        textView.textColor = .black
        
        return textView
    }()
    private let nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("다음", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.white, for: .highlighted)
        button.backgroundColor = .darkGray
        
        return button
    }()

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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureNavigationUI()
    }
    
    override func viewDidLayoutSubviews() {
        rootFlexContainer.pin.all(view.pin.safeArea).marginTop(10)
        rootFlexContainer.flex.layout()
    }
    
    // MARK: - Methods
    private func configureNavigationUI() {
    }
    
    override func configureLayouts() {
        view.addSubview(rootFlexContainer)
        rootFlexContainer.flex.direction(.column).padding(5).define { flex in
            flex.addItem(instructionLabel).marginHorizontal(10).marginTop(20)
            
            flex.addItem(selectedFieldLabel).width(100).height(40).cornerRadius(8).marginTop(50).marginLeft(10)
            
            flex.addItem(recruitNumberButton).width(150).height(40).cornerRadius(8).marginTop(50).marginLeft(10)
            
            flex.addItem().direction(.row).marginTop(50).define { flex in
                flex.addItem(swiftButton).cornerRadius(8).marginLeft(10)
                flex.addItem(uIkitButton).cornerRadius(8).marginLeft(10)
                flex.addItem(mvvmButton).cornerRadius(8).marginLeft(10)
            }
            
            flex.addItem(textViewContainer)
                .marginHorizontal(15)
                .height(200)
                .cornerRadius(8)
                .marginTop(50)
                .define { flex in
                    flex.addItem(requirementsTextView).margin(10)
                }
            
            flex.addItem().grow(1)
            
            flex.addItem().marginBottom(50).define { flex in
                flex.addItem(nextButton).marginHorizontal(15).height(50).cornerRadius(8)
            }
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
            skillTagButtonTapped: .just(["Swift", "UIKit", "MVVM"]),
            requirementsTextChanged: requirementsTextView.rx.didEndEditing
                .withLatestFrom(requirementsTextView.rx.text.orEmpty)
                .distinctUntilChanged()
        )
        let output = viewModel.transform(input: input)
        
        output.selectedField
            .drive(onNext: { [weak self] field in
                self?.selectedFieldLabel.text = field
                // 분야에 맞는 기술 스택 주입.
            })
            .disposed(by: disposeBag)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
