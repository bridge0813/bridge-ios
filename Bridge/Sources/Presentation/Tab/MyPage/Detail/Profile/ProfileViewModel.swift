//
//  ProfileViewModel.swift
//  Bridge
//
//  Created by 정호윤 on 12/14/23.
//

import Foundation
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
        let profileOwner: Driver<ProfileOwner>
        let downloadedFile: Observable<URL>
    }
    
    // MARK: - Property
    let disposeBag = DisposeBag()
    private weak var coordinator: MyPageCoordinator?
    
    private let profileOwner: ProfileOwner
    private let fetchProfileUseCase: FetchProfileUseCase
    private let downloadFileUseCase: DownloadFileUseCase
    
    // MARK: - Init
    init(
        coordinator: MyPageCoordinator,
        profileOwner: ProfileOwner,
        fetchProfileUseCase: FetchProfileUseCase,
        downloadFileUseCase: DownloadFileUseCase
    ) {
        self.coordinator = coordinator
        self.profileOwner = profileOwner
        self.fetchProfileUseCase = fetchProfileUseCase
        self.downloadFileUseCase = downloadFileUseCase
    }
    
    // MARK: - Transformation
    func transform(input: Input) -> Output {
        let profile = BehaviorRelay<Profile>(value: Profile.onError)
        let downloadedFile = PublishSubject<URL>()
        
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
                owner.coordinator?.showUpdatProfileViewController(with: profile.value)
            })
            .disposed(by: disposeBag)
        
        // 링크 이동
        input.selectedLinkURL
            .withUnretained(self)
            .subscribe(onNext: { owner, url in
                owner.coordinator?.showReferenceLink(with: url)
            })
            .disposed(by: disposeBag)
        
        input.selectedFile
            .withUnretained(self)
            .flatMap { owner, file -> Maybe<URLString> in
                // 파일 다운로드에 대한 Alert을 보여주고, 유저가 "다운로드" 를 클릭했을 경우 다음 시퀸스로 이동.
                owner.confirmActionWithAlert(urlString: file.url, alertConfiguration: .downloadFile)
            }
            .withUnretained(self)
            .flatMap { owner, urlString -> Observable<Result<URL, Error>> in
                owner.downloadFileUseCase.download(from: urlString).toResult()  // 다운로드 진행
            }
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .success(let url):
                    downloadedFile.onNext(url)
                    
                case .failure(let error):
                    owner.coordinator?.showErrorAlert(configuration: ErrorAlertConfiguration(
                        title: "파일 다운로드에 실패했습니다.",
                        description: error.localizedDescription
                    ))
                }
            })
            .disposed(by: disposeBag)
        
        return Output(
            profile: profile.asDriver(), 
            profileOwner: Observable.just(profileOwner).asDriver(onErrorJustReturn: .me),
            downloadedFile: downloadedFile
        )
    }
}

// MARK: - ErrorHandling
extension ProfileViewModel {
    /// 네트워킹 에러에 대한 핸들링
    private func handleNetworkError(_ error: Error) {
        // 내 프로필일 경우, 프로필 등록을 할 것인지 Alert
        // 다른 유저의 프로필일 경우, 즉시 Error
        switch profileOwner {
        case .me:
            // 404일 경우, 프로필 등록 이동
            if let networkError = error as? NetworkError, case .statusCode(404) = networkError {
                showCreateProfileAlert()
            } else {
                showErrorAlert(error)
            }
            
        case .other:
            showErrorAlert(error)
        }
    }
    
    /// 프로필 등록 이동에 대한 Alert
    private func showCreateProfileAlert() {
        coordinator?.showAlert(
            configuration: .createProfile,
            primaryAction: { [weak self] in
                self?.coordinator?.showCreateProfileViewController()
            },
            cancelAction: { [weak self] in
                self?.coordinator?.pop()
            }
        )
    }
    
    private func showErrorAlert(_ error: Error) {
        coordinator?.showErrorAlert(
            configuration: ErrorAlertConfiguration(
                title: "프로필 조회에 실패했습니다.",
                description: error.localizedDescription
            ),
            primaryAction: { [weak self] in self?.coordinator?.pop() }
        )
    }
}

// MARK: - Alert 대응 처리
extension ProfileViewModel {
    /// 특정 작업의 수행을 확인하는 Alert을 보여주고, 유저의 액션에 따라 이벤트의 전달여부를 결정
    private func confirmActionWithAlert(
        urlString: URLString,
        alertConfiguration: AlertConfiguration
    ) -> Maybe<URLString> {
        
        Maybe<URLString>.create { [weak self] maybe in
            guard let self else {
                maybe(.completed)
                return Disposables.create()
            }
            
            self.coordinator?.showAlert(
                configuration: alertConfiguration,
                primaryAction: {
                    maybe(.success(urlString))
                },
                cancelAction: {
                    maybe(.completed)
                }
            )
            
            return Disposables.create()
        }
    }
}

extension ProfileViewModel {
    enum ProfileOwner {
        case me
        case other(userID: Int)
    }
}
