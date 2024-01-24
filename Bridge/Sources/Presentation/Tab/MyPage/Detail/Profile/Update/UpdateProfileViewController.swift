//
//  UpdateProfileViewController.swift
//  Bridge
//
//  Created by 엄지호 on 1/1/24.
//

import UIKit
import FlexLayout
import PinLayout
import RxCocoa
import RxSwift

final class UpdateProfileViewController: BaseProfileEditorViewController {
    // MARK: - Property
    private let viewModel: UpdateProfileViewModel
    
    // MARK: - Init
    init(viewModel: UpdateProfileViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    // MARK: - Configuration
    override func configureAttributes() {
        super.configureAttributes()
        navigationItem.title = "프로필 편집"
    }
    
    // MARK: - Layout
    override func configureLayouts() {
        super.configureLayouts()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    // MARK: - Binding
    override func bind() {
        super.bind()
        
        let input = UpdateProfileViewModel.Input(
            addedProfileImage: addedProfileImage,
            nameChanged: nameChanged,
            selectedCareer: careerButtonTapped,
            introductionChanged: introductionChanged,
            addedFieldTechStack: addedFieldTechStack,
            deletedFieldTechStack: deletedFieldTechStack,
            updatedFieldTechStack: updatedFieldTechStack,
            addedLinkURL: addedLinkURL,
            deletedLinkURL: deletedLinkURL,
            addedFile: addedFile,
            deletedFile: deletedFile,
            completeButtonTapped: completeButtonTapped
        )
        let output = viewModel.transform(input: input)
        
        // 기존 설정된 프로필 데이터
        output.profile
            .drive(onNext: { [weak self] profile in
                guard let self else { return }
                self.configure(with: profile)
            })
            .disposed(by: disposeBag)
    }
}
