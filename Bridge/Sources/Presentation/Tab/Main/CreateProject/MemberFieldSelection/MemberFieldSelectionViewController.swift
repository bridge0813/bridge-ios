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
    // MARK: - Properties
    private let rootFlexContainer = UIView()
   
    private let instructionLabel: UILabel = {
        let label = UILabel()
        label.configureLabel(
            textColor: .black,
            font: .boldSystemFont(ofSize: 18),
            numberOfLines: 2
        )
        label.text = "어떤 분야의 팀원을 \n찾고 있나요?"
        
        return label
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("다음", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        
        return button
    }()
    
    private let dismissButton: UIButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .regular, scale: .default)
        let buttonImage = UIImage(systemName: "xmark", withConfiguration: imageConfig)
        button.setImage(buttonImage, for: .normal)
        button.tintColor = .black
        
        return button
    }()

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
            flex.addItem(dismissButton).position(.absolute).marginTop(25).marginLeft(17).size(25)
            
            flex.addItem().alignItems(.center).marginTop(50).define { flex in
                flex.addItem(instructionLabel).width(200).height(50)
                flex.addItem(nextButton).width(50).height(50).marginTop(30)
            }
        }
    }
    
    override func configureAttributes() {
        configureNavigationUI()
    }
    
    override func bind() {
        let input = MemberFieldSelectionViewModel.Input(
            nextButtonTapped: nextButton.rx.tap.asObservable(),
            dismissButtonTapped: dismissButton.rx.tap.asObservable()
        )
        let output = viewModel.transform(input: input)
    }
}