//
//  MemberFieldSelectionViewModel.swift
//  Bridge
//
//  Created by 엄지호 on 2023/09/11.
//

import RxSwift
import RxCocoa

final class MemberFieldSelectionViewModel: ViewModelType {
    // MARK: - Nested Types
    struct Input {
        let nextButtonTapped: Observable<Void>
        let dismissButtonTapped: Observable<Void>
        let fieldButtonTapped: Observable<RecruitFieldType>
    }
    
    struct Output {
        let selectedField: Driver<RecruitFieldType>
    }
    
    // MARK: - Properties
    let disposeBag = DisposeBag()
    private weak var coordinator: CreateProjectCoordinator?
    
    private var selectedButtonTypes: [RecruitFieldType] = []
    
    // MARK: - Initializer
    init(
        coordinator: CreateProjectCoordinator
    ) {
        self.coordinator = coordinator
    }
    
    // MARK: - Methods
    func transform(input: Input) -> Output {
        input.nextButtonTapped
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.coordinator?.showMemberDetailInputViewController()
            })
            .disposed(by: disposeBag)
        
        input.dismissButtonTapped
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.coordinator?.finish()
            })
            .disposed(by: disposeBag)
        
        let selectedField = input.fieldButtonTapped
            .withUnretained(self)
            .flatMap { owner, type in
                if let index = owner.selectedButtonTypes.firstIndex(of: type) {
                    owner.selectedButtonTypes.remove(at: index)
                } else {
                    owner.selectedButtonTypes.append(type)
                }
                
                return Observable.just(type)
            }
            .asDriver(onErrorJustReturn: RecruitFieldType.iOS)
        
        return Output(
            selectedField: selectedField
        )
    }
}

// MARK: - UI DataSource
extension MemberFieldSelectionViewModel {
    enum RecruitFieldType {
        case iOS, android, frontEnd, backEnd, uiux, bibx, videomotion, pm
    }
}
