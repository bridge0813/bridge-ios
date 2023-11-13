//
//  ProjectDetailViewModel.swift
//  Bridge
//
//  Created by 엄지호 on 2023/11/10.
//

import RxSwift
import RxCocoa

final class ProjectDetailViewModel: ViewModelType {
    // MARK: - Input & Output
    struct Input {
        let viewWillAppear: Observable<Bool>
        let goToDetailButtonTapped: ControlEvent<Void>?
    }
    
    struct Output {
        
    }
    
    // MARK: - Property
    let disposeBag = DisposeBag()
    private weak var coordinator: ProjectDetailCoordinator?
    
    // MARK: - Init
    init(
        coordinator: ProjectDetailCoordinator
    ) {
        self.coordinator = coordinator
    }
    
    // MARK: - Transformation
    func transform(input: Input) -> Output {
        
        input.goToDetailButtonTapped?
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                // 임시
                owner.coordinator?.showRecruitFieldDetailViewController(with: [
                    MemberRequirement(field: "ios", recruitNumber: 2, requiredSkills: ["Swift", "UIKit", "SwiftUI", "RxSwift", "RxCocoa"], expectation: "스위프트 사용에 익숙하신 분이었으면 좋겠습니다."),
                    MemberRequirement(field: "uiux", recruitNumber: 2, requiredSkills: ["photoshop", "Figma", "illustrator"], expectation: "피그마 사용에 능숙했으면 좋겠습니다."),
                    MemberRequirement(field: "pm", recruitNumber: 2, requiredSkills: ["Notion", "Jira", "Slack"], expectation: "노션 사용에 능숙했으면 좋겠습니다.")
                ])
            })
            .disposed(by: disposeBag)
        
        return Output()
    }
}
