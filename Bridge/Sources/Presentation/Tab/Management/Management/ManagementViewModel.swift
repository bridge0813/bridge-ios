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
        let managementTabButtonTapped: Observable<ManagementTabType>
        let filterActionTapped: Observable<String>
        let goToDetailButtonTapped: Observable<Int>
        let goToApplicantListButtonTapped: Observable<Int>
        let deleteButtonTapped: Observable<Int>
    }
    
    struct Output {
        let projects: Driver<[ProjectPreview]>
        let selectedTab: Driver<ManagementTabType>
        let filterOption: Driver<String>
    }

    // MARK: - Property
    let disposeBag = DisposeBag()
    private weak var coordinator: ManagementCoordinator?
    
    private let fetchAppliedProjectsUseCase: FetchAppliedProjectsUseCase
    private let fetchMyProjectsUseCase: FetchMyProjectsUseCase
    
    var selectedFilterOption: FilterMenuType = .all // 현재 선택된 필터링 옵션
    
    // MARK: - Init
    init(
        coordinator: ManagementCoordinator,
        fetchAppliedProjectsUseCase: FetchAppliedProjectsUseCase,
        fetchMyProjectsUseCase: FetchMyProjectsUseCase
    ) {
        self.coordinator = coordinator
        self.fetchAppliedProjectsUseCase = fetchAppliedProjectsUseCase
        self.fetchMyProjectsUseCase = fetchMyProjectsUseCase
    }
    
    // MARK: - Transformation
    func transform(input: Input) -> Output {
        let projects = BehaviorRelay<[ProjectPreview]>(value: [])
        let selectedTab = BehaviorRelay<ManagementTabType>(value: .apply)    // 현재 선택된 탭(지원 or 모집)
        
        // viewWillAppear 시점 데이터 가져오기
        input.viewWillAppear
            .withUnretained(self)
            .flatMapLatest { owner, _ -> Observable<Result<[ProjectPreview], Error>> in
                // 1. 지원 or 모집 탭 구분에 따라 데이터 가져오기
                if selectedTab.value == .apply {
                    return owner.fetchAppliedProjectsUseCase.fetchProjects().toResult()
                } else {
                    return owner.fetchMyProjectsUseCase.fetchProjects().toResult()
                }
            }
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .success(let projectList):
                    projects.accept(projectList)
                
                case .failure(let error):
                    projects.accept([])
                    owner.coordinator?.showErrorAlert(configuration: ErrorAlertConfiguration(
                        title: "오류",
                        description: error.localizedDescription
                    ))
                }
                
            })
            .disposed(by: disposeBag)
        
        // 지원 or 모집 탭 버튼 클릭
        input.managementTabButtonTapped
            .withUnretained(self)
            .flatMapLatest { owner, tabType -> Observable<Result<[ProjectPreview], Error>> in
                owner.selectedFilterOption = .all // 탭 전환 시 기본값으로 변경
                selectedTab.accept(tabType)
                
                if tabType == .apply {
                    return owner.fetchAppliedProjectsUseCase.fetchProjects().toResult()
                } else {
                    return owner.fetchMyProjectsUseCase.fetchProjects().toResult()
                }
            }
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .success(let projectList):
                    projects.accept(projectList)
                
                case .failure(let error):
                    projects.accept([])
                    owner.coordinator?.showErrorAlert(configuration: ErrorAlertConfiguration(
                        title: "오류",
                        description: error.localizedDescription
                    ))
                }
            })
            .disposed(by: disposeBag)
        
        // 필터 선택 처리
        let filterOption = input.filterActionTapped
            .do(onNext: { [weak self] option in
                guard let self else { return }
                
                self.selectedFilterOption = FilterMenuType(rawValue: option) ?? .all
                projects.accept(projects.value)
            })
        
        input.goToDetailButtonTapped
            .withUnretained(self)
            .subscribe(onNext: { owner, projectID in
                owner.coordinator?.connectToProjectDetailFlow(with: projectID)
            })
            .disposed(by: disposeBag)
        
        input.goToApplicantListButtonTapped
            .withUnretained(self)
            .subscribe(onNext: { owner, projectID in
                owner.coordinator?.showApplicantListViewController(with: projectID)
            })
            .disposed(by: disposeBag)
        
        input.deleteButtonTapped
            .withUnretained(self)
            .subscribe(onNext: { owner, projectID in
                owner.coordinator?.showAlert(configuration: .deleteProject)
            })
            .disposed(by: disposeBag)
        
        return Output(
            projects: projects.asDriver(onErrorJustReturn: [ProjectPreview.onError]),
            selectedTab: selectedTab.asDriver(onErrorJustReturn: .apply),
            filterOption: filterOption.asDriver(onErrorJustReturn: "오류")
        )
    }
}

// MARK: - Methods
extension ManagementViewModel {

}

// MARK: - Data source
extension ManagementViewModel {
    enum Section: CaseIterable {
        case main
    }
    
    enum ManagementTabType {
        case apply
        case recruitment
    }
    
    enum FilterMenuType: String {
        case all = "전체"
        case pendingResult = "결과 대기"
        case onGoing = "현재 진행"
        case complete = "완료"
    }
}
