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
        let bookmarkButtonTapped: Observable<Int>
    }
    
    struct Output {
        let bookmarkedProjects: BehaviorRelay<[BookmarkedProject]>
    }
    
    // MARK: - Property
    let disposeBag = DisposeBag()
    private weak var coordinator: MyPageCoordinator?
    private let fetchBookmarkedProjectUseCase: FetchBookmarkedProjectsUseCase
    private let bookmarkUseCase: BookmarkUseCase
    
    // MARK: - Init
    init(
        coordinator: MyPageCoordinator?,
        fetchBookmarkedProjectUseCase: FetchBookmarkedProjectsUseCase,
        bookmarkUseCase: BookmarkUseCase
    ) {
        self.coordinator = coordinator
        self.fetchBookmarkedProjectUseCase = fetchBookmarkedProjectUseCase
        self.bookmarkUseCase = bookmarkUseCase
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
        
        input.bookmarkButtonTapped
            .debug()
            .withUnretained(self)
            .flatMap { owner, projectID in
                owner.bookmarkUseCase.bookmark(projectID: projectID)
            }
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
