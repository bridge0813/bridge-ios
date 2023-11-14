//
//  MyPageViewModel.swift
//  Bridge
//
//  Created by 정호윤 on 11/6/23.
//

import UIKit
import RxSwift

final class MyPageViewModel: ViewModelType {
    // MARK: - Input & Output
    struct Input {
        let viewWillAppear: Observable<Bool>
        let bellButtonTapped: Observable<Void>
        let interestedFieldButtonTapped: Observable<Void>
        let bookmarkedProjectButtonTapped: Observable<Void>
        let itemSelected: Observable<Int>
    }
    
    struct Output { 
        let menus: Observable<[String]>
    }
    
    // MARK: - Property
    let disposeBag = DisposeBag()
    private weak var coordinator: MyPageCoordinator?
    
    // MARK: - Init
    init(coordinator: MyPageCoordinator) {
        self.coordinator = coordinator
    }
    
    // MARK: - Transformation
    func transform(input: Input) -> Output {
        var menus = Menu.allCases.map { $0.rawValue }
        
        input.viewWillAppear
            .withUnretained(self)
            .subscribe(onNext: { _, _ in
                
            })
            .disposed(by: disposeBag)
        
        input.bellButtonTapped
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.coordinator?.showPushAlertViewController()
            })
            .disposed(by: disposeBag)
        
        input.interestedFieldButtonTapped
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.coordinator?.showSetInterestedFieldViewController()
            })
            .disposed(by: disposeBag)
        
        input.bookmarkedProjectButtonTapped
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.coordinator?.showBookmarkedProjectsViewController()
            })
            .disposed(by: disposeBag)
        
        input.itemSelected
            .map { Menu.allCases[$0] }
            .withUnretained(self)
            .subscribe(onNext: { owner, menu in
                owner.handleMenuSelection(menu)
            })
            .disposed(by: disposeBag)
        
        return Output(menus: .just(menus))
    }
}

// MARK: - Menu selection handling
private extension MyPageViewModel {
    enum Menu: String, CaseIterable {
        case signIn = "로그인"
        case signOut = "로그아웃"
        case notification = "알림설정"
        case privacyPolicy = "개인정보처리방침"
        case versionInfo = "버전정보 1.0.0"
        case openSourceLicense = "오픈소스 라이선스"
        case withdrawal = "회원탈퇴"
    }
    
    func handleMenuSelection(_ menu: Menu) {
        switch menu {
        case .signIn:
            coordinator?.showSignInViewController()
            
        case .signOut:
            coordinator?.showAlert(configuration: .signOut)
            
        case .notification:
            coordinator?.openSettings()
            
        case .privacyPolicy:
            coordinator?.showPrivacyPolicy()
            
        case .versionInfo:
            break
            
        case .openSourceLicense:
            coordinator?.showOpenSourceLicense()
            
        case .withdrawal:
            coordinator?.showAlert(configuration: .withdrawal)
        }
    }
}
