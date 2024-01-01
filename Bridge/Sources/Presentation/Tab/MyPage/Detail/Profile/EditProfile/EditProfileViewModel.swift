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
        
        
        return Output(profile: Observable.just(profile).asDriver(onErrorJustReturn: Profile.onError))
    }
}
