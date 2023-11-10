//
//  ProjectDetailViewModel.swift
//  Bridge
//
//  Created by 엄지호 on 2023/11/10.
//

import RxSwift
import RxCocoa

final class ProjectDetailViewModel: ViewModelType {
    // MARK: - Input & Output
    struct Input {
        let viewWillAppear: Observable<Bool>
    }
    
    struct Output {
        
    }
    
    // MARK: - Property
    let disposeBag = DisposeBag()
    
    // MARK: - Init
    // TODO: - 코디네이터 연결 처리
    init() {
        
    }
    
    // MARK: - Transformation
    func transform(input: Input) -> Output {
        
        return Output()
    }
}
