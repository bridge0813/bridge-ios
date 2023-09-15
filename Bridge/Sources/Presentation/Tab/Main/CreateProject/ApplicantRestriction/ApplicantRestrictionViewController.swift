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
    
    private let nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("다음", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        
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
        rootFlexContainer.flex.direction(.column).padding(5).alignItems(.center).define { flex in
            flex.addItem(instructionLabel).width(200).height(50).marginTop(100)
            flex.addItem(nextButton).width(50).height(50).marginTop(50)
        }
    }
    
    override func configureAttributes() {
        configureNavigationUI()
    }
    
    override func bind() {
        let input = ApplicantRestrictionViewModel.Input(
            nextButtonTapped: nextButton.rx.tap.asObservable()
        )
        let output = viewModel.transform(input: input)
    }
}