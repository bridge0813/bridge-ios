//
//  ProjectProgressStatusViewModel.swift
//  Bridge
//
//  Created by 엄지호 on 2023/09/11.
//

import RxSwift

final class ProjectProgressStatusViewModel: ViewModelType {
    // MARK: - Nested Types
    struct Input {
        let nextButtonTapped: Observable<Void>
        let progressMethodButtonTapped: Observable<ProgressMethod>
        let statusButtonTapped: Observable<ProgressStatus>
    }
    
    struct Output {
        
    }
    
    // MARK: - Properties
    let disposeBag = DisposeBag()
    private weak var coordinator: CreateProjectCoordinator?
    
    private let dataStore: ProjectDataStore
    
    // MARK: - Initializer
    init(
        coordinator: CreateProjectCoordinator,
        dataStore: ProjectDataStore
    ) {
        self.coordinator = coordinator
        self.dataStore = dataStore
    }
    
    // MARK: - Methods
    func transform(input: Input) -> Output {
        input.nextButtonTapped
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.coordinator?.showProjectDescriptionInputViewController()
            })
            .disposed(by: disposeBag)
        
        input.progressMethodButtonTapped
            .withUnretained(self)
            .subscribe(onNext: { owner, method in
                owner.dataStore.updateProgressMethod(with: method.rawValue)
            })
            .disposed(by: disposeBag)
        
        input.statusButtonTapped
            .withUnretained(self)
            .subscribe(onNext: { owner, status in
                owner.dataStore.updateProgressStatus(with: status.rawValue)
            })
            .disposed(by: disposeBag)
        
        return Output()
    }
}

extension ProjectProgressStatusViewModel {
    enum ProgressMethod: String {
        case online = "온라인"
        case offline = "오프라인"
        case blended = "블렌디드"
    }
    
    enum ProgressStatus: String {
        case notStarted = "시작하기 전이에요"
        case planning = "기획 중이에요"
        case planCompleted = "기획이 완료됐어요"
        case designing = "디자인 중이에요"
        case designCompleted = "디자인 완료됐어요"
    }
}
