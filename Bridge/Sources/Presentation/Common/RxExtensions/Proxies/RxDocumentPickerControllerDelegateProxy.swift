//
//  RxDocumentPickerControllerDelegateProxy.swift
//  Bridge
//
//  Created by 엄지호 on 1/8/24.
//

import MobileCoreServices
import RxCocoa
import RxSwift
import UIKit

// MARK: - Proxy
class RxDocumentPickerControllerDelegateProxy:
    DelegateProxy<UIDocumentPickerViewController, UIDocumentPickerDelegate>,
    DelegateProxyType {
    
    var didFinishPicking = PublishSubject<Result<ReferenceFile, FileProcessingError>>()
    
    init(controller: UIDocumentPickerViewController) {
        super.init(parentObject: controller, delegateProxy: RxDocumentPickerControllerDelegateProxy.self)
    }
    
    deinit { didFinishPicking.onCompleted() }
    
    static func registerKnownImplementations() {
        register { RxDocumentPickerControllerDelegateProxy(controller: $0) }
    }
    
    static func currentDelegate(for object: UIDocumentPickerViewController) -> UIDocumentPickerDelegate? {
        object.delegate
    }
    
    static func setCurrentDelegate(_ delegate: UIDocumentPickerDelegate?, to object: UIDocumentPickerViewController) {
        object.delegate = delegate
    }
}

// MARK: - Delegate
extension RxDocumentPickerControllerDelegateProxy: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let selectedFileURL = urls.first else { return }
        let fileName = selectedFileURL.lastPathComponent

        // 접근권한 요청
        let canAccess = selectedFileURL.startAccessingSecurityScopedResource()
        
        guard canAccess else {
            didFinishPicking.onNext(.failure(FileProcessingError.accessRestriction))
            return
        }
        
        // File URL -> Data 전환
        DispatchQueue.global().async { [weak self] in
            do {
                let fileData = try Data(contentsOf: selectedFileURL)
                let file = ReferenceFile(url: selectedFileURL.absoluteString, fileName: fileName, fileData: fileData)
                self?.didFinishPicking.onNext(.success(file))
                
            } catch {
                self?.didFinishPicking.onNext(.failure(FileProcessingError.conversionFailed))
            }
            
            selectedFileURL.stopAccessingSecurityScopedResource() // 접근 해제
        }
    }
}

// MARK: - Reactive
extension Reactive where Base: UIDocumentPickerViewController {
    var didFinishPicking: Observable<Result<ReferenceFile, FileProcessingError>> {
        RxDocumentPickerControllerDelegateProxy.proxy(for: base).didFinishPicking.asObserver()
    }
}

// MARK: - Error
enum FileProcessingError: Error {
    case accessRestriction
    case conversionFailed
}

extension FileProcessingError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .accessRestriction:
            return "해당 파일에 접근이 제한되어있습니다."
            
        case .conversionFailed:
            return "파일 전환에 실패했습니다."
        }
    }
}
