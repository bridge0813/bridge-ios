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
        var leaveChatRoomTrigger: PublishRelay<Int>
    }
    
    struct Output {
        var chatRooms: Driver<[ChatRoom]>
    }
    
    let disposeBag = DisposeBag()
    
    private weak var coordinator: ChatCoordinator?
    private let observeChatRoomsUseCase: ObserveChatRoomsUseCase
    private let leaveChatRoomUseCase: LeaveChatRoomUseCase
    
    init(
        coordinator: ChatCoordinator,
        observeChatRoomsUseCase: ObserveChatRoomsUseCase,
        leaveChatRoomUseCase: LeaveChatRoomUseCase
    ) {
        self.coordinator = coordinator
        self.observeChatRoomsUseCase = observeChatRoomsUseCase
        self.leaveChatRoomUseCase = leaveChatRoomUseCase
    }
    
    func transform(input: Input) -> Output {
        let chatRooms = observeChatRoomsUseCase.execute().share()
        // TODO: Input handling
        return Output(chatRooms: chatRooms.asDriver(onErrorJustReturn: [ChatRoom.onError]))
    }
}

// MARK: - Coordinator
extension ChatRoomListViewModel {
    func showChatRoomDetailViewController(of chatRoom: ChatRoom) {
        coordinator?.showChatRoomDetailViewController()
    }
}
