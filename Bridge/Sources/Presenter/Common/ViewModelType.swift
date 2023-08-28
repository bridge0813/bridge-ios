//
//  ViewModelType.swift
//  Bridge
//
//  Created by 정호윤 on 2023/08/28.
//

import RxSwift

protocol ViewModelType: AnyObject {
    associatedtype Input
    associatedtype Output
    
    var disposeBag: DisposeBag { get }
    
    func transform(input: Input) -> Output
}
