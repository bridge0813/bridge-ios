//
//  PrimitiveSequenceType+.swift
//  Bridge
//
//  Created by 정호윤 on 10/9/23.
//

import RxSwift

/// HTTP 네트워킹 에러를 위한 extension
extension PrimitiveSequenceType where Trait == SingleTrait {
    func toResult() -> Single<Result<Element, Error>> {
        self
            .map { .success($0) }
            .catch { .just(.failure($0)) }
    }
}
