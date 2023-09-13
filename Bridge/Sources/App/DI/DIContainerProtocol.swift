//
//  DIContainerProtocol.swift
//  Bridge
//
//  Created by 엄지호 on 2023/09/13.
//

import Foundation

protocol DIContainerProtocol {
    func register<Service>(_ type: Service.Type, factory: @escaping () -> Service)
    func resolve<Service>(_ type: Service.Type) -> Service?
}
