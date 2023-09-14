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
    
    private let iosButton: UIButton = {
        let button = UIButton()
        
        var configuration = UIButton.Configuration.tinted()
        configuration.baseBackgroundColor = .lightGray

        button.configuration = configuration
        button.setTitle("iOS", for: .normal)
        button.setTitleColor(.darkGray, for: .normal)
        button.setTitleColor(.darkGray, for: .highlighted)
        
        return button
    }()
    
    private let androidButton: UIButton = {
        let button = UIButton()
        
        var configuration = UIButton.Configuration.tinted()
        configuration.baseBackgroundColor = .lightGray

        button.configuration = configuration
        button.setTitle("안드로이드", for: .normal)
        button.setTitleColor(.darkGray, for: .normal)
        button.setTitleColor(.darkGray, for: .highlighted)
        
        return button    }()
    
    private let frontEndButton: UIButton = {
        let button = UIButton()
        
        var configuration = UIButton.Configuration.tinted()
        configuration.baseBackgroundColor = .lightGray

        button.configuration = configuration
        button.setTitle("프론트엔드", for: .normal)
        button.setTitleColor(.darkGray, for: .normal)
        button.setTitleColor(.darkGray, for: .highlighted)
        
        return button
    }()
    
    private let backEndButton: UIButton = {
        let button = UIButton()
        
        var configuration = UIButton.Configuration.tinted()
        configuration.baseBackgroundColor = .lightGray

        button.configuration = configuration
        button.setTitle("백엔드", for: .normal)
        button.setTitleColor(.darkGray, for: .normal)
        button.setTitleColor(.darkGray, for: .highlighted)
        
        return button
    }()
    
    private let uiuxButton: UIButton = {
        let button = UIButton()
        
        var configuration = UIButton.Configuration.tinted()
        configuration.baseBackgroundColor = .lightGray

        button.configuration = configuration
        button.setTitle("UI/UX", for: .normal)
        button.setTitleColor(.darkGray, for: .normal)
        button.setTitleColor(.darkGray, for: .highlighted)
        
        return button
    }()
    
    private let bibxButton: UIButton = {
        let button = UIButton()
        
        var configuration = UIButton.Configuration.tinted()
        configuration.baseBackgroundColor = .lightGray

        button.configuration = configuration
        button.setTitle("BI/BX", for: .normal)
        button.setTitleColor(.darkGray, for: .normal)
        button.setTitleColor(.darkGray, for: .highlighted)
        
        return button
    }()
    
    private let videomotionButton: UIButton = {
        let button = UIButton()
        
        var configuration = UIButton.Configuration.tinted()
        configuration.baseBackgroundColor = .lightGray

        button.configuration = configuration
        button.setTitle("영상/모션", for: .normal)
        button.setTitleColor(.darkGray, for: .normal)
        button.setTitleColor(.darkGray, for: .highlighted)
        
        return button
    }()
    
    private let pmButton: UIButton = {
        let button = UIButton()
        
        var configuration = UIButton.Configuration.tinted()
        configuration.baseBackgroundColor = .lightGray

        button.configuration = configuration
        button.setTitle("PM", for: .normal)
        button.setTitleColor(.darkGray, for: .normal)
        button.setTitleColor(.darkGray, for: .highlighted)
        
        return button
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("다음", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.white, for: .highlighted)
        button.backgroundColor = .darkGray
        
        return button
    }()
    
    private let dismissButton: UIButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 23, weight: .regular, scale: .default)
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
            flex.addItem(dismissButton).position(.absolute).marginTop(25).marginLeft(10).size(25)
            
            flex.addItem(instructionLabel).width(200).height(50).marginTop(100).marginLeft(10)
            
            flex.addItem().direction(.column).marginTop(50).define { flex in
                flex.addItem().direction(.row).define { flex in
                    flex.addItem(iosButton).cornerRadius(8).marginLeft(10)
                    flex.addItem(androidButton).cornerRadius(8).marginLeft(10)
                }
                
                flex.addItem().direction(.row).marginTop(10).define { flex in
                    flex.addItem(frontEndButton).cornerRadius(8).marginLeft(10)
                    flex.addItem(backEndButton).cornerRadius(8).marginLeft(10)
                }
            }
            
            flex.addItem().direction(.column).marginTop(50).define { flex in
                flex.addItem().direction(.row).define { flex in
                    flex.addItem(uiuxButton).cornerRadius(8).marginLeft(10)
                    flex.addItem(bibxButton).cornerRadius(8).marginLeft(10)
                }
                
                flex.addItem().direction(.row).marginTop(10).define { flex in
                    flex.addItem(videomotionButton).cornerRadius(8).marginLeft(10)
                }
            }
            
            flex.addItem().direction(.row).marginTop(50).define { flex in
                flex.addItem(pmButton).cornerRadius(8).marginLeft(10)
            }
            
            flex.addItem().grow(1)
            
            flex.addItem().alignItems(.center).marginBottom(50).define { flex in
                flex.addItem(nextButton).width(280).height(50).cornerRadius(8)
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
