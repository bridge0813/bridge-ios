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
        let projectManagementActionTapped: Observable<String>
        let applyButtonTapped: Observable<Void>
        let bookmarkButtonTapped: Observable<Void>
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
    private let bookmarkUseCase: BookmarkUseCase
    private let applyUseCase: ApplyProjectUseCase
    private let deleteUseCase: DeleteProjectUseCase
    private let closeUseCase: CloseProjectUseCase
    
    // MARK: - Init
    init(
        coordinator: ProjectDetailCoordinator,
        projectID: Int,
        projectDetailUseCase: FetchProjectDetailUseCase,
        bookmarkUseCase: BookmarkUseCase,
        applyUseCase: ApplyProjectUseCase,
        deleteUseCase: DeleteProjectUseCase,
        closeUseCase: CloseProjectUseCase
    ) {
        self.coordinator = coordinator
        self.projectID = projectID
        self.projectDetailUseCase = projectDetailUseCase
        self.bookmarkUseCase = bookmarkUseCase
        self.applyUseCase = applyUseCase
        self.deleteUseCase = deleteUseCase
        self.closeUseCase = closeUseCase
    }
    
    // MARK: - Transformation
    func transform(input: Input) -> Output {
        let project = BehaviorRelay<Project>(value: Project.onError)
        let projectManagementAction = PublishSubject<ProjectManagementType>()  // 모집글 관리 액션
        
        // 모집글 상세 가져오기
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
                    project.accept(data)
                    
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
        
        // 모집글 편집 메뉴 클릭.
        input.projectManagementActionTapped
            .withUnretained(self)
            .subscribe(onNext: { owner, option in
                let managementType = ProjectManagementType(rawValue: option) ?? .edit
                
                switch managementType {
                case .edit:
                    owner.coordinator?.showAlert(
                        configuration: .editProject,
                        primaryAction: { owner.coordinator?.connectToUpdateProjectFlow(with: project.value) }
                    )
                    
                case .close:
                    owner.coordinator?.showAlert(
                        configuration: .closeProject,
                        primaryAction: { projectManagementAction.onNext(.close) }
                    )
                    
                case .delete:
                    owner.coordinator?.showAlert(
                        configuration: .deleteProject,
                        primaryAction: { projectManagementAction.onNext(.delete) }
                    )
                }
            })
            .disposed(by: disposeBag)
        
        // 모집글 마감 혹은 삭제 처리
        projectManagementAction
            .withUnretained(self)
            .flatMap { owner, managementType -> Observable<Result<ProjectID, Error>> in
                switch managementType {
                case .close:
                    return owner.closeUseCase.close(projectID: owner.projectID).toResult()    // 마감하기 진행
                    
                case .delete:
                    return owner.deleteUseCase.delete(projectID: owner.projectID).toResult()  // 삭제하기 진행
                    
                default:
                    return .just(Result.success(0))
                }
            }
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .success:
                    owner.coordinator?.pop()
                    
                case .failure(let error):
                    owner.coordinator?.showErrorAlert(configuration: ErrorAlertConfiguration(
                        title: "오류",
                        description: error.localizedDescription
                    ))
                }
            })
            .disposed(by: disposeBag)
        
        // 지원하기
        input.applyButtonTapped
            .withUnretained(self)
            .flatMap { owner, _ -> Maybe<Void> in
                // 지원하기 Alert을 보여주고, 유저가 "지원하기" 를 클릭했을 경우 다음 시퀸스로 이동.
                owner.confirmActionWithAlert(alertConfiguration: .apply)
            }
            .withUnretained(self)
            .flatMap { owner, _ -> Observable<Result<Void, Error>> in
                owner.applyUseCase.apply(projectID: owner.projectID).toResult()  // 지원하기 진행
            }
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .success:
                    owner.coordinator?.showAlert(configuration: .completedApplication)
                    
                case .failure(let error):
                    owner.handleNetworkError(error)
                }
            })
            .disposed(by: disposeBag)
        
        // 북마크 처리
        input.bookmarkButtonTapped
            .withUnretained(self)
            .flatMap { owner, _ -> Observable<Result<ProjectID, Error>> in
                return owner.bookmarkUseCase.bookmark(projectID: owner.projectID).toResult()
            }
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .success:
                    // 북마크 상태 변경
                    var currentProject = project.value
                    currentProject.isBookmarked.toggle()
                    project.accept(currentProject)
                    
                case .failure(let error):
                    owner.handleNetworkError(error)
                }
            })
            .disposed(by: disposeBag)
        
        // 모집하는 분야 상세보기 이동
        input.goToDetailButtonTapped
            .withLatestFrom(project)
            .withUnretained(self)
            .subscribe(onNext: { owner, project in
                owner.coordinator?.showRecruitFieldDetailViewController(with: project)
            })
            .disposed(by: disposeBag)
        
        // 뷰가 Disappear 될 때, 코디네이터 할당제거
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

// MARK: - 네트워킹 결과처리
extension ProjectDetailViewModel {
    private func handleNetworkError(_ error: Error) {
        // 네트워크 에러가 401일 경우 로그인 Alert을 보여주고, 나머지 경우에는 Error Alert
        if let networkError = error as? NetworkError, case .statusCode(401) = networkError {
            coordinator?.showAlert(
                configuration: .signIn,
                primaryAction: { [weak self] in
                    self?.coordinator?.showSignInViewController()
                }
            )
        } else {
            coordinator?.showErrorAlert(configuration: ErrorAlertConfiguration(
                title: "오류",
                description: error.localizedDescription
            ))
        }
    }
}

// MARK: - Alert 대응 처리
extension ProjectDetailViewModel {
    /// 특정 작업의 수행을 확인하는 Alert을 보여주고, 유저의 액션에 따라 이벤트의 전달여부를 결정
    private func confirmActionWithAlert(alertConfiguration: AlertConfiguration) -> Maybe<Void> {
        Maybe<Void>.create { [weak self] maybe in
            guard let self else {
                maybe(.completed)
                return Disposables.create()
            }
            
            self.coordinator?.showAlert(
                configuration: alertConfiguration,
                primaryAction: {
                    maybe(.success(()))
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
extension ProjectDetailViewModel {
    enum Section: CaseIterable {
        case main
    }
    
    /// 프로젝트 관리 메뉴 타입
    enum ProjectManagementType: String {
        case edit = "수정하기"
        case close = "마감하기"
        case delete = "삭제하기"
    }
}
