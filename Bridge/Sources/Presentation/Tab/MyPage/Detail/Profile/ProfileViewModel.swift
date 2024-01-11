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
        let selectedLinkURL: Observable<String>      // 링크 이동
        let selectedFile: Observable<ReferenceFile>  // 파일 이동
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
                    owner.handleNetworkError(error)
                }
            })
            .disposed(by: disposeBag)
        
        // 프로필 수정 이동
        input.editProfileButtonTapped
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.coordinator?.showEditProfileViewController(with: profile.value)
            })
            .disposed(by: disposeBag)
        
        // 링크 이동
        input.selectedLinkURL
            .withUnretained(self)
            .subscribe(onNext: { owner, url in
                owner.coordinator?.showReferenceLink(with: url)
            })
            .disposed(by: disposeBag)
        
        
        return Output(profile: profile.asDriver())
    }
}

// MARK: - ErrorHandling
extension ProfileViewModel {
    /// 네트워크 에러가 401일 경우 로그인 Alert을 보여주고, 나머지 경우에는 Error Alert
    private func handleNetworkError(_ error: Error) {
        if let networkError = error as? NetworkError, case .statusCode(404) = networkError {
            coordinator?.showAlert(
                configuration: .createProfile,
                primaryAction: { [weak self] in
                    self?.coordinator?.showCreateProfileViewController()
                },
                cancelAction: { [weak self] in
                    self?.coordinator?.pop()
                }
            )
        } else {
            coordinator?.showErrorAlert(
                configuration: ErrorAlertConfiguration(
                    title: "프로필 조회에 실패했습니다.", 
                    description: error.localizedDescription
                ),
                primaryAction: { [weak self] in self?.coordinator?.pop() }
            )
        }
    }
}
