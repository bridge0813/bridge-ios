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
        let fieldTagButtonTapped: Observable<FieldTagButtonType>
        let completeButtonTapped: Observable<Void>
    }
    
    struct Output {
        let isCompleteButtonEnabled: Driver<Bool>
    }
    
    let disposeBag = DisposeBag()
    
    weak var coordinator: AuthCoordinator?
    
    init(coordinator: AuthCoordinator) {
        self.coordinator = coordinator
    }
    
    func transform(input: Input) -> Output {
        let completeButtonEnabled = BehaviorSubject<Bool>(value: false)
        var selectedFields: Set<String> = []
        
        input.fieldTagButtonTapped
            .subscribe(onNext: { fieldTagButtonType in
                let field = fieldTagButtonType.rawValue
                
                if selectedFields.contains(field) { selectedFields.remove(field) }
                else { selectedFields.insert(field) }
                
                completeButtonEnabled.onNext(!selectedFields.isEmpty)
            })
            .disposed(by: disposeBag)
        
        input.completeButtonTapped
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                // TODO: 데이터 전송
                owner.coordinator?.finish()
            })
            .disposed(by: disposeBag)
        
        return Output(isCompleteButtonEnabled: completeButtonEnabled.asDriver(onErrorJustReturn: true))
    }
}
