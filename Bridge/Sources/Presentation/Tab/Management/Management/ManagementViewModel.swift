//
//  ManagementViewModel.swift
//  Bridge
//
//  Created by 엄지호 on 12/6/23.
//

import Foundation
import RxCocoa
import RxSwift

final class ManagementViewModel: ViewModelType {
    // MARK: - Input & Output
    struct Input {
        let viewWillAppear: Observable<Bool>
    }
    
    struct Output {
        
    }

    // MARK: - Property
    let disposeBag = DisposeBag()
    private weak var coordinator: ManagementCoordinator?
    
    // MARK: - Init
    init(
        coordinator: ManagementCoordinator
    ) {
        self.coordinator = coordinator
    }
    
    // MARK: - Transformation
    func transform(input: Input) -> Output {
        
        return Output(
            
        )
    }
}

// MARK: - Data source
extension ManagementViewModel {
    enum Section: CaseIterable {
        case main
    }
}
