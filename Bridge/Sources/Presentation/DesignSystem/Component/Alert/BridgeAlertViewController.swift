//
//  BridgeAlertViewController.swift
//  Bridge
//
//  Created by 정호윤 on 2023/09/27.
//

import UIKit
import PinLayout
import FlexLayout
import RxSwift

final class BridgeAlertViewController: BaseViewController {
    
    // MARK: - UI
    private lazy var rootFlexContainer: UIView = {
        let view = UIView()
        view.backgroundColor = BridgeColor.gray10
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = BridgeFont.subtitle1.font
        label.textColor = BridgeColor.gray1
        label.textAlignment = .center
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = BridgeFont.body2Long.font
        label.textColor = BridgeColor.gray4
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private lazy var leftButton = BridgeButton(title: "", font: BridgeFont.button2.font, backgroundColor: BridgeColor.gray4)
    private lazy var rightButton = BridgeButton(title: "", font: BridgeFont.button2.font, backgroundColor: BridgeColor.primary1)
    
    private var primaryAction: PrimaryActionClosure?
    
    // MARK: - Initializer
    init(configuration: AlertConfiguration, primaryAction: PrimaryActionClosure?) {
        self.primaryAction = primaryAction
        
        super.init()
        
        imageView.image = UIImage(named: configuration.imageName)?.withRenderingMode(.alwaysOriginal)
        titleLabel.text = configuration.title
        descriptionLabel.text = configuration.description
        leftButton.setTitle(configuration.leftButtonTitle, for: .normal)
        rightButton.setTitle(configuration.rightButtonTitle, for: .normal)
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = BridgeColor.backgroundBlur
        
        leftButton.rx.tap.asObservable()
            .withUnretained(self)
            .subscribe { owner, _ in
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
        rightButton.rx.tap.asObservable()
            .withUnretained(self)
            .subscribe { owner, _ in
                owner.dismiss(animated: true)
                if let primaryAction = owner.primaryAction { primaryAction() }
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - Configuartions
    override func configureLayouts() {
        view.addSubview(rootFlexContainer)
        
        rootFlexContainer.flex.justifyContent(.center).alignItems(.center).define { flex in
            flex.addItem().grow(1)  // spacer
            
            flex.addItem(imageView).size(100)
            
            flex.addItem()
                .alignItems(.center)
                .justifyContent(.center)
                .marginTop(10)
                .define { flex in
                    flex.addItem(titleLabel).marginBottom(4)
                    flex.addItem(descriptionLabel)
                }
            
            flex.addItem().grow(1)  // spacer
            
            flex.addItem().direction(.row).alignItems(.center).marginBottom(31).define { flex in
                flex.addItem(leftButton).width(123.5).height(44).marginRight(12)
                flex.addItem(rightButton).width(123.5).height(44)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        rootFlexContainer.pin.center().width(307).height(321)
        rootFlexContainer.flex.layout()
    }
}
