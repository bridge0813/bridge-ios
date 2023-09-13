//
//  SelectFieldViewModel.swift
//  Bridge
//
//  Created by 정호윤 on 2023/09/12.
//

import RxSwift

final class SelectFieldViewModel: ViewModelType {
    
    struct Input {
        let completeButtonTapped: Observable<Void>
    }
    
    struct Output {
        
    }
    
    let disposeBag = DisposeBag()
    
    weak var coordinator: AuthCoordinator?
    
    init(coordinator: AuthCoordinator) {
        self.coordinator = coordinator
    }
    
    func transform(input: Input) -> Output {
        input.completeButtonTapped
            .withUnretained(self)
            .subscribe(onNext: { owner, authorization in
                owner.coordinator?.finish()  // 테스트용
            })
            .disposed(by: disposeBag)
        
        return Output()
    }
}
