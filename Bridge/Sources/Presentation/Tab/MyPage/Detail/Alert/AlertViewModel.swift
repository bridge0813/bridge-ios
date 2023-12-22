//
//  AlertViewModel.swift
//  Bridge
//
//  Created by 정호윤 on 12/14/23.
//

import RxSwift
import RxCocoa

final class AlertViewModel: ViewModelType {
    // MARK: - Input & Output
    struct Input {
        let viewWillAppear: Observable<Bool>
        let removeAlert: Observable<Int>
    }
    
    struct Output {
        let alerts: BehaviorRelay<[BridgeAlert]>
    }
    
    // MARK: - Property
    let disposeBag = DisposeBag()
    private weak var coordinator: MyPageCoordinator?
    private let fetchAlertsUseCase: FetchAlertsUseCase
    private let removeAlertsUseCase: RemoveAlertUseCase
    
    // MARK: - Init
    init(
        coordinator: MyPageCoordinator?,
        fetchAlertsUseCase: FetchAlertsUseCase,
        removeAlertsUseCase: RemoveAlertUseCase
    ) {
        self.coordinator = coordinator
        self.fetchAlertsUseCase = fetchAlertsUseCase
        self.removeAlertsUseCase = removeAlertsUseCase
    }
    
    // MARK: - Transformation
    func transform(input: Input) -> Output {
        let alertsRelay = BehaviorRelay<[BridgeAlert]>(value: [])
        
        return Output(
            alerts: alertsRelay
        )
    }
}
