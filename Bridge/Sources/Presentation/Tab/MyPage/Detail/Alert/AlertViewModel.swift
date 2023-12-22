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
        let removeAllAlert: Observable<Void>
        let removeAlert: Observable<Int>
    }
    
    struct Output {
        let alerts: BehaviorRelay<[BridgeAlert]>
    }
    
    // MARK: - Property
    let disposeBag = DisposeBag()
    private weak var coordinator: MyPageCoordinator?
    private let fetchAlertsUseCase: FetchAlertsUseCase
    private let removeAlertUseCase: RemoveAlertUseCase
    
    // MARK: - Init
    init(
        coordinator: MyPageCoordinator?,
        fetchAlertsUseCase: FetchAlertsUseCase,
        removeAlertUseCase: RemoveAlertUseCase
    ) {
        self.coordinator = coordinator
        self.fetchAlertsUseCase = fetchAlertsUseCase
        self.removeAlertUseCase = removeAlertUseCase
    }
    
    // MARK: - Transformation
    func transform(input: Input) -> Output {
        let alertsRelay = BehaviorRelay<[BridgeAlert]>(value: [])
        
        input.viewWillAppear
            .withUnretained(self)
            .flatMap { owner, _ in
                owner.fetchAlertsUseCase.fetch()
            }
            .bind(to: alertsRelay)
            .disposed(by: disposeBag)
        
        input.removeAllAlert
            .withUnretained(self)
            .flatMap { owner, _ in
                owner.removeAlertUseCase.removeAll()
            }            
            .withUnretained(self)
            .flatMap { owner, _ in
                owner.fetchAlertsUseCase.fetch()
            }
            .bind(to: alertsRelay)
            .disposed(by: disposeBag)
        
        input.removeAlert
            .withLatestFrom(alertsRelay) { index, currentAlerts in
                currentAlerts[index].id
            }
            .withUnretained(self)
            .flatMap { owner, id in
                owner.removeAlertUseCase.remove(id: id)
            }
            .withUnretained(self)
            .flatMap { owner, _ in
                owner.fetchAlertsUseCase.fetch()
            }
            .bind(to: alertsRelay)
            .disposed(by: disposeBag)
        
        return Output(
            alerts: alertsRelay
        )
    }
}
