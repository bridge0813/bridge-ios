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
        let goToDetailButtonTapped: Observable<Void>
        let editProjectActionTapped: Observable<String>
        let applyButtonTapped: Observable<Void>
        let bookmarkButtonTapped: Observable<Bool>
        let viewDidDisappear: Observable<Bool>
    }
    
    struct Output {
        let project: Driver<Project>
    }
    
    // MARK: - Property
    let disposeBag = DisposeBag()
    private weak var coordinator: ProjectDetailCoordinator?
    
    private let projectID: Int
    private let projectDetailUseCase: FetchProjectDetailUseCase
    
    // MARK: - Init
    init(
        coordinator: ProjectDetailCoordinator,
        projectID: Int,
        projectDetailUseCase: FetchProjectDetailUseCase
    ) {
        self.coordinator = coordinator
        self.projectID = projectID
        self.projectDetailUseCase = projectDetailUseCase
    }
    
    // MARK: - Transformation
    func transform(input: Input) -> Output {
        let project = BehaviorRelay<Project>(value: Project.onError)
        var signInNeeded = false  // 로그인 체크
        
        input.viewWillAppear
            .withUnretained(self)
            .flatMap { owner, _ in
                owner.projectDetailUseCase.fetchProjectDetail(with: owner.projectID).toResult()
            }
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .success(let data):
                    project.accept(data.0)
                    signInNeeded = data.1
                    
                case .failure(let error):
                    owner.coordinator?.showErrorAlert(
                        configuration: ErrorAlertConfiguration(
                            title: "오류",
                            description: error.localizedDescription
                        ),
                        primaryAction: {
                            owner.coordinator?.pop()
                        }
                    )
                }
            })
            .disposed(by: disposeBag)
        
        input.goToDetailButtonTapped
            .withLatestFrom(project)
            .withUnretained(self)
            .subscribe(onNext: { owner, project in
                owner.coordinator?.showRecruitFieldDetailViewController(with: project)
            })
            .disposed(by: disposeBag)
        
        input.editProjectActionTapped
            .withUnretained(self)
            .subscribe(onNext: { owner, menu in
                switch menu {
                case "수정하기": owner.coordinator?.showAlert(configuration: .editProject)
                case "마감하기": owner.coordinator?.showAlert(configuration: .closeProject)
                case "삭제하기": owner.coordinator?.showAlert(configuration: .deleteProject)
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
        
        input.viewDidDisappear
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                if let didFinish = owner.coordinator?.didFinishEventClosure {
                    didFinish()
                }
            })
            .disposed(by: disposeBag)
        
        return Output(project: project.asDriver(onErrorJustReturn: Project.onError))
    }
}

// MARK: - Data source
extension ProjectDetailViewModel {
    enum Section: CaseIterable {
        case main
    }
}
