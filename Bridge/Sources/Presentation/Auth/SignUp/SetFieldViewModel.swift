//
//  SetFieldViewModel.swift
//  Bridge
//
//  Created by 정호윤 on 2023/09/12.
//

import RxCocoa
import RxSwift

final class SetFieldViewModel: ViewModelType {
    
    struct Input {
        let fieldTagButtonTapped: Observable<String>
        let completeButtonTapped: Observable<Void>
    }
    
    struct Output {
        let isCompleteButtonEnabled: Driver<Bool>
    }
    
    let disposeBag = DisposeBag()
    
    weak var coordinator: AuthCoordinator?
    private let signUpUseCase: SignUpUseCase
    
    init(coordinator: AuthCoordinator, signUpUseCase: SignUpUseCase) {
        self.coordinator = coordinator
        self.signUpUseCase = signUpUseCase
    }
    
    func transform(input: Input) -> Output {
        let completeButtonEnabled = BehaviorSubject<Bool>(value: false)
        var selectedFields: Set<String> = []
        
        input.fieldTagButtonTapped
            .subscribe(onNext: { field in
                if selectedFields.contains(field) { selectedFields.remove(field) }
                else { selectedFields.insert(field) }
                
                completeButtonEnabled.onNext(!selectedFields.isEmpty)
            })
            .disposed(by: disposeBag)
        
        input.completeButtonTapped
            .withUnretained(self)
            .flatMap { owner, result in
                owner.signUpUseCase.signUp(selectedFields: selectedFields)
            }
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.coordinator?.finish()
            })
            .disposed(by: disposeBag)
        
        return Output(isCompleteButtonEnabled: completeButtonEnabled.asDriver(onErrorJustReturn: true))
    }
}
