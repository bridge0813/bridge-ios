//
//  MyPageViewController.swift
//  Bridge
//
//  Created by 정호윤 on 11/6/23.
//

import UIKit
import FlexLayout
import PinLayout
import RxCocoa
import RxSwift

final class MyPageViewController: BaseViewController {
    // MARK: - UI
    private let bellButton: UIButton = {
        let button = UIButton()
        button.setImage(
            UIImage(named: "bell")?.resize(to: CGSize(width: 24, height: 24)),
            for: .normal
        )
        return button
    }()
    
    private let rootFlexContainer = UIView()
    
    private let signInButton = BridgeButton(
        title: "로그인",
        font: BridgeFont.button1.font,
        backgroundColor: BridgeColor.primary1
    )
    
    // MARK: - Property
    private let viewModel: MyPageViewModel
    
    // MARK: - Init
    init(viewModel: MyPageViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        configureDefaultNavigationBarAppearance()
    }
    
    // MARK: - Configuration
    override func configureAttributes() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: bellButton)
        
    }
    
    override func configureLayouts() {
        view.addSubview(rootFlexContainer)
        
        rootFlexContainer.flex.define { flex in
            flex.addItem().grow(1)
            flex.addItem(signInButton).width(343).height(45).alignSelf(.center)
            flex.addItem().grow(1)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        rootFlexContainer.pin.all(view.pin.safeArea)
        rootFlexContainer.flex.layout()
    }
    
    // MARK: - Binding
    override func bind() {
        let input = MyPageViewModel.Input(
            bellButtonTapped: bellButton.rx.tap.asObservable(),
            signIn: signInButton.rx.tap.asObservable()
        )
        _ = viewModel.transform(input: input)
    }
}
