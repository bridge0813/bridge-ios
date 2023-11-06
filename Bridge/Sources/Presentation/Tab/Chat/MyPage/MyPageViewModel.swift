//
//  MyPageViewModel.swift
//  Bridge
//
//  Created by 정호윤 on 11/6/23.
//

import Foundation
import RxSwift

final class MyPageViewModel: ViewModelType {

    struct Input { 
        let signIn: Observable<Void>
    }
    
    struct Output { 
        
    }
    
    let disposeBag = DisposeBag()
    
    private weak var coordinator: MyPageCoordinator?
    
    init(coordinator: MyPageCoordinator) {
        self.coordinator = coordinator
    }
    
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
