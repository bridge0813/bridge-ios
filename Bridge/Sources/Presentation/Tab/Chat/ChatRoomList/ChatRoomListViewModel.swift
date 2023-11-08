//
//  ChatRoomListViewModel.swift
//  Bridge
//
//  Created by 정호윤 on 2023/08/28.
//

import RxCocoa
import RxSwift

final class ChatRoomListViewModel: ViewModelType {
    // MARK: - Input & Output
    struct Input {
        let viewWillAppear: Observable<Bool>
        let itemSelected: Observable<Int>
        let leaveChatRoom: Observable<Int>
    }
    
    struct Output {
        let chatRooms: Driver<[ChatRoom]>
        let viewState: Driver<ViewState>
    }
    
    // MARK: - Property
    let disposeBag = DisposeBag()
    private weak var coordinator: ChatCoordinator?
    private let fetchChatRoomsUseCase: FetchChatRoomsUseCase
    private let leaveChatRoomUseCase: LeaveChatRoomUseCase
    
    // MARK: - Init
    init(
        coordinator: ChatCoordinator,
        fetchChatRoomsUseCase: FetchChatRoomsUseCase,
        leaveChatRoomUseCase: LeaveChatRoomUseCase
    ) {
        self.coordinator = coordinator
        self.fetchChatRoomsUseCase = fetchChatRoomsUseCase
        self.leaveChatRoomUseCase = leaveChatRoomUseCase
    }
    
    // MARK: - Transformation
    func transform(input: Input) -> Output {
        let chatRoomsRelay = BehaviorRelay<[ChatRoom]>(value: [])
        let viewState = BehaviorRelay<ViewState>(value: .general)
        
        input.viewWillAppear
            .withUnretained(self)
            .flatMap { owner, _ in
                owner.fetchChatRoomsUseCase.fetchChatRooms().toResult()
            }
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .success(let chatRooms):
                    viewState.accept(chatRooms.isEmpty ? .empty : .general)
                    chatRoomsRelay.accept(chatRooms)
                    
                case .failure(let error):
                    owner.handleError(error, viewState: viewState)
                }
            })
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

// MARK: - View state handling
extension ChatRoomListViewModel {
    /// ChatRoomListViewController에서 보여줘야 하는 화면의 종류
    enum ViewState {
        case general
        case empty
        case signInNeeded
        case error
    }
    
    private func handleError(_ error: Error, viewState: BehaviorRelay<ViewState>) {
        switch error as? NetworkError {
        case .statusCode(let statusCode):
            viewState.accept(statusCode == 401 ? .signInNeeded : .error)
            
        default:
            viewState.accept(.error)
        }
    }
}

// MARK: - Data source
extension ChatRoomListViewModel {
    enum Section: CaseIterable {
        case main
    }
}
