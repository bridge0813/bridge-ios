//
//  RxPHPickerControllerDelegateProxy.swift
//  Bridge
//
//  Created by 엄지호 on 1/7/24.
//

import PhotosUI
import RxCocoa
import RxSwift

// MARK: - Proxy
class RxPHPickerControllerDelegateProxy:
    DelegateProxy<PHPickerViewController, PHPickerViewControllerDelegate>,
    DelegateProxyType {
    
    var didFinishPicking = PublishSubject<UIImage?>()
    
    init(controller: PHPickerViewController) {
        super.init(parentObject: controller, delegateProxy: RxPHPickerControllerDelegateProxy.self)
    }
    
    deinit { didFinishPicking.onCompleted() }
    
    static func registerKnownImplementations() {
        register { RxPHPickerControllerDelegateProxy(controller: $0) }
    }
    
    static func currentDelegate(for object: PHPickerViewController) -> PHPickerViewControllerDelegate? {
        object.delegate
    }
    
    static func setCurrentDelegate(_ delegate: PHPickerViewControllerDelegate?, to object: PHPickerViewController) {
        object.delegate = delegate
    }
}

// MARK: - Delegate
extension RxPHPickerControllerDelegateProxy: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        let itemProvider = results.first?.itemProvider
        
        if let itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, _ in
                guard let self else { return }
                didFinishPicking.onNext(image as? UIImage)
            }
        }
    }
}

// MARK: - Reactive
extension Reactive where Base: PHPickerViewController {
    var didFinishPicking: Observable<UIImage?> {
        RxPHPickerControllerDelegateProxy.proxy(for: base).didFinishPicking.asObserver()
    }
}
