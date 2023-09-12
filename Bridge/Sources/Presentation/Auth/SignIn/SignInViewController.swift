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
        let button = UIButton()
        button.setTitle("로그인", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
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
    override func configureLayouts() {
        view.addSubview(rootFlexViewContainer)
        
        rootFlexViewContainer.flex
            .direction(.column)
            .justifyContent(.center)
            .alignItems(.center)
            .define { flex in
                flex.addItem(signInWithAppleButton).size(100)
            }
    }
    
    override func viewDidLayoutSubviews() {
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
