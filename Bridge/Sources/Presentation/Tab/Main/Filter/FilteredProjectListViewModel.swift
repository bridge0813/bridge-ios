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
        let projects = BehaviorRelay<[ProjectPreview]>(value: [])
        
        input.viewWillAppear
            .withUnretained(self)
            .flatMapLatest { owner, _ -> Observable<Result<[ProjectPreview], Error>> in
                owner.fetchFilteredProjectsUseCase.fetch(filterBy: owner.fieldTechStack).toResult()
            }
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .success(let projectList):
                    projects.accept(projectList)
                    
                case .failure(let error):
                    projects.accept([])
                    owner.coordinator?.showErrorAlert(configuration: ErrorAlertConfiguration(
                        title: "모집글 조회에 실패했습니다.",
                        description: error.localizedDescription
                    ))
                }
            })
            .disposed(by: disposeBag)
        
        
        return Output(
            fieldTechStack: .just(fieldTechStack),
            projects: projects.asDriver()
        )
    }
}
