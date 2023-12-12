//
//  ApplicantListViewModel.swift
//  Bridge
//
//  Created by 엄지호 on 12/12/23.
//

import Foundation
import RxCocoa
import RxSwift

final class ApplicantListViewModel: ViewModelType {
    // MARK: - Input & Output
    struct Input {
        let viewWillAppear: Observable<Bool>
        
    }
    
    struct Output {
        
    }

    // MARK: - Property
    let disposeBag = DisposeBag()
    private weak var coordinator: ManagementCoordinator?
    
    private let projectID: Int
    
    // MARK: - Init
    init(
        coordinator: ManagementCoordinator,
        projectID: Int
    ) {
        self.coordinator = coordinator
        self.projectID = projectID
    }
    
    // MARK: - Transformation
    func transform(input: Input) -> Output {
        // viewWillAppear 시점 데이터 가져오기
//        input.viewWillAppear
//            .withUnretained(self)
//            .flatMapLatest { owner, _ in
//                
//            }
//            .withUnretained(self)
//            .subscribe(onNext: { owner, result in
//               
//            })
//            .disposed(by: disposeBag)
//        
        return Output(
            
        )
    }
}

// MARK: - 네트워킹 결과처리
extension ApplicantListViewModel {
   
}

// MARK: - Data source
extension ApplicantListViewModel {
    enum Section: CaseIterable {
        case main
    }
}
