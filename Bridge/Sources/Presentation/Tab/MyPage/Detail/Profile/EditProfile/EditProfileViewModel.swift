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
        let addedFieldTechStack: Observable<FieldTechStack>                // 기술스택 추가
        let deletedFieldTechStack: Observable<IndexRow>                    // 기술스택 삭제
        let updatedFieldTechStack: Observable<(IndexRow, FieldTechStack)>  // 기술스택 수정
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
        
        // 분야 및 기술 스택 추가
        input.addedFieldTechStack
            .withUnretained(self)
            .subscribe(onNext: { owner, fieldTechStack in
                owner.profile.fieldTechStacks.append(fieldTechStack)
                profileRelay.accept(owner.profile)
            })
            .disposed(by: disposeBag)
        
        // 분야 및 기술 스택 삭제
        input.deletedFieldTechStack
            .withUnretained(self)
            .subscribe(onNext: { owner, indexRow in
                owner.profile.fieldTechStacks.remove(at: indexRow)
                profileRelay.accept(owner.profile)
            })
            .disposed(by: disposeBag)
        
        // 분야 및 기술 스택 수정
        input.updatedFieldTechStack
            .withUnretained(self)
            .subscribe(onNext: { owner, element in
                let (indexRow, fieldTeckStack) = element
                owner.profile.fieldTechStacks[indexRow] = fieldTeckStack
                profileRelay.accept(owner.profile)
            })
            .disposed(by: disposeBag)
        
        return Output(
            profile: profileRelay.asDriver(onErrorJustReturn: .onError)
        )
    }
}
