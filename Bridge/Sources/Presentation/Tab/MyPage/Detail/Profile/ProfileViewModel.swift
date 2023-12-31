//
//  ProfileViewModel.swift
//  Bridge
//
//  Created by 정호윤 on 12/14/23.
//

import RxCocoa
import RxSwift

final class ProfileViewModel: ViewModelType {
    // MARK: - Input & Output
    struct Input {
        let viewWillAppear: Observable<Bool>
        let editProfileButtonTapped: ControlEvent<Void>
    }
    
    struct Output {
        let profile: Driver<Profile>
    }
    
    // MARK: - Property
    let disposeBag = DisposeBag()
    private weak var coordinator: MyPageCoordinator?
    
    private let fetchProfileUseCase: FetchProfileUseCase
    
    // MARK: - Init
    init(
        coordinator: MyPageCoordinator,
        fetchProfileUseCase: FetchProfileUseCase
    ) {
        self.coordinator = coordinator
        self.fetchProfileUseCase = fetchProfileUseCase
    }
    
    // MARK: - Transformation
    func transform(input: Input) -> Output {
        let profile = BehaviorRelay<Profile>(value: Profile.onError)
        
        // 프로필 조회
        input.viewWillAppear
            .withUnretained(self)
            .flatMapLatest { owner, _ in
                return owner.fetchProfileUseCase.fetch().toResult()
            }
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .success(let profileData):
                    profile.accept(profileData)
                    
                case .failure(let error):
                    owner.coordinator?.showErrorAlert(configuration: ErrorAlertConfiguration(
                        title: "프로필 조회에 실패했습니다.",
                        description: error.localizedDescription
                    ))
                }
            })
            .disposed(by: disposeBag)
        
        
        input.editProfileButtonTapped
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.coordinator?.showBookmarkedProjectViewController()
            })
            .disposed(by: disposeBag)
        
        
        return Output(profile: profile.asDriver())
    }
}
