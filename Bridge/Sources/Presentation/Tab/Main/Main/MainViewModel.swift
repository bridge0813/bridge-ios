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
        let filterButtonTapped: Observable<Void>
        let itemSelected: Observable<IndexPath>
        let createButtonTapped: Observable<Void>
        let categoryButtonTapped: Observable<String>
    }
    
    struct Output {
        let projects: Driver<[ProjectPreview]>
        let fields: Driver<[String]>
    }

    // MARK: - Property
    let disposeBag = DisposeBag()
    private weak var coordinator: MainCoordinator?
    
    private let fetchProfilePreviewUseCase: FetchProfilePreviewUseCase
    private let fetchAllProjectsUseCase: FetchAllProjectsUseCase
    private let fetchProjectsByFieldUseCase: FetchProjectsByFieldUseCase
    private let fetchHotProjectsUseCase: FetchHotProjectsUseCase
    private let fetchDeadlineProjectsUseCase: FetchDeadlineProjectsUseCase
    
    var selectedCategory: CategoryType = .new  // 현재 선택된 카테고리
    
    // MARK: - Init
    init(
        coordinator: MainCoordinator,
        fetchProfilePreviewUseCase: FetchProfilePreviewUseCase,
        fetchAllProjectsUseCase: FetchAllProjectsUseCase,
        fetchProjectsByFieldUseCase: FetchProjectsByFieldUseCase,
        fetchHotProjectsUseCase: FetchHotProjectsUseCase,
        fetchDeadlineProjectsUseCase: FetchDeadlineProjectsUseCase
    ) {
        self.coordinator = coordinator
        self.fetchProfilePreviewUseCase = fetchProfilePreviewUseCase
        self.fetchAllProjectsUseCase = fetchAllProjectsUseCase
        self.fetchProjectsByFieldUseCase = fetchProjectsByFieldUseCase
        self.fetchHotProjectsUseCase = fetchHotProjectsUseCase
        self.fetchDeadlineProjectsUseCase = fetchDeadlineProjectsUseCase
    }
    
    // MARK: - Transformation
    func transform(input: Input) -> Output {
        let projects = BehaviorRelay<[ProjectPreview]>(value: [])
        let fields = BehaviorRelay<[String]>(value: [])
        
        input.viewWillAppear
            .withUnretained(self)
            .filter { owner, _ in
                owner.selectedCategory == .new  // 카테고리가 신규일 경우에만 수행
            }
            .flatMapLatest { owner, _ in
                owner.fetchProfilePreviewUseCase.fetchProfilePreview().toResult()
            }
            .withUnretained(self)
            .flatMap { owner, result -> Observable<Result<[ProjectPreview], Error>> in
                switch result {
                case .success(let profile):
                    fields.accept(profile.field)
                    // IOS, AOS, FRONTEND, BACKEND, UIUX, BIBX, VIDEOMOTION, PM
                    // TODO - 나의 관심분야 중 선택된 분야를 찾고 데이터 찾아오기.
                    return owner.fetchProjectsByFieldUseCase.fetchProjects(for: "UIUX").toResult()
                    
                case .failure:
                    return owner.fetchAllProjectsUseCase.fetchProjects().toResult()  // 전체 - 신규 데이터 가져오기
                }
            }
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .success(let projectPreviews):
                    projects.accept(projectPreviews)
                    
                case .failure(let error):
                    owner.coordinator?.showErrorAlert(configuration: ErrorAlertConfiguration(
                        title: "오류",
                        description: error.localizedDescription
                    ))
                }
            })
            .disposed(by: disposeBag)
        
        
        input.categoryButtonTapped
            .withUnretained(self)
            .flatMapLatest { owner, category -> Observable<Result<[ProjectPreview], Error>> in
                owner.selectedCategory = CategoryType(rawValue: category) ?? .new
                
                switch owner.selectedCategory {
                case .new:
                    return owner.fetchProjectsByFieldUseCase.fetchProjects(for: "UIUX").toResult()
                    
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
                switch result {
                case .success(let projectPreviews):
                    projects.accept(projectPreviews)
                    
                case .failure(let error):
                    owner.coordinator?.showErrorAlert(configuration: ErrorAlertConfiguration(
                        title: "오류",
                        description: error.localizedDescription
                    ))
                }
            })
            .disposed(by: disposeBag)
            
        // MARK: - Item Selected
        input.itemSelected
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.coordinator?.connectToProjectDetailFlow(with: "")
            })
            .disposed(by: disposeBag)
        
        // MARK: - Button Actions
        input.filterButtonTapped
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.coordinator?.connectToProjectFilteringFlow()
            })
            .disposed(by: disposeBag)
        
        input.createButtonTapped
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.coordinator?.showAlert(configuration: .createProject, primaryAction: {
                    owner.coordinator?.connectToCreateProjectFlow()
                })
            })
            .disposed(by: disposeBag)
        
        return Output(
            projects: projects.asDriver(onErrorJustReturn: [ProjectPreview.onError]),
            fields: fields.asDriver(onErrorJustReturn: [])
        )
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
    
    enum FieldType: String {
        case IOS = "iOS"
        case AOS = "안드로이드"
        case FRONTEND = "프론트엔드"
        case BACKEND = "백엔드"
        case UIUX = "UI/UX"
        case BIBX = "BI/BX"
        case VIDEOMOTION = "영상/모션"
        case PM = "PM"
    }
}
