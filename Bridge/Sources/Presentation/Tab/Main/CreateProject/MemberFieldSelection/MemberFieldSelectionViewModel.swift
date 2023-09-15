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
        let tagButtonTapped: Observable<TagButtonType>
        
    }
    
    struct Output {
        let selectedTag: Driver<TagButtonType>
    }
    
    // MARK: - Properties
    let disposeBag = DisposeBag()
    private weak var coordinator: CreateProjectCoordinator?
    
    private var selectedButtonTypes: [TagButtonType] = []
    
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
        
        let selectedTag = input.tagButtonTapped
            .withUnretained(self)
            .flatMap { owner, type in
                if let index = owner.selectedButtonTypes.firstIndex(of: type) {
                    owner.selectedButtonTypes.remove(at: index)
                } else {
                    owner.selectedButtonTypes.append(type)
                }
                
                return Observable.just(type)
            }
            .asDriver(onErrorJustReturn: TagButtonType.iOS)
        
        return Output(
            selectedTag: selectedTag
        )
    }
}

// MARK: - UI DataSource
extension MemberFieldSelectionViewModel {
    enum TagButtonType {
        case iOS, android, frontEnd, backEnd, uiux, bibx, videomotion, pm
    }
}
