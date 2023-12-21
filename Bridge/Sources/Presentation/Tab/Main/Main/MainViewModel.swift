//
//  MainViewModel.swift
//  Bridge
//
//  Created by 엄지호 on 2023/08/30.
//

import Foundation
import RxCocoa
import RxSwift

final class MainViewModel: ViewModelType {
    // MARK: - Input & Output
    struct Input {
        let viewWillAppear: Observable<Bool>
        let searchButtonTapped: ControlEvent<Void>
        let createButtonTapped: ControlEvent<Void>
        let itemSelected: Observable<Int>
        let bookmarkButtonTapped: Observable<Int>
        let categoryButtonTapped: Observable<String>
        let dropdownItemSelected: Observable<String>
    }
    
    struct Output {
        let projects: Driver<[ProjectPreview]>
        let fields: Driver<[String]>
        let selectedField: Driver<String>
        let bookmarkedProjectID: Driver<Int>
    }

    // MARK: - Property
    let disposeBag = DisposeBag()
    private weak var coordinator: MainCoordinator?
    
    private let fetchProfilePreviewUseCase: FetchProfilePreviewUseCase
    private let fetchAllProjectsUseCase: FetchAllProjectsUseCase
    private let fetchProjectsByFieldUseCase: FetchProjectsByFieldUseCase
    private let fetchHotProjectsUseCase: FetchHotProjectsUseCase
    private let fetchDeadlineProjectsUseCase: FetchDeadlineProjectsUseCase
    private let bookmarkUseCase: BookmarkUseCase
    
    var selectedCategory: CategoryType = .new  // 현재 선택된 카테고리
    
    // MARK: - Init
    init(
        coordinator: MainCoordinator,
        fetchProfilePreviewUseCase: FetchProfilePreviewUseCase,
        fetchAllProjectsUseCase: FetchAllProjectsUseCase,
        fetchProjectsByFieldUseCase: FetchProjectsByFieldUseCase,
        fetchHotProjectsUseCase: FetchHotProjectsUseCase,
        fetchDeadlineProjectsUseCase: FetchDeadlineProjectsUseCase,
        bookmarkUseCase: BookmarkUseCase
    ) {
        self.coordinator = coordinator
        self.fetchProfilePreviewUseCase = fetchProfilePreviewUseCase
        self.fetchAllProjectsUseCase = fetchAllProjectsUseCase
        self.fetchProjectsByFieldUseCase = fetchProjectsByFieldUseCase
        self.fetchHotProjectsUseCase = fetchHotProjectsUseCase
        self.fetchDeadlineProjectsUseCase = fetchDeadlineProjectsUseCase
        self.bookmarkUseCase = bookmarkUseCase
    }
    
    // MARK: - Transformation
    func transform(input: Input) -> Output {
        let projects = BehaviorRelay<[ProjectPreview]>(value: [])
        let fields = BehaviorRelay<[String]>(value: [])
        let selectedField = BehaviorRelay<String>(value: "")
        let bookmarkedProjectID = BehaviorRelay<Int>(value: 0)
        
        // 유저의 관심분야 가져오기, 카테고리가 신규일 경우 모집글 갱신
        input.viewWillAppear
            .withUnretained(self)
            .flatMapLatest { owner, _ in
                owner.fetchProfilePreviewUseCase.fetchProfilePreview().toResult()
            }
            .do(onNext: { result in
                switch result {
                case .success(let profile):
                    let currentFields = fields.value  // 기존 관심분야
                    fields.accept(profile.fields)
                    
                    // 기존 관심분야와 전달받은 관심분야를 비교하여 수정사항이 있는지 파악.
                    // OR 선택한 분야가 없다면, 가장 관심분야 중 첫 번째 요소로 선택(이전 선택분야 유지)
                    if currentFields != profile.fields || selectedField.value.isEmpty {
                        selectedField.accept(profile.fields[0])
                    }
                    
                case .failure:
                    fields.accept([])
                    selectedField.accept("전체")
                }
            })
            .withUnretained(self)
            .filter { owner, _ in owner.selectedCategory == .new }  // 카테고리가 신규일 경우에만 모집글 갱신
            .flatMap { owner, _ -> Observable<Result<[ProjectPreview], Error>> in
                // 로그인 상태가 아닌경우 -> 관심분야가 없음 -> 전체 모집글 조회
                // else 가장 첫 번째 관심분야에 맞는 모집글 조회
                owner.fetchProjectsForSelectedField(selectedField.value)
            }
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                owner.handleFetchProjectsResult(for: result, projects: projects)
            })
            .disposed(by: disposeBag)
        
        
        // 카테고리에 맞게 모집글 가져오기
        input.categoryButtonTapped
            .withUnretained(self)
            .flatMapLatest { owner, category -> Observable<Result<[ProjectPreview], Error>> in
                owner.selectedCategory = CategoryType(rawValue: category) ?? .new
                
                switch owner.selectedCategory {
                case .new:
                    return owner.fetchProjectsForSelectedField(selectedField.value)
                    
                case .hot:
                    return owner.fetchHotProjectsUseCase.fetchProjects().toResult()
                    
                case .deadline:
                    return owner.fetchDeadlineProjectsUseCase.fetchProjects().toResult()
                    
                case .comingSoon, .comingSoon2:
                    return .just(Result.success([]))
                }
            }
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                owner.handleFetchProjectsResult(for: result, projects: projects)
            })
            .disposed(by: disposeBag)
            
        // 선택한 관심분야에 맞게 데이터가져오기
        input.dropdownItemSelected
            .withUnretained(self)
            .flatMapLatest { owner, field -> Observable<Result<[ProjectPreview], Error>> in
                owner.selectedCategory = .new  // 카테고리 신규로 전환
                selectedField.accept(field)
                
                return owner.fetchProjectsForSelectedField(field)
            }
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                owner.handleFetchProjectsResult(for: result, projects: projects)
            })
            .disposed(by: disposeBag)
        
        // 선택한 모집글의 상세 뷰로 이동하기
        input.itemSelected
            .withUnretained(self)
            .subscribe(onNext: { owner, projectID in
                owner.coordinator?.connectToProjectDetailFlow(with: projectID)
            })
            .disposed(by: disposeBag)
        
        // 북마크
        input.bookmarkButtonTapped
            .withUnretained(self)
            .flatMap { owner, projectID -> Observable<Result<Int, Error>> in
                return owner.bookmarkUseCase.bookmark(projectID: projectID).toResult()
            }
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .success(let projectID):
                    bookmarkedProjectID.accept(projectID)
                    
                case .failure(let error):
                    owner.handleNetworkError(error)
                }
            })
            .disposed(by: disposeBag)
        
        // 검색 이동
        input.searchButtonTapped
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.coordinator?.connectToProjectSearchFlow()
            })
            .disposed(by: disposeBag)
        
        // 글쓰기 이동
        input.createButtonTapped
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                // 로그인 여부 체크
                if fields.value.isEmpty {
                    owner.coordinator?.showAlert(configuration: .signIn, primaryAction: {
                        owner.coordinator?.showSignInViewController()
                    })
                    
                } else {
                    owner.coordinator?.showAlert(configuration: .createProject, primaryAction: {
                        owner.coordinator?.connectToCreateProjectFlow()
                    })
                }
            })
            .disposed(by: disposeBag)
        
        return Output(
            projects: projects.asDriver(onErrorJustReturn: [ProjectPreview.onError]),
            fields: fields.asDriver(onErrorJustReturn: []),
            selectedField: selectedField.asDriver(onErrorJustReturn: "Error"),
            bookmarkedProjectID: bookmarkedProjectID.asDriver(onErrorJustReturn: 0)
        )
    }
}

// MARK: - Methods
private extension MainViewModel {
    /// 모집글 네트워킹의 결과를 받아 처리
    func handleFetchProjectsResult(
        for result: Result<[ProjectPreview], Error>,
        projects: BehaviorRelay<[ProjectPreview]>
    ) {
        switch result {
        case .success(let projectPreviews):
            projects.accept(projectPreviews)
            
        case .failure(let error):
            projects.accept([])
            handleNetworkError(error)
        }
    }
    
    /// 네트워크 에러가 401일 경우 로그인 Alert을 보여주고, 나머지 경우에는 Error Alert
    private func handleNetworkError(_ error: Error) {
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
    
    /// 선택된 분야에 맞게 네트워킹을 수행하는 메서드
    func fetchProjectsForSelectedField(_ field: String) -> Observable<Result<[ProjectPreview], Error>> {
        // 선택된 분야가 "전체" 일 경우, 전체 모집글을, else 선택된 분야에 맞게 모집글 가져옴
        if field == "전체" {
            return fetchAllProjectsUseCase.fetchProjects().toResult()
        } else {
            return fetchProjectsByFieldUseCase.fetchProjects(for: field).toResult()
        }
    }
}

// MARK: - UI DataSource
extension MainViewModel {
    enum Section: CaseIterable {
        case hot
        case main
    }
    
    enum CategoryType: String {
        case new
        case hot
        case deadline
        case comingSoon
        case comingSoon2
    }
}
