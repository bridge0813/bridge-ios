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
    // MARK: - Properties
    private let rootFlexContainer = UIView()
   
    private let instructionLabel: UILabel = {
        let label = UILabel()
        label.configureLabel(
            textColor: .black,
            font: .boldSystemFont(ofSize: 18),
            numberOfLines: 2
        )
        label.text = "제한하고 싶은 \n팀원을 알려주세요!"
    
        return label
    }()
    
    private let studentButton = FieldTagButton(title: "학생")
    private let currentEmployeeButton = FieldTagButton(title: "현직자")
    private let jobSeekerButton = FieldTagButton(title: "취준생")
    
    private let nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("다음", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.white, for: .highlighted)
        button.backgroundColor = .darkGray
        
        return button
    }()

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
            flex.addItem(instructionLabel).marginHorizontal(10).marginTop(100)
            
            flex.addItem().direction(.column).marginTop(50).define { flex in
                flex.addItem(studentButton).size(studentButton.intrinsicContentSize).cornerRadius(8).marginLeft(10)
                
                flex.addItem().direction(.row).marginTop(10).define { flex in
                    flex.addItem(currentEmployeeButton).cornerRadius(8).marginLeft(10)
                    flex.addItem(jobSeekerButton).cornerRadius(8).marginLeft(10)
                }
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
        let input = ApplicantRestrictionViewModel.Input(
            nextButtonTapped: nextButton.rx.tap.asObservable(),
            studentButtonTapped: studentButton.rx.tap.map { "학생" },
            currentEmployeeButtonTapped: currentEmployeeButton.rx.tap.map { "현직자" },
            jobSeekerButtonTapped: jobSeekerButton.rx.tap.map { "취준생" }
        )
        
        let output = viewModel.transform(input: input)
    }
}
