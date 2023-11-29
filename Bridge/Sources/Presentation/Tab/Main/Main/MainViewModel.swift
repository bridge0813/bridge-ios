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
        let dropdownItemSelected: Observable<String>
    }
    
    struct Output {
        let projects: Driver<[ProjectPreview]>
        let fields: Driver<[String]>
        let selectedField: Driver<String>
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
        let selectedField = BehaviorRelay<String>(value: "전체")
        
        // viewDidLoad 시점, 전체 모집글 가져오기
        fetchAllProjectsUseCase.fetchProjects()
            .toResult()
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
        
        // 유저의 관심분야 가져오기
        input.viewWillAppear
            .withUnretained(self)
            .flatMapLatest { owner, _ in
                owner.fetchProfilePreviewUseCase.fetchProfilePreview().toResult()
            }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { result in
                switch result {
                case .success(let profile):
                    fields.accept(profile.field)
                    
                case .failure:
                    fields.accept([])
                }
            })
            .disposed(by: disposeBag)
        
        // 카테고리에 맞게 모집글 가져오기
        input.categoryButtonTapped
            .distinctUntilChanged()
            .withUnretained(self)
            .flatMapLatest { owner, category -> Observable<Result<[ProjectPreview], Error>> in
                owner.selectedCategory = CategoryType(rawValue: category) ?? .new
                
                switch owner.selectedCategory {
                case .new:
                    // 선택된 분야가 "전체" 일 경우, 전체 모집글을, else 선택된 분야에 맞게 모집글 가져옴
                    if selectedField.value == "전체" {
                        return owner.fetchAllProjectsUseCase.fetchProjects().toResult()
                        
                    } else {
                        let requestField = String(describing: FieldType(rawValue: selectedField.value) ?? .IOS)
                        return owner.fetchProjectsByFieldUseCase.fetchProjects(for: requestField).toResult()
                    }
                    
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
            
        // 선택한 관심분야에 맞게 데이터가져오기
        input.dropdownItemSelected
            .distinctUntilChanged()
            .withUnretained(self)
            .flatMap { owner, field -> Observable<Result<[ProjectPreview], Error>> in
                owner.selectedCategory = .new  // 카테고리 신규로 전환
                selectedField.accept(field)
                
                // 선택된 분야가 "전체" 일 경우, 전체 모집글을, else 선택된 분야에 맞게 모집글 가져옴
                if field == "전체" {
                    return owner.fetchAllProjectsUseCase.fetchProjects().toResult()
                    
                } else {
                    let requestField = String(describing: FieldType(rawValue: field) ?? .IOS)
                    return owner.fetchProjectsByFieldUseCase.fetchProjects(for: requestField).toResult()
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
        
        // 선택한 모집글의 상세 뷰로 이동하기
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
            fields: fields.asDriver(onErrorJustReturn: []),
            selectedField: selectedField.asDriver(onErrorJustReturn: "Error")
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
    
    enum FieldType: String, CustomStringConvertible {
        case IOS = "iOS"
        case AOS = "안드로이드"
        case FRONTEND = "프론트엔드"
        case BACKEND = "백엔드"
        case UIUX = "UI/UX"
        case BIBX = "BI/BX"
        case VIDEOMOTION = "영상/모션"
        case PM = "PM"
        
        var description: String {
            switch self {
            case .IOS: return "IOS"
            case .AOS: return "AOS"
            case .FRONTEND: return "FRONTEND"
            case .BACKEND: return "BACKEND"
            case .UIUX: return "UIUX"
            case .BIBX: return "BIBX"
            case .VIDEOMOTION: return "VIDEOMOTION"
            case .PM: return "PM"
            }
        }
    }
}
