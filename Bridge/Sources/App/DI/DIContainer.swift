//
//  DIContainer.swift
//  Bridge
//
//  Created by 엄지호 on 2023/09/13.
//

import Foundation

final class DIContainer {
    static let shared = DIContainer()
    
    private var services = [String: Any]()
    
    private init() { }
    
}

extension DIContainer: DIContainerProtocol {
    func register<Service>(_ type: Service.Type, factory: @escaping () -> Service) {
        let key = String(describing: type.self)
        services[key] = factory
    }
    
    func resolve<Service>(_ type: Service.Type) -> Service? {
        let key = String(describing: type.self)
        return services[key] as? Service
    }
}
