//
//  BookmarkedProjectViewModel.swift
//  Bridge
//
//  Created by 정호윤 on 12/14/23.
//

import RxSwift
import RxCocoa

final class BookmarkedProjectViewModel: ViewModelType {
    // MARK: - Input & Output
    struct Input {
        let viewWillAppear: Observable<Bool>
    }
    
    struct Output {
        let bookmarkedProjects: BehaviorRelay<[BookmarkedProject]>
    }
    
    // MARK: - Property
    let disposeBag = DisposeBag()
    private weak var coordinator: MyPageCoordinator?
    private let fetchBookmarkedProjectUseCase: FetchBookmarkedProjectsUseCase
    
    // MARK: - Init
    init(coordinator: MyPageCoordinator?, fetchBookmarkedProjectUseCase: FetchBookmarkedProjectsUseCase) {
        self.coordinator = coordinator
        self.fetchBookmarkedProjectUseCase = fetchBookmarkedProjectUseCase
    }
    
    // MARK: - Transformation
    func transform(input: Input) -> Output {
        let bookmarkedProjects = BehaviorRelay<[BookmarkedProject]>(value: [])
        
        input.viewWillAppear
            .withUnretained(self)
            .flatMap { owner, _ in
                owner.fetchBookmarkedProjectUseCase.fetch()
            }
            .bind(to: bookmarkedProjects)
            .disposed(by: disposeBag)
        
        return Output(
            bookmarkedProjects: bookmarkedProjects
        )
    }
}
