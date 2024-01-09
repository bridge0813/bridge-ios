//
//  EditProfileViewModel.swift
//  Bridge
//
//  Created by 엄지호 on 1/1/24.
//

import UIKit
import RxCocoa
import RxSwift

final class EditProfileViewModel: ViewModelType {
    // MARK: - Input & Output
    struct Input {
        let addedProfileImage: Observable<UIImage?>                               // 이미지 추가
        let addedFieldTechStack: Observable<FieldTechStack>                       // 기술스택 추가
        let deletedFieldTechStack: Observable<IndexRow>                           // 기술스택 삭제
        let updatedFieldTechStack: Observable<(IndexRow, FieldTechStack)>         // 기술스택 수정
        let addedLinkURL: Observable<String>                                      // 링크 추가
        let deletedLinkURL: Observable<IndexRow>                                  // 링크 삭제
        let selectedLinkURL: Observable<String>                                   // 링크 이동
        let addedFile: Observable<Result<ReferenceFile, FileProcessingError>>     // 파일 추가
        let deletedFile: Observable<IndexRow>                                     // 파일 삭제
        let selectedFile: Observable<ReferenceFile>                               // 파일 이동
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
        
        // 프로필 이미지 설정
        input.addedProfileImage
            .withUnretained(self)
            .subscribe(onNext: { owner, image in
                owner.profile.updatedImage = image
                profileRelay.accept(owner.profile)
            })
            .disposed(by: disposeBag)
        
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
        
        // 링크 추가
        input.addedLinkURL
            .withUnretained(self)
            .subscribe(onNext: { owner, url in
                owner.profile.links.append(url)
                profileRelay.accept(owner.profile)
            })
            .disposed(by: disposeBag)
        
        // 링크 삭제
        input.deletedLinkURL
            .withUnretained(self)
            .subscribe(onNext: { owner, indexRow in
                owner.profile.links.remove(at: indexRow)
                profileRelay.accept(owner.profile)
            })
            .disposed(by: disposeBag)
        
        // 링크 이동
        input.selectedLinkURL
            .withUnretained(self)
            .subscribe(onNext: { owner, url in
                owner.coordinator?.showReferenceLink(with: url)
            })
            .disposed(by: disposeBag)
        
        // 파일 추가
        input.addedFile
            .observe(on: MainScheduler.asyncInstance)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .success(let file):
                    owner.profile.files.append(file)
                    profileRelay.accept(owner.profile)
                    
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
            .withUnretained(self)
            .subscribe(onNext: { owner, indexRow in
                owner.profile.files.remove(at: indexRow)
                profileRelay.accept(owner.profile)
            })
            .disposed(by: disposeBag)
        
        
        return Output(
            profile: profileRelay.asDriver(onErrorJustReturn: .onError)
        )
    }
}
