//
//  MyPageViewModel.swift
//  Bridge
//
//  Created by 정호윤 on 11/6/23.
//

import UIKit
import RxCocoa
import RxSwift

final class MyPageViewModel: ViewModelType {
    // MARK: - Input & Output
    struct Input {
        let viewWillAppear: Observable<Bool>
        let bellButtonTapped: Observable<Void>
        let interestedFieldButtonTapped: Observable<Void>
        let bookmarkedProjectButtonTapped: Observable<Void>
        let manageProfileButtonTapped: Observable<Void>
        let itemSelected: Observable<Int>
    }
    
    struct Output {
        let viewState: Driver<ViewState>
        let menus: BehaviorRelay<[String]>
    }
    
    // MARK: - Property
    let disposeBag = DisposeBag()
    private weak var coordinator: MyPageCoordinator?
    private let fetchProfilePreviewUseCase: FetchProfilePreviewUseCase
    private let signOutUseCase: SignOutUseCase
    private let withdrawUseCase: WithdrawUseCase
    
    private let viewState = BehaviorRelay<ViewState>(value: .unauthorized)
    private let menus = BehaviorRelay<[String]>(value: Menu.unauthorizedCases.map { $0.rawValue })
    
    // MARK: - Init
    init(
        coordinator: MyPageCoordinator,
        fetchProfilePreviewUseCase: FetchProfilePreviewUseCase,
        signOutUseCase: SignOutUseCase,
        withdrawUseCase: WithdrawUseCase
    ) {
        self.coordinator = coordinator
        self.fetchProfilePreviewUseCase = fetchProfilePreviewUseCase
        self.signOutUseCase = signOutUseCase
        self.withdrawUseCase = withdrawUseCase
    }
    
    // MARK: - Transformation
    func transform(input: Input) -> Output {
        input.viewWillAppear
            .withUnretained(self)
            .flatMap { owner, _ in
                owner.fetchProfilePreviewUseCase.fetchProfilePreview().toResult()
            }
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .success(let profilePreview):
                    owner.viewState.accept(.authorized(profilePreview))
                    owner.updateMenus(for: .authorized(profilePreview))
                    
                case .failure:
                    owner.viewState.accept(.unauthorized)
                    owner.updateMenus(for: .unauthorized)
                }
            })
            .disposed(by: disposeBag)
        
        input.bellButtonTapped
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                // TODO: - 임시
                owner.coordinator?.showProfileViewController(with: .me)
            })
            .disposed(by: disposeBag)
        
        input.interestedFieldButtonTapped
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.coordinator?.showMyFieldViewController()
            })
            .disposed(by: disposeBag)
        
        input.bookmarkedProjectButtonTapped
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.coordinator?.showBookmarkedProjectViewController()
            })
            .disposed(by: disposeBag)
        
        input.manageProfileButtonTapped
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.coordinator?.showProfileViewController(with: .me)
            })
            .disposed(by: disposeBag)
        
        input.itemSelected
            .withUnretained(self)
            .map { owner, index in
                switch owner.viewState.value {
                case .unauthorized:
                    return Menu.unauthorizedCases[index]
                    
                case .authorized:
                    return Menu.authorizedCases[index]
                }
            }
            .withUnretained(self)
            .subscribe(onNext: { owner, menu in
                owner.handleMenuSelection(menu)
            })
            .disposed(by: disposeBag)
        
        return Output(
            viewState: viewState.asDriver(onErrorJustReturn: .unauthorized),
            menus: menus
        )
    }
}

// MARK: - View state
extension MyPageViewModel {
    enum ViewState {
        case unauthorized
        case authorized(ProfilePreview)
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
        
        // 비로그인 상태의 메뉴
        static var unauthorizedCases: [Menu] {
            [.signIn, .notification, .privacyPolicy, .versionInfo, .openSourceLicense]
        }
        
        // 로그인 상태의 메뉴
        static var authorizedCases: [Menu] {
            [.notification, .privacyPolicy, .versionInfo, .openSourceLicense, .signOut, .withdrawal]
        }
    }
    
    func updateMenus(for viewState: ViewState) {
        switch viewState {
        case .unauthorized:
            menus.accept(Menu.unauthorizedCases.map { $0.rawValue })
            
        case .authorized:
            menus.accept(Menu.authorizedCases.map { $0.rawValue })
        }
    }
    
    func handleMenuSelection(_ menu: Menu) {
        switch menu {
        case .signIn:
            coordinator?.showSignInViewController()
            
        case .signOut:
            coordinator?.showAlert(configuration: .signOut, primaryAction: { [weak self] in
                guard let self else { return }
                
                self.signOutUseCase.signOut()
                    .withUnretained(self)
                    .subscribe(onNext: { owner, _ in
                        owner.viewState.accept(.unauthorized)
                        owner.updateMenus(for: .unauthorized)
                    })
                    .disposed(by: disposeBag)
            })
            
        case .notification:
            coordinator?.openSettings()
            
        case .privacyPolicy:
            coordinator?.showPrivacyPolicy()
            
        case .versionInfo:
            return
            
        case .openSourceLicense:
            coordinator?.showOpenSourceLicense()
            
        case .withdrawal:
            coordinator?.showAlert(configuration: .withdrawal, primaryAction: { [weak self] in
                guard let self else { return }
                
                self.withdrawUseCase.withdraw()
                    .withUnretained(self)
                    .subscribe(onNext: { owner, _ in
                        owner.viewState.accept(.unauthorized)
                        owner.updateMenus(for: .unauthorized)
                    })
                    .disposed(by: disposeBag)
            })
        }
    }
}
