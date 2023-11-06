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
        let chatRoomsRelay = BehaviorRelay<[ChatRoom]>(value: [])
        let viewState = BehaviorRelay<ViewState>(value: .general)
        
        input.viewWillAppear
            .withUnretained(self)
            .flatMap { owner, _ in
                owner.fetchChatRoomsUseCase.fetchChatRooms()
            }
            .subscribe(
                onNext: { chatRooms in
                    if chatRooms.isEmpty { viewState.accept(.empty) }
                    chatRoomsRelay.accept(chatRooms)
                },
                onError: { error in
                    switch error as? NetworkError {
                    case .statusCode(let statusCode):
                        return statusCode == 401 ? viewState.accept(.needSignIn) : viewState.accept(.error)
                        
                    default:
                        return viewState.accept(.error)
                    }
                }
            )
            .disposed(by: disposeBag)
        
        input.itemSelected
            .withLatestFrom(chatRoomsRelay) { index, chatRooms in
                chatRooms[index]
            }
            .withUnretained(self)
            .subscribe(onNext: { owner, chatRoom in               
                owner.coordinator?.showChatRoomViewController(of: chatRoom)
            })
            .disposed(by: disposeBag)
        
        input.leaveChatRoom
            .withLatestFrom(chatRoomsRelay) { index, chatRooms in
                chatRooms[index]
            }
            .withUnretained(self)
            .flatMap { owner, chatRoom in
                owner.leaveChatRoomUseCase.leaveChatRoom(id: chatRoom.id)
            }
            .withUnretained(self)
            .flatMap { owner, _ in
                owner.fetchChatRoomsUseCase.fetchChatRooms()
            }
            .bind(to: chatRoomsRelay)
            .disposed(by: disposeBag)
        
        return Output(
            chatRooms: chatRoomsRelay.asDriver(),
            viewState: viewState.asDriver()
        )
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
        case needSignIn
        case error
    }
}
