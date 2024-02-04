//
//  URLSession+.swift
//  Bridge
//
//  Created by 엄지호 on 1/14/24.
//

import Foundation
import RxSwift
import RxCocoa

extension Reactive where Base: URLSession {
    func download(request: URLRequest) -> Observable<(response: HTTPURLResponse, localURL: URL)> {
        return Observable.create { observer in
            
            let task = self.base.downloadTask(with: request) { localURL, response, error in
                
                guard let response = response, let localURL = localURL else {
                    observer.on(.error(error ?? RxCocoaURLError.unknown))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    observer.on(.error(RxCocoaURLError.nonHTTPResponse(response: response)))
                    return
                }

                observer.on(.next((httpResponse, localURL)))
                observer.on(.completed)
            }

            task.resume()

            return Disposables.create(with: task.cancel)
        }
    }
}
