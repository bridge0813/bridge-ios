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
        let viewWillAppear: Observable<Bool>  // 로그인 여부에 따라, 유저의 분야에 맞게 받아올 정보가 다름(수정 필요)
        let didScroll: Observable<CGPoint>
        let filterButtonTapped: Observable<Void>
        let itemSelected: Observable<IndexPath>
        let createButtonTapped: Observable<Void>
        let categoryButtonTapped: Observable<String>
    }
    
    struct Output {
        let projects: Driver<[Project]>
        let buttonTypeAndProjects: Driver<(String, [Project])>
        let buttonDisplayMode: Driver<CreateButtonDisplayState>
        let categoryAlpha: Driver<CGFloat>  // 카테고리 알파값
        let topMargins: Driver<(CGFloat, CGFloat)>  // 카테고리, 컬렉션 뷰의 마진
    }

    // MARK: - Property
    let disposeBag = DisposeBag()
    private weak var coordinator: MainCoordinator?
    private let fetchProjectsUseCase: FetchAllProjectsUseCase
    private let fetchHotProjectsUseCase: FetchHotProjectsUseCase
    
    // MARK: - Init
    init(
        coordinator: MainCoordinator,
        fetchProjectsUseCase: FetchAllProjectsUseCase,
        fetchHotProjectsUseCase: FetchHotProjectsUseCase
    ) {
        self.coordinator = coordinator
        self.fetchProjectsUseCase = fetchProjectsUseCase
        self.fetchHotProjectsUseCase = fetchHotProjectsUseCase
    }
    
    // MARK: - Transformation
    func transform(input: Input) -> Output {
        // MARK: - Fetch Projects
        let projects = input.viewWillAppear
            .withUnretained(self)
            .flatMapLatest { owner, _ -> Observable<[Project]> in
                return owner.fetchProjectsUseCase.execute()
            }
            .distinctUntilChanged()
        
        let buttonTypeAndProjects = input.categoryButtonTapped
            .withUnretained(self)
            .flatMapLatest { owner, type -> Observable<(String, [Project])> in
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
        
        // MARK: - Button State
        let layoutMode = input.didScroll
            .map { $0.y <= 0 ? CreateButtonDisplayState.both : .only }
            .distinctUntilChanged()
            .observe(on: MainScheduler.asyncInstance)
        
        let categoryAlpha = input.didScroll
            .map { offset in
                
                let categoryHeight: CGFloat = 102.0
                
                // 알파 값의 최소 및 최대 범위 설정
                let minAlpha: CGFloat = 0.0
                let maxAlpha: CGFloat = 1.0
                let alpha = max(minAlpha, maxAlpha - (offset.y / categoryHeight))
                
                return alpha
            }
            .observe(on: MainScheduler.asyncInstance)
        
        let topMargins = input.didScroll
            .map { offset in
                let categoryHeight: CGFloat = 102.0
                let minTop: CGFloat = 0
                
                // 컬렉션뷰 마진계산
                let collectionViewMargin = min(
                    categoryHeight,
                    max(
                        minTop,
                        categoryHeight - (offset.y * (categoryHeight - minTop) / categoryHeight)
                    )
                )
                
                // 카테고리 마진계산
                let minCategoryMargin: CGFloat = minTop - categoryHeight
                let categoryMargin = min(minTop, max(minCategoryMargin, minTop - offset.y))
                
                return (categoryMargin, collectionViewMargin)
            }
            .observe(on: MainScheduler.asyncInstance)
        
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
            projects: projects.asDriver(onErrorJustReturn: [Project.onError]),
            buttonTypeAndProjects: buttonTypeAndProjects.asDriver(onErrorJustReturn: ("new", [])),
            buttonDisplayMode: layoutMode.asDriver(onErrorJustReturn: .both),
            categoryAlpha: categoryAlpha.asDriver(onErrorJustReturn: 1),
            topMargins: topMargins.asDriver(onErrorJustReturn: (48, 150))
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
    
    enum CreateButtonDisplayState {
        case both
        case only
    }
}
