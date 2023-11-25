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
        let filterButtonTapped: Observable<Void>
        let itemSelected: Observable<IndexPath>
        let createButtonTapped: Observable<Void>
        let categoryButtonTapped: Observable<String>
    }
    
    struct Output {
        let projects: Driver<[ProjectPreview]>
        let buttonTypeAndProjects: Driver<(String, [ProjectPreview])>
    }

    // MARK: - Property
    let disposeBag = DisposeBag()
    private weak var coordinator: MainCoordinator?
    
    private let fetchProfilePreviewUseCase: FetchProfilePreviewUseCase
    private let fetchProjectsUseCase: FetchAllProjectsUseCase
    private let fetchHotProjectsUseCase: FetchHotProjectsUseCase
    
    // MARK: - Init
    init(
        coordinator: MainCoordinator,
        fetchProfilePreviewUseCase: FetchProfilePreviewUseCase,
        fetchProjectsUseCase: FetchAllProjectsUseCase,
        fetchHotProjectsUseCase: FetchHotProjectsUseCase
    ) {
        self.coordinator = coordinator
        self.fetchProfilePreviewUseCase = fetchProfilePreviewUseCase
        self.fetchProjectsUseCase = fetchProjectsUseCase
        self.fetchHotProjectsUseCase = fetchHotProjectsUseCase
    }
    
    // MARK: - Transformation
    func transform(input: Input) -> Output {
        let projects = BehaviorRelay<[ProjectPreview]>(value: [])
        let field = BehaviorRelay<[String]>(value: [])
        
        fetchProfilePreviewUseCase.fetchProfilePreview().toResult()
            .withUnretained(self)
            .flatMap { owner, result -> Observable<Result<[ProjectPreview], Error>> in
                switch result {
                case .success(let profile):
                    field.accept(profile.field)
                    return owner.fetchProjectsUseCase.execute().toResult()  // 선택된 분야 - 신규 데이터 가져오기
                    
                case .failure:
                    return owner.fetchProjectsUseCase.execute().toResult()  // 전체 - 신규 데이터 가져오기
                }
            }
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .success(let projectPreviews):
                    projects.accept(projectPreviews)
                    
                case .failure:
                    owner.coordinator?.showErrorAlert(configuration: .networkError)
                }
            })
            .disposed(by: disposeBag)
        
        
        let buttonTypeAndProjects = input.categoryButtonTapped
            .withUnretained(self)
            .flatMapLatest { owner, type -> Observable<(String, [ProjectPreview])> in
                switch type {
                case "new":
                    return owner.fetchProjectsUseCase.execute().map { (type, $0) }  // 신규 데이터
                    
                case "hot":
                    return owner.fetchProjectsUseCase.execute().map { (type, $0) }  // 인기 데이터
                    
                case "deadlineApproach":
                    return owner.fetchProjectsUseCase.execute().map { (type, $0) }  // 마감임박 데이터
                    
                case "comingSoon", "comingSoon2":
                    return .just((type, []))
                    
                default:
                    return .just((type, []))
                }
            }
            
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
            buttonTypeAndProjects: buttonTypeAndProjects.asDriver(onErrorJustReturn: ("new", []))
        )
    }
}

// MARK: - Coordinator
extension MainViewModel {
    
}

// MARK: - UI DataSource
extension MainViewModel {
    enum Section: CaseIterable {
        case hot
        case main
    }
}
