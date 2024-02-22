//
//  SearchProjectViewModel.swift
//  Bridge
//
//  Created by 엄지호 on 2/5/24.
//

import Foundation
import RxCocoa
import RxSwift

final class SearchProjectViewModel: ViewModelType {
    // MARK: - Input & Output
    struct Input {
        let textFieldEditingDidBegin: Observable<Void>
        let searchButtonTapped: Observable<String>
        let cancelButtonTapped: ControlEvent<Void>
        let removeAllButtonTapped: Observable<Void>
        let itemSelected: Observable<ProjectID>
        let bookmarkButtonTapped: Observable<ProjectID>
    }
    
    struct Output {
        let projects: Driver<[ProjectPreview]>
        let recentSearches: Observable<[RecentSearch]>
    }

    // MARK: - Property
    let disposeBag = DisposeBag()
    private weak var coordinator: MainCoordinator?
    
    private let fetchRecentSearchUseCase: FetchRecentSearchUseCase
    private let removeSearchUseCase: RemoveSearchUseCase
    private let searchProjectsUseCase: SearchProjectsUseCase
    private let bookmarkUseCase: BookmarkUseCase
    
    // MARK: - Init
    init(
        coordinator: MainCoordinator,
        fetchRecentSearchUseCase: FetchRecentSearchUseCase,
        removeSearchUseCase: RemoveSearchUseCase,
        searchProjectsUseCase: SearchProjectsUseCase,
        bookmarkUseCase: BookmarkUseCase
    ) {
        self.coordinator = coordinator
        self.fetchRecentSearchUseCase = fetchRecentSearchUseCase
        self.removeSearchUseCase = removeSearchUseCase
        self.searchProjectsUseCase = searchProjectsUseCase
        self.bookmarkUseCase = bookmarkUseCase
    }
    
    // MARK: - Transformation
    func transform(input: Input) -> Output {
        let projectListRelay = BehaviorRelay<[ProjectPreview]>(value: [])
        let recentSearchesRelay = BehaviorRelay<[RecentSearch]>(value: [])
        
        input.textFieldEditingDidBegin
            .withUnretained(self)
            .flatMapLatest { owner, _ in
                owner.fetchRecentSearchUseCase.fetch().toResult()
            }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { result in
                switch result {
                case .success(let recentSearches):
                    recentSearchesRelay.accept(recentSearches)
                    
                case .failure(let error):
                    // 에러에 대한 Alert을 보여주지 않음.
                    // 로그인을 하지 않은 유저, 검색어 저장 끄기를 한 유저들은 이에 대한 리액션을 받을 필요가 없음.
                    print(error.localizedDescription)
                }
            })
            .disposed(by: disposeBag)
        
        // 검색
        input.searchButtonTapped
            .withUnretained(self)
            .flatMapLatest { owner, query in
                owner.searchProjectsUseCase.search(by: query).toResult()
            }
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .success(let projects):
                    projectListRelay.accept(projects)
                    
                case .failure(let error):
                    projectListRelay.accept([])
                    owner.coordinator?.showErrorAlert(configuration: ErrorAlertConfiguration(
                        title: "검색에 실패했습니다.",
                        description: error.localizedDescription
                    ))
                }
            })
            .disposed(by: disposeBag)
        
        // 검색어 전체 삭제
        input.removeAllButtonTapped
            .withUnretained(self)
            .flatMapLatest { owner, _ in
                owner.removeSearchUseCase.removeAll().toResult()
            }
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .success:
                    recentSearchesRelay.accept([])
                    
                case .failure(let error):
                    owner.coordinator?.showErrorAlert(configuration: ErrorAlertConfiguration(
                        title: "검색에 삭제에 실패했습니다.",
                        description: error.localizedDescription
                    ))
                }
            })
            .disposed(by: disposeBag)
        
        // 선택한 모집글의 상세로 이동
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
                    var updatedProjectList = projectListRelay.value
                
                    // 북마크 여부 수정 후 accept
                    if let index = updatedProjectList.firstIndex(where: { $0.projectID == projectID }) {
                        updatedProjectList[index].isBookmarked.toggle()
                        projectListRelay.accept(updatedProjectList)
                    }
                    
                case .failure(let error):
                    owner.coordinator?.showErrorAlert(configuration: ErrorAlertConfiguration(
                        title: "북마크 실패",
                        description: error.localizedDescription
                    ))
                }
            })
            .disposed(by: disposeBag)
        
        // 취소 버튼
        input.cancelButtonTapped
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.coordinator?.pop()
            })
            .disposed(by: disposeBag)
        
        return Output(
            projects: projectListRelay.asDriver(),
            recentSearches: recentSearchesRelay.asObservable()
        )
    }
}

// MARK: - Data source
extension SearchProjectViewModel {
    enum Section: CaseIterable {
        case main
    }
}
