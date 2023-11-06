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
    private let rootFlexContainer = UIView()
    
    private let dismissButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "xmark")?.resize(to: CGSize(width: 24, height: 24)), for: .normal)
        return button
    }()
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo_for_sign_in")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let signInWithAppleButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = .black
        configuration.attributedTitle = AttributedString(
            "Apple로 로그인",
            attributes: AttributeContainer([.font: BridgeFont.button1.font, .foregroundColor: UIColor.white])
        )
        configuration.image = UIImage(systemName: "apple.logo")
        configuration.imagePadding = 12
        configuration.imagePlacement = .leading
        
        let button = UIButton(configuration: configuration)
        button.layer.cornerRadius = 6
        return button
    }()
    
    private let viewModel: SignInViewModel
    
    // MARK: - Init
    init(viewModel: SignInViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        configureDefaultNavigationBarAppearance()
    }
    
    // MARK: - Configurations
    override func configureAttributes() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: dismissButton)
        configureNoShadowNavigationBarAppearance()
    }
    
    override func configureLayouts() {
        view.addSubview(rootFlexContainer)
        
        rootFlexContainer.flex.justifyContent(.center).paddingHorizontal(16).define { flex in
            flex.addItem(logoImageView).width(147).height(30).alignSelf(.center)
            flex.addItem(signInWithAppleButton).height(45).marginTop(296)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        rootFlexContainer.pin.all()
        rootFlexContainer.flex.layout()
    }
    
    // MARK: - Binding
    override func bind() {
        let input = SignInViewModel.Input(
            dismissButtonTapped: dismissButton.rx.tap.asObservable(),
            signInWithAppleButtonTapped: signInWithAppleButton.rx.tap.asObservable()
        )
        _ = viewModel.transform(input: input)
    }
}
