//
//  ChatRoomListViewModel.swift
//  Bridge
//
//  Created by 정호윤 on 2023/08/28.
//

import RxCocoa
import RxSwift

final class ChatRoomListViewModel: ViewModelType {
    
    struct Input {
        let viewWillAppear: Observable<Bool>
        let itemSelected: Observable<Int>
        let leaveChatRoom: Observable<Int>
    }
    
    struct Output {
        let chatRooms: Driver<[ChatRoom]>
        let viewState: Driver<ViewState>
    }
    
    let disposeBag = DisposeBag()
    
    private weak var coordinator: ChatCoordinator?
    private let fetchChatRoomsUseCase: FetchChatRoomsUseCase
    private let leaveChatRoomUseCase: LeaveChatRoomUseCase
    
    init(
        coordinator: ChatCoordinator,
        fetchChatRoomsUseCase: FetchChatRoomsUseCase,
        leaveChatRoomUseCase: LeaveChatRoomUseCase
    ) {
        self.coordinator = coordinator
        self.fetchChatRoomsUseCase = fetchChatRoomsUseCase
        self.leaveChatRoomUseCase = leaveChatRoomUseCase
    }
    
    func transform(input: Input) -> Output {
        let chatRooms = BehaviorRelay<[ChatRoom]>(value: [])
        let viewState = BehaviorRelay<ViewState>(value: .general)
        
        input.viewWillAppear
            .withUnretained(self)
            .flatMapLatest { owner, _ in
                owner.fetchChatRooms()
            }
            .bind(to: chatRooms)
            .disposed(by: disposeBag)

        
        input.itemSelected
            .withLatestFrom(chatRooms) { index, chatRooms in
                chatRooms[index]
            }
            .withUnretained(self)
            .subscribe(onNext: { owner, chatRoom in
                owner.coordinator?.showChatRoomDetailViewController(of: chatRoom)  // 임시

                owner.coordinator?.showAlert(configuration: .signIn) {  // 테스트용
                    owner.coordinator?.showSignInViewController()
                }
            })
            .disposed(by: disposeBag)
        
        input.leaveChatRoom
            .withLatestFrom(chatRooms) { index, chatRooms in
                chatRooms[index]
            }
            .withUnretained(self)
            .flatMap { owner, chatRoom in
                owner.leaveChatRoomUseCase.execute(id: chatRoom.id)
            }
            .withUnretained(self)
            .flatMap { owner, _ in  // 다시 fetch 해오는게 맞을지 고민
                owner.fetchChatRooms()
            }
            .bind(to: chatRooms)
            .disposed(by: disposeBag)
        
        // 뷰 상태 결정
        // tbd
        
        return Output(
            chatRooms: chatRooms.asDriver(),
            viewState: viewState.asDriver(onErrorJustReturn: .error)
        )
    }
}

private extension ChatRoomListViewModel {
    func fetchChatRooms() -> Observable<[ChatRoom]> {
        fetchChatRoomsUseCase.execute()
    }
    
    func configureViewState(userAuthState: UserAuthState, chatRooms: [ChatRoom]) -> ViewState {
        switch userAuthState {
        case .signedIn:     return chatRooms.isEmpty ? .empty : .general
        case .notSignedIn:  return .notSignedIn
        case .error:        return .error
        }
    }

}

// MARK: Data source
extension ChatRoomListViewModel {
    enum Section: CaseIterable {
        case main
    }
    
    /// ChatRoomListTableView에서 보여줘야 하는 화면을 결정
    enum ViewState {
        case general
        case empty
        case notSignedIn
        case error
    }
}
