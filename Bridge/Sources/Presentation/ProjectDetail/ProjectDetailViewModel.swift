//
//  ProjectDetailViewModel.swift
//  Bridge
//
//  Created by 엄지호 on 2023/11/10.
//

import RxSwift
import RxCocoa

final class ProjectDetailViewModel: ViewModelType {
    // MARK: - Input & Output
    struct Input {
        let viewWillAppear: Observable<Bool>
        let goToDetailButtonTapped: ControlEvent<Void>?
    }
    
    struct Output {
        let project: Driver<Project>
    }
    
    // MARK: - Property
    let disposeBag = DisposeBag()
    private weak var coordinator: ProjectDetailCoordinator?
    private let projectDetailUseCase: FetchProjectDetailUseCase
    
    // MARK: - Init
    init(
        coordinator: ProjectDetailCoordinator,
        projectDetailUseCase: FetchProjectDetailUseCase
    ) {
        self.coordinator = coordinator
        self.projectDetailUseCase = projectDetailUseCase
    }
    
    // MARK: - Transformation
    func transform(input: Input) -> Output {
        let project = input.viewWillAppear
            .withUnretained(self)
            .flatMap { owner, _ in
                owner.projectDetailUseCase.fetchProject(with: 0)  // ID 받아서 처리
            }
        
        input.goToDetailButtonTapped?
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                // 임시
                owner.coordinator?.showRecruitFieldDetailViewController(with: [])
            })
            .disposed(by: disposeBag)
        
        return Output(project: project.asDriver(onErrorJustReturn: Project.onError))
    }
}
