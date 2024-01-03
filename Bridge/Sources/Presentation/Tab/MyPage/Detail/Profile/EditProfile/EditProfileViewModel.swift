//
//  EditProfileViewModel.swift
//  Bridge
//
//  Created by 엄지호 on 1/1/24.
//

import RxCocoa
import RxSwift

final class EditProfileViewModel: ViewModelType {
    // MARK: - Input & Output
    struct Input {
        let selectedFieldTechStack: Observable<FieldTechStack>
    }
    
    struct Output {
        let profile: Driver<Profile>
    }
    
    // MARK: - Property
    let disposeBag = DisposeBag()
    private weak var coordinator: MyPageCoordinator?
    
    private var profile: Profile
    
    // MARK: - Init
    init(
        coordinator: MyPageCoordinator,
        profile: Profile
    ) {
        self.coordinator = coordinator
        self.profile = profile
    }
    
    // MARK: - Transformation
    func transform(input: Input) -> Output {
        let profileRelay = BehaviorRelay<Profile>(value: profile)
        
        // 설정된 분야 및 기술 스택 저장
        input.selectedFieldTechStack
            .withUnretained(self)
            .subscribe(onNext: { owner, fieldTechStack in
                owner.profile.fieldTechStacks.append(fieldTechStack)
                profileRelay.accept(owner.profile)
            })
            .disposed(by: disposeBag)
        
        return Output(
            profile: profileRelay.asDriver(onErrorJustReturn: .onError)
        )
    }
}
