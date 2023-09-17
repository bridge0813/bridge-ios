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
        let statusButtonTapped: Observable<ProjectStatus>
    }
    
    struct Output {
        
    }
    
    // MARK: - Properties
    let disposeBag = DisposeBag()
    private weak var coordinator: CreateProjectCoordinator?
    private var project: Project
    
    // MARK: - Initializer
    init(
        coordinator: CreateProjectCoordinator,
        project: Project
    ) {
        self.coordinator = coordinator
        self.project = project
    }
    
    // MARK: - Methods
    func transform(input: Input) -> Output {
        input.nextButtonTapped
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.coordinator?.showProjectDescriptionInputViewController(with: owner.project)
            })
            .disposed(by: disposeBag)
        
        input.progressMethodButtonTapped
            .withUnretained(self)
            .subscribe(onNext: { owner, method in
                owner.project.meetingWay = method.rawValue
            })
            .disposed(by: disposeBag)
        
        input.progressMethodButtonTapped
            .withUnretained(self)
            .subscribe(onNext: { owner, method in
                owner.project.meetingWay = method.rawValue
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
    
    enum ProjectStatus: String {
        case notStarted = "시작하기 전이에요"
        case planning = "기획 중이에요"
        case planCompleted = "기획이 완료됐어요"
        case designing = "디자인 중이에요"
        case designCompleted = "디자인 완료됐어요"
    }
}
