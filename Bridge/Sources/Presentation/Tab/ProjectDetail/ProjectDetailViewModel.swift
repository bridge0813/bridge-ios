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
        var signInNeeded = true  // 로그인 체크
        
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
        
        // 모집하는 분야 상세보기 이동
        input.goToDetailButtonTapped
            .withLatestFrom(project)
            .withUnretained(self)
            .subscribe(onNext: { owner, project in
                owner.coordinator?.showRecruitFieldDetailViewController(with: project)
            })
            .disposed(by: disposeBag)
        
        // 모집글 편집기능
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
        
        // 지원하기
        input.applyButtonTapped
            .withUnretained(self)
            .flatMap { owner, _ -> Observable<Void> in
                // 로그인이 되어있지 않다면 Alert을 보여주고 시퀸스 종료.
                guard !signInNeeded else {
                    owner.coordinator?.showAlert(configuration: .signIn, primaryAction: {
                        owner.coordinator?.showSignInViewController()
                    })
                    return .empty()
                }
                
                return .just(())
            }
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
                    owner.coordinator?.showErrorAlert(
                        configuration: ErrorAlertConfiguration(title: "프로젝트 지원이 정상적으로 처리되었습니다.")
                    )
                    
                case .failure(let error):
                    owner.coordinator?.showErrorAlert(configuration: ErrorAlertConfiguration(
                        title: "오류",
                        description: error.localizedDescription
                    ))
                }
            })
            .disposed(by: disposeBag)
        
        
        // 북마크 처리
        input.bookmarkButtonTapped
            .withUnretained(self)
            .flatMap { owner, _ -> Observable<Result<Int, Error>> in
                // 로그인이 되어 있지 않다면, Alert 보여주기
                guard !signInNeeded else {
                    owner.coordinator?.showAlert(configuration: .signIn, primaryAction: {
                        owner.coordinator?.showSignInViewController()
                    })
                    return .empty()
                }
                
                // 로그인이 되어 있다면, 북마크 수행
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
                    owner.coordinator?.showErrorAlert(configuration: ErrorAlertConfiguration(
                        title: "오류",
                        description: error.localizedDescription
                    ))
                }
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
}
