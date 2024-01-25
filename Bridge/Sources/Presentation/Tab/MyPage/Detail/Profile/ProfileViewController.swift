//
//  ProfileViewController.swift
//  Bridge
//
//  Created by 정호윤 on 12/14/23.
//

import UIKit

final class ProfileViewController: BaseProfileViewController {
    // MARK: - Property
    private let viewModel: ProfileViewModel
    
    // MARK: - Init
    init(viewModel: ProfileViewModel) {
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: editProfileButton)
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
        let input = ProfileViewModel.Input(
            viewWillAppear: self.rx.viewWillAppear.asObservable(),
            editProfileButtonTapped: editProfileButton.rx.tap,
            selectedLinkURL: selectedLinkURL,
            selectedFile: selectedFile
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
