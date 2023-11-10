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
        view.backgroundColor = BridgeColor.backgroundBlur
        return view
    }()
    
    private let backgroundView: UIView = {
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
        label.textColor = BridgeColor.gray01
        label.textAlignment = .center
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = BridgeFont.body2Long.font
        label.textColor = BridgeColor.gray04
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private lazy var leftButton = BridgeButton(title: "", font: BridgeFont.button2.font, backgroundColor: BridgeColor.gray04)
    private lazy var rightButton = BridgeButton(title: "", font: BridgeFont.button2.font, backgroundColor: BridgeColor.primary1)
    
    private var primaryAction: PrimaryActionClosure?
    private var cancelAction: CancelActionClosure?
    
    // MARK: - Initializer
    init(
        configuration: AlertConfiguration,
        primaryAction: PrimaryActionClosure?,
        cancelAction: CancelActionClosure?
    ) {
        self.primaryAction = primaryAction
        self.cancelAction = cancelAction
        
        super.init()
        
        if let imageName = configuration.imageName {
            imageView.image = UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal)
        } else {
            imageView.isHidden = true
        }
        titleLabel.text = configuration.title
        descriptionLabel.text = configuration.description
        leftButton.setTitle(configuration.leftButtonTitle, for: .normal)
        rightButton.setTitle(configuration.rightButtonTitle, for: .normal)
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backgroundTapped)))
        
        leftButton.rx.tap.asObservable()
            .withUnretained(self)
            .subscribe { owner, _ in
                owner.dismiss(animated: true)
                if let cancelAction = owner.cancelAction { cancelAction() }
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
    
    @objc private func backgroundTapped(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: view)
        
        if !backgroundView.frame.contains(location) {
            dismiss(animated: true)
        }
    }
    
    // MARK: - Configuartions
    override func configureLayouts() {
        view.addSubview(rootFlexContainer)
        
        rootFlexContainer.flex.justifyContent(.center).alignItems(.center).define { flex in
            flex.addItem(backgroundView).justifyContent(.center).alignItems(.center).width(307).define { flex in
                
                flex.addItem().size(40)
                
                flex.addItem(imageView).size(100).marginBottom(10).isIncludedInLayout(!imageView.isHidden)
                
                flex.addItem().alignItems(.center).justifyContent(.center).marginBottom(30).define { flex in
                    flex.addItem(titleLabel)
                    flex.addItem(descriptionLabel).marginTop(6).isIncludedInLayout(descriptionLabel.text?.isEmpty != nil)
                }
                
                flex.addItem().direction(.row).define { flex in
                    flex.addItem(leftButton).width(123.5).height(44).marginRight(12)
                    flex.addItem(rightButton).width(123.5).height(44)
                }
                
                flex.addItem().size(30)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        rootFlexContainer.pin.all()
        rootFlexContainer.flex.layout()
    }
}
