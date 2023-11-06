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
        return view
    }()
    
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = BridgeColor.gray10
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = BridgeFont.subtitle2.font
        label.textColor = BridgeColor.gray01
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = BridgeFont.body2Long.font
        label.textColor = BridgeColor.gray02
        label.numberOfLines = 0
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
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(alertTapped)))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) { [weak self] in
            self?.dismiss(animated: true)
        }
    }
    
    @objc private func alertTapped(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: view)
        
        if backgroundView.frame.contains(location) {
            dismiss(animated: true)
        }
    }
    
    // MARK: - Configuartions
    override func configureLayouts() {
        view.addSubview(rootFlexContainer)
        
        rootFlexContainer.flex.justifyContent(.end).alignItems(.center).define { flex in
            flex.addItem(backgroundView).padding(20, 16).marginBottom(34).width(343).define { flex in
                flex.addItem(titleLabel)
                flex.addItem(descriptionLabel).marginTop(6).isIncludedInLayout(descriptionLabel.text?.isEmpty != nil)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        rootFlexContainer.pin.all()
        rootFlexContainer.flex.layout()
    }
}
