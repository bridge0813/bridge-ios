//
//  ASAuthorizationController+Rx.swift
//  Bridge
//
//  Created by 정호윤 on 2023/09/12.
//

import AuthenticationServices
import RxCocoa
import RxSwift

// MARK: - Proxy
class ASAuthorizationControllerProxy:
    DelegateProxy<ASAuthorizationController, ASAuthorizationControllerDelegate>,
    DelegateProxyType {
    
    var didComplete = PublishSubject<ASAuthorization>()
    
    init(controller: ASAuthorizationController) {
        super.init(parentObject: controller, delegateProxy: ASAuthorizationControllerProxy.self)
    }
    
    deinit { didComplete.onCompleted() }
    
    static func registerKnownImplementations() {
        register { ASAuthorizationControllerProxy(controller: $0) }
    }
    
    static func currentDelegate(for object: ASAuthorizationController) -> ASAuthorizationControllerDelegate? {
        object.delegate
    }
    
    static func setCurrentDelegate(_ delegate: ASAuthorizationControllerDelegate?, to object: ASAuthorizationController) {
        object.delegate = delegate
    }
}

// MARK: - Delegate
extension ASAuthorizationControllerProxy: ASAuthorizationControllerDelegate {
    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) { 
        didComplete.onNext(authorization)
        didComplete.onCompleted()
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        if (error as NSError).code == ASAuthorizationError.canceled.rawValue {
            didComplete.onCompleted()
            return
        }
        
        didComplete.onError(error)
    }
}

// MARK: - Reactive
extension Reactive where Base: ASAuthorizationController {
    public var didComplete: Observable<ASAuthorization> {
        ASAuthorizationControllerProxy.proxy(for: base).didComplete.asObservable()
    }
}

extension Reactive where Base: ASAuthorizationAppleIDProvider {
    public func requestAuthorizationWithAppleID() -> Observable<ASAuthorization> {
        let appleIDProvider = base
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.performRequests()
        return authorizationController.rx.didComplete
    }
}
