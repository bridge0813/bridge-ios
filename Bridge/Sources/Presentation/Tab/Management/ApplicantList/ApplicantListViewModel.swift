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
        let nameButtonTapped: Observable<ApplicantID>
        let startChatButtonTapped: Observable<ApplicantProfile>
        let acceptButtonTapped: Observable<ApplicantID>
        let rejectButtonTapped: Observable<ApplicantID>
    }
    
    struct Output {
        let applicantList: Driver<[ApplicantProfile]>
    }

    // MARK: - Property
    let disposeBag = DisposeBag()
    private weak var coordinator: ManagementCoordinator?
    
    private let projectID: Int
    private let fetchApplicantListUseCase: FetchApplicantListUseCase
    private let acceptApplicantUseCase: AcceptApplicantUseCase
    private let rejectApplicantUseCase: RejectApplicantUseCase
    private let createChannelUseCase: CreateChannelUseCase
    
    // MARK: - Init
    init(
        coordinator: ManagementCoordinator,
        projectID: Int,
        fetchApplicantListUseCase: FetchApplicantListUseCase,
        acceptApplicantUseCase: AcceptApplicantUseCase,
        rejectApplicantUseCase: RejectApplicantUseCase,
        createChannelUseCase: CreateChannelUseCase
    ) {
        self.coordinator = coordinator
        self.projectID = projectID
        self.fetchApplicantListUseCase = fetchApplicantListUseCase
        self.acceptApplicantUseCase = acceptApplicantUseCase
        self.rejectApplicantUseCase = rejectApplicantUseCase
        self.createChannelUseCase = createChannelUseCase
    }
    
    // MARK: - Transformation
    func transform(input: Input) -> Output {
        let applicantList = BehaviorRelay<[ApplicantProfile]>(value: [])
        
        // 지원자 목록 가져오기
        input.viewWillAppear
            .withUnretained(self)
            .flatMapLatest { owner, _ in
                return owner.fetchApplicantListUseCase.fetch(projectID: owner.projectID).toResult()
            }
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                owner.handleFetchApplicantListResult(for: result, applicantList: applicantList)
            })
            .disposed(by: disposeBag)
        
        // 수락 처리
        input.acceptButtonTapped
            .withUnretained(self)
            .flatMap { owner, applicantID -> Maybe<ApplicantID> in
                // 수락 Alert을 보여주고, 유저가 "수락하기" 를 클릭했을 경우 이벤트를 전달.
                owner.confirmActionWithAlert(applicantID: applicantID, alertConfiguration: .accept)
            }
            .withUnretained(self)
            .flatMap { owner, applicantID -> Observable<Result<ApplicantID, Error>> in
                // 수락 진행
                owner.acceptApplicantUseCase.accept(projectID: owner.projectID, applicantID: applicantID).toResult()
            }
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                owner.handleApplicationDecisionResult(
                    for: result,
                    applicantList: applicantList
                )
            })
            .disposed(by: disposeBag)
        
        // 거절 처리
        input.rejectButtonTapped
            .withUnretained(self)
            .flatMap { owner, applicantID -> Maybe<ApplicantID> in
                // 거절 Alert을 보여주고, 유저가 "거절하기" 를 클릭했을 경우 이벤트를 전달.
                owner.confirmActionWithAlert(applicantID: applicantID, alertConfiguration: .refuse)
            }
            .withUnretained(self)
            .flatMap { owner, applicantID -> Observable<Result<ApplicantID, Error>> in
                // 거절 진행
                owner.rejectApplicantUseCase.reject(projectID: owner.projectID, applicantID: applicantID).toResult()
            }
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                owner.handleApplicationDecisionResult(
                    for: result,
                    applicantList: applicantList
                )
            })
            .disposed(by: disposeBag)
        
        // 채팅방 개설 후 채팅방 이동
        input.startChatButtonTapped
            .withUnretained(self)
            .flatMapLatest { owner, applicantProfile in
                owner.createChannelUseCase.create(opponentID: applicantProfile.userID)
                    .toResult()
                    .map { result in (result, applicantProfile) }
            }
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { owner, resultAndProfile in
                let (result, applicantProfile) = resultAndProfile
                
                switch result {
                case .success(let channel):
                    var updatedChannel = channel
                    updatedChannel.name = applicantProfile.name
                    owner.coordinator?.showChannelViewController(of: updatedChannel)
                    
                case .failure(let error):
                    owner.coordinator?.showErrorAlert(configuration: ErrorAlertConfiguration(
                        title: "채팅방 개설에 실패했습니다.",
                        description: error.localizedDescription
                    ))
                }
            })
            .disposed(by: disposeBag)
        
        input.nameButtonTapped
            .withUnretained(self)
            .subscribe(onNext: { owner, userID in
                owner.coordinator?.showProfileViewController(of: String(userID))
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
    
    /// 지원에 대한 수락 or 거절(의사 결정)의 결과 처리
    private func handleApplicationDecisionResult(
        for result: Result<ApplicantID, Error>,
        applicantList: BehaviorRelay<[ApplicantProfile]>
    ) {
        switch result {
        case .success(let applicantID):
            var currentApplicantList = applicantList.value
            
            if let deletedIndex = currentApplicantList.firstIndex(where: { $0.userID == applicantID }) {
                currentApplicantList.remove(at: deletedIndex)
                applicantList.accept(currentApplicantList)
            }
            
        case .failure(let error):
            coordinator?.showErrorAlert(configuration: ErrorAlertConfiguration(
                title: "오류",
                description: error.localizedDescription
            ))
            
        }
    }
}

// MARK: - Alert 대응 처리
extension ApplicantListViewModel {
    /// 특정 작업의 수행을 확인하는 Alert을 보여주고, 유저의 액션에 따라 이벤트의 전달여부를 결정
    private func confirmActionWithAlert(applicantID: Int, alertConfiguration: AlertConfiguration) -> Maybe<ApplicantID> {
        Maybe<ApplicantID>.create { [weak self] maybe in
            guard let self else {
                maybe(.completed)
                return Disposables.create()
            }
            
            self.coordinator?.showAlert(
                configuration: alertConfiguration,
                primaryAction: {
                    maybe(.success(applicantID))
                },
                cancelAction: {
                    maybe(.completed)
                }
            )
            
            return Disposables.create()
        }
    }
}

// MARK: - Data source
extension ApplicantListViewModel {
    enum Section: CaseIterable {
        case main
    }
}
