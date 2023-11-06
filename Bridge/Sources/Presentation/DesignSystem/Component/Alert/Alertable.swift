//
//  Alertable.swift
//  Bridge
//
//  Created by 정호윤 on 2023/09/27.
//
 
import UIKit

/// 알림창의 메인 액션을 정의하는 클로저 (e.g. 신고하기 등)
typealias PrimaryActionClosure = () -> Void

protocol Alertable: AnyObject {
    func showAlert(
        target: UIViewController,
        configuration: AlertConfiguration,
        primaryAction: PrimaryActionClosure?
    )
    
    func showErrorAlert(
        target: UIViewController,
        configuration: ErrorAlertConfiguration,
        primaryAction: PrimaryActionClosure?
    )
}

extension Alertable {
    func showAlert(target: UIViewController, configuration: AlertConfiguration, primaryAction: PrimaryActionClosure?) {
        let alertViewController = BridgeAlertViewController(configuration: configuration, primaryAction: primaryAction)
        alertViewController.modalPresentationStyle = .overFullScreen
        alertViewController.modalTransitionStyle = .crossDissolve
        target.present(alertViewController, animated: true, completion: nil)
    }
    
    func showErrorAlert(target: UIViewController, configuration: ErrorAlertConfiguration, primaryAction: PrimaryActionClosure?) {
        let alertViewController = BridgeErrorAlertViewController(configuration: configuration, primaryAction: primaryAction)
        alertViewController.modalPresentationStyle = .overFullScreen
        alertViewController.modalTransitionStyle = .crossDissolve
        target.present(alertViewController, animated: true, completion: nil)
    }
}
