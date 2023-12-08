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
        let filterMenuTapped: Observable<String>
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
        
        input.filterMenuTapped
            .withUnretained(self)
            .subscribe(onNext: { owner, filterMenu in
                switch filterMenu {
                case "전체": print("전체")
                case "결과 대기": print("결과 대기")
                case "완료": print("완료")
                case "현재 진행": print("현재 진행")
                default: print("Error")
                }
            })
            .disposed(by: disposeBag)
        
        
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
