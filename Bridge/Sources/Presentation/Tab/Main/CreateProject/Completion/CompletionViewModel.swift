//
//  CompletionViewModel.swift
//  Bridge
//
//  Created by 엄지호 on 2023/09/11.
//

import RxSwift
import RxCocoa

final class CompletionViewModel: ViewModelType {
    // MARK: - Input & Output
    struct Input {
        let completeButtonTapped: ControlEvent<Void>
    }
    
    struct Output {
        
    }
    
    // MARK: - Property
    let disposeBag = DisposeBag()
    private weak var coordinator: CreateProjectCoordinator?
    private let projectId: Int  // 작성한 모집글을 확인할 때, 전달
    
    // MARK: - Init
    init(
        coordinator: CreateProjectCoordinator,
        projectId: Int
    ) {
        self.coordinator = coordinator
        self.projectId = projectId
    }
    
    // MARK: - Transformation
    func transform(input: Input) -> Output {
        input.completeButtonTapped
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                // TODO: - ProjectID 전달
                owner.coordinator?.showAlert(configuration: .checkProject, cancelAction: {
                    owner.coordinator?.finish()
                })
            })
            .disposed(by: disposeBag)
        
        return Output()
    }
}
