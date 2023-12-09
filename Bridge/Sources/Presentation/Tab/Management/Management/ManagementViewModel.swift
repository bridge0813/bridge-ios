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
        let projects: Driver<[ProjectPreview]>
        let selectedTap: Driver<ManagementTapType>
    }

    // MARK: - Property
    let disposeBag = DisposeBag()
    private weak var coordinator: ManagementCoordinator?
    
    private let fetchApplyProjectsUseCase: FetchApplyProjectsUseCase
    private let fetchMyProjectsUseCase: FetchMyProjectsUseCase
    
    var selectedFilterOption: FilterMenuType = .all // 현재 선택된 필터링 옵션
    
    // MARK: - Init
    init(
        coordinator: ManagementCoordinator,
        fetchApplyProjectsUseCase: FetchApplyProjectsUseCase,
        fetchMyProjectsUseCase: FetchMyProjectsUseCase
    ) {
        self.coordinator = coordinator
        self.fetchApplyProjectsUseCase = fetchApplyProjectsUseCase
        self.fetchMyProjectsUseCase = fetchMyProjectsUseCase
    }
    
    // MARK: - Transformation
    func transform(input: Input) -> Output {
        let projects = BehaviorRelay<[ProjectPreview]>(value: [])
        let selectedTap = BehaviorRelay<ManagementTapType>(value: .apply)    // 현재 선택된 탭(지원 or 모집)
        
        // 1. 지원 or 모집 탭 구분에 따라 데이터 가져오기
        // 2. 성공 or 실패에 따라 처리
        // 3. 성공일 경우, 현재 선택된 필터옵션에 따라 가져온 모집글 필터링.
        input.viewWillAppear
            .withUnretained(self)
            .flatMapLatest { owner, _ -> Observable<Result<[ProjectPreview], Error>> in
                if selectedTap.value == .apply {
                    return owner.fetchApplyProjectsUseCase.fetchProjects().toResult()
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
            .flatMapLatest { owner, tapType -> Observable<Result<[ProjectPreview], Error>> in
                owner.selectedFilterOption = .all // 탭 전환 시 기본값으로 변경
                selectedTap.accept(tapType)
                
                if tapType == .apply {
                    return owner.fetchApplyProjectsUseCase.fetchProjects().toResult()
                } else {
                    return owner.fetchMyProjectsUseCase.fetchProjects().toResult()
                }
            }
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .success(let projectPreviews):
                    projects.accept(projectPreviews)
                
                case .failure(let error):
                    projects.accept([])
                    owner.coordinator?.showErrorAlert(configuration: ErrorAlertConfiguration(
                        title: "오류",
                        description: error.localizedDescription
                    ))
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
            projects: projects.asDriver(onErrorJustReturn: [ProjectPreview.onError]),
            selectedTap: selectedTap.asDriver(onErrorJustReturn: .apply)
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
    
    enum ManagementTapType {
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
