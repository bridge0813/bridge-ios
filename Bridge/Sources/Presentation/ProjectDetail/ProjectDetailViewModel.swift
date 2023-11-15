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
        let viewDidLoad: Observable<Void>
        let goToDetailButtonTapped: Observable<Void>
        let editButtonTapped: Observable<Void>
        let closeButtonTapped: Observable<Void>
        let deleteButtonTapped: Observable<Void>
    }
    
    struct Output {
        let projectDetail: Driver<ProjectDetail>
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
        let projectDetail = input.viewDidLoad
            .withUnretained(self)
            .flatMap { owner, _ in
                owner.projectDetailUseCase.fetchProjectDetail(with: 0)  // ID 받아서 처리
            }
        
        input.goToDetailButtonTapped
            .withLatestFrom(projectDetail)
            .withUnretained(self)
            .subscribe(onNext: { owner, projectDetail in
                owner.coordinator?.showRecruitFieldDetailViewController(with: projectDetail)
            })
            .disposed(by: disposeBag)
        
        input.editButtonTapped
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.coordinator?.showAlert(configuration: .editProject)
            })
            .disposed(by: disposeBag)
        
        input.closeButtonTapped
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.coordinator?.showAlert(configuration: .closeProject)
            })
            .disposed(by: disposeBag)
        
        input.deleteButtonTapped
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.coordinator?.showAlert(configuration: .deleteProject)
            })
            .disposed(by: disposeBag)
        
        return Output(projectDetail: projectDetail.asDriver(onErrorJustReturn: ProjectDetail.onError))
    }
}

// MARK: - Data source
extension ProjectDetailViewModel {
    enum Section: CaseIterable {
        case main
    }
}
