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
    func showChannelViewController(of channel: Channel, navigationController: UINavigationController)
    func showProfileViewController(of userID: String, navigationController: UINavigationController)
}

extension CoordinatorDelegate {
    func showSignInViewController() { }
    func showChannelViewController(of channel: Channel, navigationController: UINavigationController) { }
    func showProfileViewController(of userID: String, navigationController: UINavigationController) { }
}

protocol Coordinator: AnyObject, Alertable {
    var delegate: CoordinatorDelegate? { get set }
    var navigationController: UINavigationController { get set }
    var childCoordinators: [Coordinator] { get set }
    
    init(navigationController: UINavigationController)
    
    func start()
    func finish()
    
    // 코디네이터를 종료(finish)하지 않고, 단순히 현재 뷰 컨트롤러를 내비게이션 스택에서 제거
    func pop()
    func dismiss()
}

extension Coordinator {
    func finish() {
        childCoordinators.removeAll()
        delegate?.didFinish(childCoordinator: self)
    }
    
    func pop() {
        navigationController.popViewController(animated: true)
    }
    
    func dismiss() {
        navigationController.dismiss(animated: true)
    }
}

// MARK: - Alert
extension Coordinator {
    func showAlert(
        configuration: AlertConfiguration,
        primaryAction: PrimaryActionClosure? = nil,
        cancelAction: CancelActionClosure? = nil
    ) {
        if let presentedViewContoller = navigationController.presentedViewController {
            showAlert(
                target: presentedViewContoller,
                configuration: configuration,
                primaryAction: primaryAction,
                cancelAction: cancelAction
            )
        } else {
            showAlert(
                target: navigationController,
                configuration: configuration,
                primaryAction: primaryAction,
                cancelAction: cancelAction
            )
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
