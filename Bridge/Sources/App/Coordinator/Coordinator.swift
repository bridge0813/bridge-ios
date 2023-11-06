//
//  Coordinator.swift
//  Bridge
//
//  Created by 정호윤 on 2023/08/25.
//

import UIKit

protocol CoordinatorDelegate: AnyObject {
    func didFinish(childCoordinator: Coordinator)
    
    func showSignInViewController()
}

extension CoordinatorDelegate {
    func showSignInViewController() { }
}

protocol Coordinator: AnyObject, Alertable, BarAppearanceConfigurable {
    var delegate: CoordinatorDelegate? { get set }
    var navigationController: UINavigationController { get set }
    var childCoordinators: [Coordinator] { get set }
    
    init(navigationController: UINavigationController)
    
    func start()
    func finish()
}

extension Coordinator {
    func finish() {
        childCoordinators.removeAll()
        delegate?.didFinish(childCoordinator: self)
    }
}

// MARK: - Alert
extension Coordinator {
    func showAlert(configuration: AlertConfiguration, primaryAction: PrimaryActionClosure? = nil) {
        if let presentedViewContoller = navigationController.presentedViewController {
            showAlert(target: presentedViewContoller, configuration: configuration, primaryAction: primaryAction)
        } else {
            showAlert(target: navigationController, configuration: configuration, primaryAction: primaryAction)
        }
    }
    
    func showErrorAlert(configuration: ErrorAlertConfiguration, primaryAction: PrimaryActionClosure? = nil) {
        if let presentedViewContoller = navigationController.presentedViewController {
            showErrorAlert(target: presentedViewContoller, configuration: configuration, primaryAction: primaryAction)
        } else {
            showErrorAlert(target: navigationController, configuration: configuration, primaryAction: primaryAction)
        }
    }
}
