//
//  MemberDetailInputViewModel.swift
//  Bridge
//
//  Created by 엄지호 on 2023/09/11.
//

import RxSwift
import RxCocoa

final class MemberDetailInputViewModel: ViewModelType {
    // MARK: - Nested Types
    struct Input {
        let nextButtonTapped: Observable<Void>
    }
    
    struct Output {
        let selectedField: Driver<String>
    }
    
    // MARK: - Properties
    let disposeBag = DisposeBag()
    private weak var coordinator: CreateProjectCoordinator?
    
    private var selectedFields: [String]
    
    // MARK: - Initializer
    init(
        coordinator: CreateProjectCoordinator,
        selectedFields: [String]
    ) {
        self.coordinator = coordinator
        self.selectedFields = selectedFields
    }
    
    // MARK: - Methods
    func transform(input: Input) -> Output {
        input.nextButtonTapped
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                let updateFields = owner.selectedFields.removeFirst()
                
                if owner.selectedFields.isEmpty {
                    owner.coordinator?.showApplicantRestrictionViewController()
                } else {
                    owner.coordinator?.showMemberDetailInputViewController(for: owner.selectedFields)
                }
            })
            .disposed(by: disposeBag)
        
        /// 선택된 분야들 중 가장 첫 번째만 가져옴.
        let selectedField = Observable.just(selectedFields.first ?? "").asDriver(onErrorJustReturn: "")
        
        return Output(selectedField: selectedField)
    }
}
