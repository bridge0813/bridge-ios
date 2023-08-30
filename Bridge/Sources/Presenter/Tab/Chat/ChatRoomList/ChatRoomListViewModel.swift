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
        let chatRooms = fetchChatRoomsUseCase.execute().share()
        
        chatRooms.subscribe(onNext: { print($0) }).disposed(by: disposeBag)  // 연결 확인용
        // ...
        return Output(chatRooms: chatRooms.asDriver(onErrorJustReturn: [ChatRoom.onError]))
    }
}

// MARK: Coordinator
extension ChatRoomListViewModel {
    func showChatRoomDetailViewController(of chatRoom: ChatRoom) {
        coordinator?.showChatRoomDetailViewController()
    }
}
