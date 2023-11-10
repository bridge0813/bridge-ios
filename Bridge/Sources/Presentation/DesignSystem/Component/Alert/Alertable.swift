//
//  Alertable.swift
//  Bridge
//
//  Created by 정호윤 on 2023/09/27.
//
 
import UIKit

/// 알림창의 메인 액션을 정의하는 클로저 (e.g. 신고하기 등)
typealias PrimaryActionClosure = () -> Void

/// 알림창의 취소 액션을 정의하는 클로저
typealias CancelActionClosure = () -> Void

protocol Alertable: AnyObject {
    func showAlert(
        target: UIViewController,
        configuration: AlertConfiguration,
        primaryAction: PrimaryActionClosure?,
        cancelAction: CancelActionClosure?
    )
    func showErrorAlert(target: UIViewController, configuration: ErrorAlertConfiguration)
}

extension Alertable {
    func showAlert(
        target: UIViewController,
        configuration: AlertConfiguration,
        primaryAction: PrimaryActionClosure?,
        cancelAction: CancelActionClosure?
    ) {
        let alertViewController = BridgeAlertViewController(
            configuration: configuration,
            primaryAction: primaryAction,
            cancelAction: cancelAction
        )
        alertViewController.modalPresentationStyle = .overFullScreen
        alertViewController.modalTransitionStyle = .crossDissolve
        target.present(alertViewController, animated: true, completion: nil)
    }
    
    func showErrorAlert(target: UIViewController, configuration: ErrorAlertConfiguration) {
        let alertViewController = BridgeErrorAlertViewController(configuration: configuration)
        alertViewController.modalPresentationStyle = .overFullScreen
        alertViewController.modalTransitionStyle = .crossDissolve
        target.present(alertViewController, animated: true, completion: nil)
    }
}
