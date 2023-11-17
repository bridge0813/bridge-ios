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
        let goToDetailButtonTapped: Observable<Void>
        let menuTapped: Observable<String>
        let applyButtonTapped: Observable<Void>
        let bookmarkButtonTapped: Observable<Bool>
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
        let projectDetail = projectDetailUseCase.fetchProjectDetail(with: 0)  // ID 받아서 처리
        
        input.goToDetailButtonTapped
            .withLatestFrom(projectDetail)
            .withUnretained(self)
            .subscribe(onNext: { owner, projectDetail in
                owner.coordinator?.showRecruitFieldDetailViewController(with: projectDetail)
            })
            .disposed(by: disposeBag)
        
        input.menuTapped
            .withUnretained(self)
            .subscribe(onNext: { owner, menu in
                switch menu {
                case "수정": owner.coordinator?.showAlert(configuration: .editProject)
                case "마감": owner.coordinator?.showAlert(configuration: .closeProject)
                case "삭제": owner.coordinator?.showAlert(configuration: .deleteProject)
                default: print("Error")
                }
            })
            .disposed(by: disposeBag)
        
        input.applyButtonTapped
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.coordinator?.showAlert(configuration: .apply)
            })
            .disposed(by: disposeBag)
        
        input.bookmarkButtonTapped
            .withUnretained(self)
            .subscribe(onNext: { owner, isSelected in
                if isSelected {
                    // 스크랩
                } else {
                    // 스크랩 취소
                }
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
