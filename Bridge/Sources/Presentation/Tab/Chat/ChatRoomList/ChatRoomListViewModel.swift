//
//  ChatRoomListViewModel.swift
//  Bridge
//
//  Created by 정호윤 on 2023/08/28.
//

import Foundation
import RxCocoa
import RxSwift

final class ChatRoomListViewModel: ViewModelType {
    
    struct Input {
        let itemSelected: Observable<IndexPath>
        let leaveChatRoomTrigger: PublishRelay<IndexPath>
    }
    
    struct Output {
        let chatRooms: Driver<[ChatRoom]>
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
        
        fetchChatRooms()
            .bind(to: chatRooms)
            .disposed(by: disposeBag)
        
        input.itemSelected
            .withLatestFrom(chatRooms) { indexPath, chatRooms in
                chatRooms[indexPath.row]
            }
            .withUnretained(self)
            .subscribe(onNext: { _, chatRoom in
                self.coordinator?.showChatRoomDetailViewController(of: chatRoom)
            })
            .disposed(by: disposeBag)
        
        input.leaveChatRoomTrigger
            .withLatestFrom(chatRooms) { indexPath, chatRooms in
                chatRooms[indexPath.row]
            }
            .withUnretained(self)
            .flatMap { _, chatRoom in
                self.leaveChatRoomUseCase.execute(id: chatRoom.id)
            }
            .flatMap { _ in
                self.fetchChatRooms()
            }
            .bind(to: chatRooms)
            .disposed(by: disposeBag)
        
        return Output(chatRooms: chatRooms.asDriver(onErrorJustReturn: [ChatRoom.onError]))
    }
}

extension ChatRoomListViewModel {
    private func fetchChatRooms() -> Observable<[ChatRoom]> {
        fetchChatRoomsUseCase.execute()
    }
}
