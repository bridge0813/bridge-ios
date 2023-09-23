//
//  ProjectOverviewInputViewController.swift
//  Bridge
//
//  Created by 엄지호 on 2023/09/11.
//

import UIKit
import FlexLayout
import PinLayout
import RxCocoa
import RxSwift

final class ProjectDescriptionInputViewController: BaseViewController {
    // MARK: - Properties
    private let rootFlexContainer = UIView()
   
    private let instructionLabel: UILabel = {
        let label = UILabel()
        label.configureLabel(
            textColor: .black,
            font: .boldSystemFont(ofSize: 18),
            numberOfLines: 2
        )
        label.text = "당신의 프로젝트를 \n소개해주세요!"
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private let titleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "글의 제목을 입력해주세요"
        textField.addLeftPadding()
        textField.leftViewMode = .always
        textField.layer.borderColor = UIColor.darkGray.cgColor
        textField.layer.borderWidth = 1
        
        return textField
    }()
    
    private let textViewContainer: UIView = {
        let container = UIView()
        container.layer.borderColor = UIColor.darkGray.cgColor
        container.layer.borderWidth = 1
        
        return container
    }()
    private let desriptionTextView: UITextView = {
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

    private let viewModel: ProjectDescriptionInputViewModel
    
    // MARK: - Initializer
    init(viewModel: ProjectDescriptionInputViewModel) {
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
            
            flex.addItem(titleTextField).marginHorizontal(15).height(50).cornerRadius(8).marginTop(50)
            
            flex.addItem(textViewContainer)
                .marginHorizontal(15)
                .height(150)
                .cornerRadius(8)
                .marginTop(50)
                .define { flex in
                    flex.addItem(desriptionTextView).grow(1).margin(10)
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
        let input = ProjectDescriptionInputViewModel.Input(
            nextButtonTapped: nextButton.rx.tap.asObservable(),
            titleTextChanged: titleTextField.rx.text.orEmpty.asObservable(),
            descriptionTextChanged: desriptionTextView.rx.text.orEmpty.asObservable()
        )
        let output = viewModel.transform(input: input)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
