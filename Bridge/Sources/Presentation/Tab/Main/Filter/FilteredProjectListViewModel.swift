//
//  FilteredProjectListViewModel.swift
//  Bridge
//
//  Created by 엄지호 on 2/4/24.
//

import Foundation
import RxCocoa
import RxSwift

final class FilteredProjectListViewModel: ViewModelType {
    // MARK: - Input & Output
    struct Input {
        let viewWillAppear: Observable<Bool>
        let optionDeleteButtonTapped: Observable<String>
    }
    
    struct Output {
        let fieldTechStack: Driver<FieldTechStack>
        let projects: Driver<[ProjectPreview]>
    }

    // MARK: - Property
    let disposeBag = DisposeBag()
    private weak var coordinator: MainCoordinator?
    
    private let fieldTechStack: FieldTechStack
    private let fetchFilteredProjectsUseCase: FetchFilteredProjectsUseCase
    
    // MARK: - Init
    init(
        coordinator: MainCoordinator,
        fieldTechStack: FieldTechStack,
        fetchFilteredProjectsUseCase: FetchFilteredProjectsUseCase
    ) {
        self.coordinator = coordinator
        self.fieldTechStack = fieldTechStack
        self.fetchFilteredProjectsUseCase = fetchFilteredProjectsUseCase
    }
    
    // MARK: - Transformation
    func transform(input: Input) -> Output {
        let projectListRelay = BehaviorRelay<[ProjectPreview]>(value: [])
        let fieldTechStackRelay = BehaviorRelay<FieldTechStack>(value: fieldTechStack)
        
        input.viewWillAppear
            .withUnretained(self)
            .flatMapLatest { owner, _ -> Observable<Result<[ProjectPreview], Error>> in
                owner.fetchFilteredProjectsUseCase.fetch(filterBy: fieldTechStackRelay.value).toResult()
            }
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                owner.handleProjectFilteringResult(result, projectListRelay: projectListRelay)
            })
            .disposed(by: disposeBag)
        
        // 필터링 옵션 제거
        input.optionDeleteButtonTapped
            .withUnretained(self)
            .flatMap { owner, option -> Observable<Result<[ProjectPreview], Error>> in
                var updatedFieldTechStack = fieldTechStackRelay.value

                // 인덱스 체크
                guard let deletedIndex = updatedFieldTechStack.techStacks.firstIndex(where: { $0 == option })
                else { return .empty() }
                
                // 해당 옵션을 제거 및 업데이트
                updatedFieldTechStack.techStacks.remove(at: deletedIndex)
                fieldTechStackRelay.accept(updatedFieldTechStack)
            
                // 업데이트 된 내용을 통해 다시 필터링
                return owner.fetchFilteredProjectsUseCase.fetch(filterBy: fieldTechStackRelay.value).toResult()
            }
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                owner.handleProjectFilteringResult(result, projectListRelay: projectListRelay)
            })
            .disposed(by: disposeBag)
        
        
        return Output(
            fieldTechStack: fieldTechStackRelay.asDriver(),
            projects: projectListRelay.asDriver()
        )
    }
}

// MARK: - 네트워킹 결과 처리
extension FilteredProjectListViewModel {
    private func handleProjectFilteringResult(
        _ result: Result<[ProjectPreview], Error>,
        projectListRelay: BehaviorRelay<[ProjectPreview]>
    ) {
        switch result {
        case .success(let projects):
            projectListRelay.accept(projects)
            
        case .failure(let error):
            projectListRelay.accept([])
            coordinator?.showErrorAlert(configuration: ErrorAlertConfiguration(
                title: "모집글 조회에 실패했습니다.",
                description: error.localizedDescription
            ))
        }
    }
}


// MARK: - Data source
extension FilteredProjectListViewModel {
    enum FilterOptionSection: CaseIterable {
        case main
    }
}
