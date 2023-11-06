//
//  MyPageViewModel.swift
//  Bridge
//
//  Created by 정호윤 on 11/6/23.
//

import Foundation
import RxSwift

final class MyPageViewModel: ViewModelType {
    // MARK: - Input & Output
    struct Input {
        let signIn: Observable<Void>
    }
    
    struct Output { 
        
    }
    
    // MARK: - Property
    let disposeBag = DisposeBag()
    private weak var coordinator: MyPageCoordinator?
    
    // MARK: - Init
    init(coordinator: MyPageCoordinator) {
        self.coordinator = coordinator
    }
    
    // MARK: - Transformation
    func transform(input: Input) -> Output {
        input.signIn
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.coordinator?.showSignInViewController()
            })
            .disposed(by: disposeBag)
        
        return Output()
    }
}
