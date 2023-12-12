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
        let applicantList: Driver<[ApplicantProfile]>
    }

    // MARK: - Property
    let disposeBag = DisposeBag()
    private weak var coordinator: ManagementCoordinator?
    
    private let projectID: Int
    private let fetchApplicantListUseCase: FetchApplicantListUseCase
    
    // MARK: - Init
    init(
        coordinator: ManagementCoordinator,
        projectID: Int,
        fetchApplicantListUseCase: FetchApplicantListUseCase
    ) {
        self.coordinator = coordinator
        self.projectID = projectID
        self.fetchApplicantListUseCase = fetchApplicantListUseCase
    }
    
    // MARK: - Transformation
    func transform(input: Input) -> Output {
        let applicantList = BehaviorRelay<[ApplicantProfile]>(value: [])
        
        input.viewWillAppear
            .withUnretained(self)
            .flatMapLatest { owner, _ in
                owner.fetchApplicantListUseCase.fetchApplicantList(projectID: owner.projectID).toResult()
            }
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                owner.handleFetchApplicantListResult(for: result, applicantList: applicantList)
            })
            .disposed(by: disposeBag)
        
        return Output(
            applicantList: applicantList.asDriver()
        )
    }
}

// MARK: - 네트워킹 결과처리
extension ApplicantListViewModel {
    /// 지원자 목록 조회 결과 처리
    func handleFetchApplicantListResult(
        for result: Result<[ApplicantProfile], Error>,
        applicantList: BehaviorRelay<[ApplicantProfile]>
    ) {
        switch result {
        case .success(let list):
            applicantList.accept(list)
            
        case .failure(let error):
            applicantList.accept([])
            coordinator?.showErrorAlert(configuration: ErrorAlertConfiguration(
                title: "지원자 목록을 조회하는데 실패했습니다",
                description: error.localizedDescription
            ))
        }
    }
}

// MARK: - Data source
extension ApplicantListViewModel {
    enum Section: CaseIterable {
        case main
    }
}
