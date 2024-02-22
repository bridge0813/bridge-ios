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
        let alerts: Driver<[BridgeAlert]>
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
                owner.fetchAlertsUseCase.fetch().toResult()
            }
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .success(let alertList):
                    alertsRelay.accept(alertList)
                    
                case .failure(let error):
                    owner.coordinator?.showErrorAlert(configuration: ErrorAlertConfiguration(
                        title: "조회에 실패했습니다.",
                        description: error.localizedDescription
                    ))
                }
            })
            .disposed(by: disposeBag)
        
        input.removeAllAlert
            .withUnretained(self)
            .flatMap { owner, _ in
                owner.removeAlertUseCase.removeAll().toResult()
            }
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .success:
                    alertsRelay.accept([])
                    
                case .failure(let error):
                    owner.coordinator?.showErrorAlert(configuration: ErrorAlertConfiguration(
                        title: "알림 제거에 실패했습니다.",
                        description: error.localizedDescription
                    ))
                }
            })
            .disposed(by: disposeBag)
        
        input.removeAlert
            .withLatestFrom(alertsRelay) { index, currentAlerts in
                currentAlerts[index].id
            }
            .withUnretained(self)
            .flatMap { owner, id in
                owner.removeAlertUseCase.remove(id: id).toResult()
            }
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .success(let alertID):
                    var updatedAlertList = alertsRelay.value
                    
                    if let deletedAlertIndex = updatedAlertList.firstIndex(where: { $0.id == alertID }) {
                        updatedAlertList.remove(at: deletedAlertIndex)
                        alertsRelay.accept(updatedAlertList)
                    }
                    
                case .failure(let error):
                    owner.coordinator?.showErrorAlert(configuration: ErrorAlertConfiguration(
                        title: "알림 제거에 실패했습니다.",
                        description: error.localizedDescription
                    ))
                }
            })
            .disposed(by: disposeBag)
    
        return Output(
            alerts: alertsRelay.asDriver()
        )
    }
}
