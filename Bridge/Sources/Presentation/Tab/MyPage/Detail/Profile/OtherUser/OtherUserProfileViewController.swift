//
//  OtherUserProfileViewController.swift
//  Bridge
//
//  Created by 엄지호 on 1/25/24.
//

import UIKit
import FlexLayout
import PinLayout
import RxCocoa
import RxSwift

/// 다른 유저의 프로필
final class OtherUserProfileViewController: BaseProfileViewController {
    // MARK: - Property
    private let viewModel: OtherUserProfileViewModel
    
    // MARK: - Init
    init(viewModel: OtherUserProfileViewModel) {
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
        let input = OtherUserProfileViewModel.Input(
            viewWillAppear: self.rx.viewWillAppear.asObservable(),
            selectedLinkURL: selectedLinkURL,
            selectedFile: selectedFile,
            viewDidDisappear: self.rx.viewDidDisappear.asObservable()
        )
        let output = viewModel.transform(input: input)
        
        // 프로필 정보
        output.profile
            .drive(onNext: { [weak self] profile in
                guard let self else { return }
                self.configure(with: profile)
            })
            .disposed(by: disposeBag)
        
        // 파일 보여주기
        output.downloadedFile
            .withUnretained(self)
            .subscribe(onNext: { owner, url in
                owner.pdfView.url = url
                owner.pdfView.show()
            })
            .disposed(by: disposeBag)
    }
}
