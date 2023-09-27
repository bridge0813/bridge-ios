//
//  SignInViewController.swift
//  Bridge
//
//  Created by 정호윤 on 2023/09/07.
//

import AuthenticationServices
import UIKit
import PinLayout
import FlexLayout
import RxCocoa
import RxSwift

final class SignInViewController: BaseViewController {
    
    // MARK: - UI
    private let rootFlexViewContainer = UIView()
    
    private let signInWithAppleButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = .black
        configuration.attributedTitle = AttributedString(
            "Apple로 로그인",
            attributes: AttributeContainer([.font: BridgeFont.button1.font, .foregroundColor: UIColor.white])
        )
        configuration.image = UIImage(systemName: "apple.logo")
        configuration.imagePadding = 8
        configuration.imagePlacement = .leading
        return UIButton(configuration: configuration)
    }()

    private let viewModel: SignInViewModel
    
    init(viewModel: SignInViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Configurations
    override func configureAttributes() {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func configureLayouts() {
        view.addSubview(rootFlexViewContainer)
        
        rootFlexViewContainer.flex.direction(.column).justifyContent(.center).alignItems(.center).define { flex in
            flex.addItem(signInWithAppleButton).width(343).height(45)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        rootFlexViewContainer.pin.all()
        rootFlexViewContainer.flex.layout()
    }
    
    override func bind() {
        let input = SignInViewModel.Input(
            signInWithAppleButtonTapped: signInWithAppleButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(input: input)
    }
}
