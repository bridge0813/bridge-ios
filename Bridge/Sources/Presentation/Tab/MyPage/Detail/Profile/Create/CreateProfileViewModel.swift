//
//  CreateProfileViewModel.swift
//  Bridge
//
//  Created by 엄지호 on 1/12/24.
//

import UIKit
import RxCocoa
import RxSwift

final class CreateProfileViewModel: ViewModelType {
    // MARK: - Input & Output
    struct Input {
        let addedProfileImage: Observable<UIImage?>                               // 이미지 추가
        let nameChanged: Observable<String>                                       // 이름 변경
        let selectedCareer: Observable<String>                                    // 경력 선택
        let introductionChanged: Observable<String>                               // 소개 변경
        let addedFieldTechStack: Observable<FieldTechStack>                       // 기술스택 추가
        let deletedFieldTechStack: Observable<IndexRow>                           // 기술스택 삭제
        let updatedFieldTechStack: Observable<(IndexRow, FieldTechStack)>         // 기술스택 수정
        let addedLinkURL: Observable<String>                                      // 링크 추가
        let deletedLinkURL: Observable<IndexRow>                                  // 링크 삭제
        let addedFile: Observable<Result<ReferenceFile, FileProcessingError>>     // 파일 추가
        let deletedFile: Observable<IndexRow>                                     // 파일 삭제
        let completeButtonTapped: Observable<Void>                                // 수정 완료
    }
    
    struct Output {
        let profile: Driver<Profile>
    }
    
    // MARK: - Property
    let disposeBag = DisposeBag()
    private weak var coordinator: MyPageCoordinator?
    
    private let fetchProfilePreviewUseCase: FetchProfilePreviewUseCase
    private let createProfileUseCase: CreateProfileUseCase
    
    // MARK: - Init
    init(
        coordinator: MyPageCoordinator,
        fetchProfilePreviewUseCase: FetchProfilePreviewUseCase,
        createProfileUseCase: CreateProfileUseCase
    ) {
        self.coordinator = coordinator
        self.fetchProfilePreviewUseCase = fetchProfilePreviewUseCase
        self.createProfileUseCase = createProfileUseCase
    }
    
    // MARK: - Transformation
    func transform(input: Input) -> Output {
        let profileRelay = BehaviorRelay<Profile>(value: Profile.onError)
        
        // 유저의 간략 정보 조회(이름, 관심분야)
        fetchProfilePreviewUseCase.fetchProfilePreview()
            .toResult()
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                owner.handleFetchProfilePreviewResult(for: result, profileRelay: profileRelay)
            })
            .disposed(by: disposeBag)
        
        // 프로필 이미지 설정
        input.addedProfileImage
            .subscribe(onNext: { image in
                var profile = profileRelay.value
                profile.updatedImage = image
                profileRelay.accept(profile)
            })
            .disposed(by: disposeBag)
        
        // 이름 설정
        input.nameChanged
            .subscribe(onNext: { text in
                var profile = profileRelay.value
                profile.name = text
                profileRelay.accept(profile)
            })
            .disposed(by: disposeBag)
        
        // 직업 설정
        input.selectedCareer
            .subscribe(onNext: { career in
                var profile = profileRelay.value
                profile.career = career
                profileRelay.accept(profile)
            })
            .disposed(by: disposeBag)
        
        // 소개 설정
        input.introductionChanged
            .subscribe(onNext: { text in
                var profile = profileRelay.value
                profile.introduction = text
                profileRelay.accept(profile)
            })
            .disposed(by: disposeBag)
        
        // 분야 및 기술 스택 추가
        input.addedFieldTechStack
            .subscribe(onNext: { fieldTechStack in
                var profile = profileRelay.value
                profile.fieldTechStacks.append(fieldTechStack)
                profileRelay.accept(profile)
            })
            .disposed(by: disposeBag)
        
        // 분야 및 기술 스택 삭제
        input.deletedFieldTechStack
            .subscribe(onNext: { indexRow in
                var profile = profileRelay.value
                profile.fieldTechStacks.remove(at: indexRow)
                profileRelay.accept(profile)
            })
            .disposed(by: disposeBag)
        
        // 분야 및 기술 스택 수정
        input.updatedFieldTechStack
            .subscribe(onNext: { element in
                let (indexRow, fieldTeckStack) = element
                
                var profile = profileRelay.value
                profile.fieldTechStacks[indexRow] = fieldTeckStack
                profileRelay.accept(profile)
            })
            .disposed(by: disposeBag)
        
        // 링크 추가
        input.addedLinkURL
            .subscribe(onNext: { url in
                var profile = profileRelay.value
                profile.links.append(url)
                profileRelay.accept(profile)
            })
            .disposed(by: disposeBag)
        
        // 링크 삭제
        input.deletedLinkURL
            .subscribe(onNext: { indexRow in
                var profile = profileRelay.value
                profile.links.remove(at: indexRow)
                profileRelay.accept(profile)
            })
            .disposed(by: disposeBag)
        
        // 파일 추가
        input.addedFile
            .observe(on: MainScheduler.asyncInstance)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .success(let file):
                    var profile = profileRelay.value
                    profile.files.append(file)
                    profileRelay.accept(profile)
                    
                case .failure(let error):
                    owner.coordinator?.showErrorAlert(configuration: ErrorAlertConfiguration(
                        title: "오류",
                        description: error.localizedDescription
                    ))
                }
            })
            .disposed(by: disposeBag)
        
        // 파일 삭제
        input.deletedFile
            .subscribe(onNext: { indexRow in
                var profile = profileRelay.value
                profile.files.remove(at: indexRow)
                profileRelay.accept(profile)
            })
            .disposed(by: disposeBag)
        
        // 작성 완료
        input.completeButtonTapped
            .withUnretained(self)
            .flatMapLatest { owner, _ in
                return owner.createProfileUseCase.create(profileRelay.value).toResult()
            }
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .success:
                    owner.coordinator?.pop()
                    
                case .failure(let error):
                    owner.coordinator?.showErrorAlert(configuration: ErrorAlertConfiguration(
                        title: "프로필 등록에 실패했습니다.",
                        description: error.localizedDescription
                    ))
                }
            })
            .disposed(by: disposeBag)
        
        return Output(
            profile: profileRelay.asDriver(onErrorJustReturn: .onError)
        )
    }
}

extension CreateProfileViewModel {
    /// 유저정보 조회 결과 처리
    func handleFetchProfilePreviewResult(
        for result: Result<ProfilePreview, Error>,
        profileRelay: BehaviorRelay<Profile>
    ) {
        switch result {
        case .success(let profilePreview):
            let profile = Profile(
                imageURL: nil,
                name: profilePreview.name,
                fields: profilePreview.fields,
                fieldTechStacks: [],
                links: [],
                files: []
            )
            profileRelay.accept(profile)
            
        case .failure(let error):
            coordinator?.showErrorAlert(
                configuration: ErrorAlertConfiguration(
                    title: "유저정보 조회에 실패했습니다.",
                    description: error.localizedDescription
                ),
                primaryAction: { [weak self] in self?.coordinator?.pop() }
            )
        }
    }
}
