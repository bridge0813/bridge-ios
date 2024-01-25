//
//  OtherUserProfileViewModel.swift
//  Bridge
//
//  Created by 엄지호 on 1/25/24.
//

import Foundation
import RxCocoa
import RxSwift

final class OtherUserProfileViewModel: ViewModelType {
    // MARK: - Input & Output
    struct Input {
        let viewWillAppear: Observable<Bool>
        let selectedLinkURL: Observable<String>      // 링크 이동
        let selectedFile: Observable<ReferenceFile>  // 파일 이동
        let viewDidDisappear: Observable<Bool>
    }
    
    struct Output {
        let profile: Driver<Profile>
        let downloadedFile: Observable<URL>
    }
    
    // MARK: - Property
    let disposeBag = DisposeBag()
    private weak var coordinator: MyPageCoordinator?
    
    private let userID: Int
    private let fetchProfileUseCase: FetchProfileUseCase
    private let downloadFileUseCase: DownloadFileUseCase
    
    // MARK: - Init
    init(
        coordinator: MyPageCoordinator,
        userID: Int,
        fetchProfileUseCase: FetchProfileUseCase,
        downloadFileUseCase: DownloadFileUseCase
    ) {
        self.coordinator = coordinator
        self.userID = userID
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
                return owner.fetchProfileUseCase.fetchOtherUserProfile(userID: owner.userID).toResult()
            }
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .success(let profileData):
                    profile.accept(profileData)
                    
                case .failure(let error):
                    owner.coordinator?.showErrorAlert(
                        configuration: ErrorAlertConfiguration(
                            title: "프로필 조회에 실패했습니다.",
                            description: error.localizedDescription
                        ),
                        primaryAction: { [weak self] in self?.coordinator?.pop() }
                    )
                }
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
        
        // 뷰가 Disappear 될 때, 코디네이터 할당제거
        input.viewDidDisappear
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                if let didFinish = owner.coordinator?.didFinishEventClosure {
                    didFinish()
                }
            })
            .disposed(by: disposeBag)
        
        return Output(
            profile: profile.asDriver(),
            downloadedFile: downloadedFile
        )
    }
}

// MARK: - Alert 대응 처리
extension OtherUserProfileViewModel {
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
