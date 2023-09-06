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
        let viewWillAppear: Observable<Bool>
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
        let chatRooms = input.viewWillAppear
            .withUnretained(self)
            .flatMap { owner, _ in
                owner.fetchChatRooms()
            }
        
        input.itemSelected
            .withLatestFrom(chatRooms) { indexPath, chatRooms in
                chatRooms[indexPath.row]
            }
            .withUnretained(self)
            .subscribe(onNext: { owner, chatRoom in
                owner.coordinator?.showChatRoomDetailViewController(of: chatRoom)
            })
            .disposed(by: disposeBag)
        
        let reloadedChatRooms = input.leaveChatRoomTrigger
            .withLatestFrom(chatRooms) { indexPath, chatRooms in
                chatRooms[indexPath.row]
            }
            .withUnretained(self)
            .flatMap { owner, chatRoom in
                owner.leaveChatRoomUseCase.execute(id: chatRoom.id)
            }
            .withUnretained(self)
            .flatMap { owner, _ in
                owner.fetchChatRooms()
            }
        
        return Output(chatRooms: Observable.merge(chatRooms, reloadedChatRooms)
            .asDriver(onErrorJustReturn: [ChatRoom.onError])
        )
    }
}

extension ChatRoomListViewModel {
    private func fetchChatRooms() -> Observable<[ChatRoom]> {
        fetchChatRoomsUseCase.execute()
    }
}

// MARK: Data source
extension ChatRoomListViewModel {
    enum Section: CaseIterable {
        case main
    }
}
