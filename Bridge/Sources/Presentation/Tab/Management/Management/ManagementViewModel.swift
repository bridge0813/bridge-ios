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
        let managementTabButtonTapped: Observable<ManagementTapType>
        let filterMenuTapped: Observable<String>
    }
    
    struct Output {
        let currentTap: Driver<ManagementTapType>
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
        let currentTap = BehaviorRelay<ManagementTapType>(value: .apply)
        
        // 지원 or 모집 탭 버튼 클릭
        input.managementTabButtonTapped
            .withUnretained(self)
            .subscribe(onNext: { owner, tapType in
                switch tapType {
                case .apply:
                    currentTap.accept(.apply)
                    
                case .recruitment:
                    currentTap.accept(.recruitment)
                }
            })
            .disposed(by: disposeBag)
        
        
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
            currentTap: currentTap.asDriver(onErrorJustReturn: .apply)
        )
    }
}

// MARK: - Data source
extension ManagementViewModel {
    enum Section: CaseIterable {
        case main
    }
    
    enum ManagementTapType {
        case apply
        case recruitment
    }
}
