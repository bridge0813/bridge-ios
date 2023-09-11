//
//  SignInViewModel.swift
//  Bridge
//
//  Created by 정호윤 on 2023/09/08.
//

import RxSwift

final class SignInViewModel: ViewModelType {
    
    struct Input {
        let signInWithAppleButtonTapped: Observable<Void>?
    }
    
    struct Output {

    }
    
    let disposeBag = DisposeBag()
    
    weak var coordinator: AuthCoordinator?
    
    init(coordinator: AuthCoordinator) {
        self.coordinator = coordinator
    }
    
    func transform(input: Input) -> Output {
        input.signInWithAppleButtonTapped?
            .subscribe(onNext: { [weak self] in
                print("input: sign in with apple button tapped")
                self?.coordinator?.finish()  // 테스트용
            })
            .disposed(by: disposeBag)
        
        return Output()
    }
}
