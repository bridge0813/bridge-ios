//
//  ObservableType+.swift
//  Bridge
//
//  Created by 정호윤 on 11/8/23.
//
//  출처: https://okanghoon.medium.com/rxswift-5-error-handling-example-9f15176d11fc

import RxSwift

extension ObservableType {
    func toResult() -> Observable<Result<Element, Error>> {
        self
            .map { .success($0) }
            .catch { .just(.failure($0)) }
    }
}
