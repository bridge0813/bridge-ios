//
//  SignUpCoordinator.swift
//  Bridge
//
//  Created by 정호윤 on 2023/09/08.
//

import UIKit

protocol SignupCoordinatorProtocol: Coordinator {
    
}

final class SignUpCoordinator: SignupCoordinatorProtocol {
    
    weak var delegate: CoordinatorDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator]
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.childCoordinators = []
    }
    
    func start() {
        
    }
}

extension SignUpCoordinator {
    
}
