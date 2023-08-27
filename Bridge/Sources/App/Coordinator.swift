//
//  Coordinator.swift
//  Bridge
//
//  Created by 정호윤 on 2023/08/25.
//

import UIKit

protocol CoordinatorDelegate: AnyObject {
    func didFinish(childCoordinator: Coordinator)
}

protocol Coordinator: AnyObject {
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
