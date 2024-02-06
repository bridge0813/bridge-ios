//
//  SearchProjectViewModel.swift
//  Bridge
//
//  Created by 엄지호 on 2/5/24.
//

import Foundation
import RxCocoa
import RxSwift

final class SearchProjectViewModel: ViewModelType {
    // MARK: - Input & Output
    struct Input {
        
    }
    
    struct Output {
        let projects: Driver<[ProjectPreview]>
    }

    // MARK: - Property
    let disposeBag = DisposeBag()
    private weak var coordinator: MainCoordinator?
    
    // MARK: - Init
    init(
        coordinator: MainCoordinator
    ) {
        self.coordinator = coordinator
    }
    
    // MARK: - Transformation
    func transform(input: Input) -> Output {
        let projectListRelay = BehaviorRelay<[ProjectPreview]>(value: [])
        
        return Output(
            projects: projectListRelay.asDriver()
        )
    }
}
