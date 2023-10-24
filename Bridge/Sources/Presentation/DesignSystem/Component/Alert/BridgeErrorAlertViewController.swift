//
//  BridgeErrorAlertViewController.swift
//  Bridge
//
//  Created by 정호윤 on 10/24/23.
//

import UIKit
import PinLayout
import FlexLayout
import RxSwift

final class BridgeErrorAlertViewController: BaseViewController {
    
    // MARK: - UI
    private lazy var rootFlexContainer: UIView = {
        let view = UIView()
        view.backgroundColor = BridgeColor.backgroundBlur
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        return view
    }()
    
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = BridgeColor.gray10
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        return view
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
    
    // MARK: - Initializer
    init(configuration: ErrorAlertConfiguration) {
        super.init()
        titleLabel.text = configuration.title
        descriptionLabel.text = configuration.description
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backgroundTapped)))
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
                
                flex.addItem().alignItems(.center).justifyContent(.center).paddingVertical(40).define { flex in
                    flex.addItem(titleLabel)
                    flex.addItem(descriptionLabel).marginTop(6).isIncludedInLayout(descriptionLabel.text?.isEmpty != nil)
                }
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        rootFlexContainer.pin.all()
        rootFlexContainer.flex.layout()
    }
}
