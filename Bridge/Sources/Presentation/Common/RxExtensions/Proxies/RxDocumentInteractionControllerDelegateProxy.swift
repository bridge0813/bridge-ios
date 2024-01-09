//
//  RxDocumentInteractionControllerDelegateProxy.swift
//  Bridge
//
//  Created by 엄지호 on 1/8/24.
//

import UIKit
import RxCocoa
import RxSwift

// MARK: - Proxy
class RxDocumentInteractionControllerDelegateProxy:
    DelegateProxy<UIDocumentInteractionController, UIDocumentInteractionControllerDelegate>,
    DelegateProxyType {
    
    weak var previewController: UIViewController?
    
    init(controller: UIDocumentInteractionController) {
        super.init(parentObject: controller, delegateProxy: RxDocumentInteractionControllerDelegateProxy.self)
    }
    
//    deinit { didFinishPicking.onCompleted() }
    
    static func registerKnownImplementations() {
        register { RxDocumentInteractionControllerDelegateProxy(controller: $0) }
    }
    
    static func currentDelegate(for object: UIDocumentInteractionController) -> UIDocumentInteractionControllerDelegate? {
        object.delegate
    }
    
    static func setCurrentDelegate(_ delegate: UIDocumentInteractionControllerDelegate?, to object: UIDocumentInteractionController) {
        object.delegate = delegate
    }
}

// MARK: - Delegate
extension RxDocumentInteractionControllerDelegateProxy: UIDocumentInteractionControllerDelegate {
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        guard let previewController else { return UIViewController() }
        return previewController
    }
}

// MARK: - Reactive
extension Reactive where Base: UIDocumentInteractionController {
    func setPreviewController(_ controller: UIViewController) {
        RxDocumentInteractionControllerDelegateProxy.proxy(for: base).previewController = controller
    }
}
