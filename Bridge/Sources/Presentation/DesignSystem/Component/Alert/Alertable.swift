//
//  Alertable.swift
//  Bridge
//
//  Created by 정호윤 on 2023/09/27.
//

import UIKit

protocol Alertable: AnyObject {
    func showAlert(target: UIViewController, configuration: AlertConfiguration)
}

extension Alertable {
    func showAlert(target: UIViewController, configuration: AlertConfiguration) {
        let alertViewController = BridgeAlertViewController(configuration: configuration)
        alertViewController.modalPresentationStyle = .overFullScreen
        alertViewController.modalTransitionStyle = .crossDissolve
        target.present(alertViewController, animated: true, completion: nil)
    }
}
