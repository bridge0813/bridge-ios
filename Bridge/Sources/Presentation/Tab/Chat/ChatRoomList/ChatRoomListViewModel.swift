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
    
    // TODO: apns 들어오면 구조 바꿔야할수도
    // TODO: 뷰컨에서 채팅방 0개일 때에 대한 플레이스홀더 디자인 필요할듯
    func transform(input: Input) -> Output {
        let chatRooms = BehaviorRelay<[ChatRoom]>(value: [])
        
        input.viewWillAppear
            .withUnretained(self)
            .flatMapLatest { owner, _ in
                owner.fetchChatRooms()
            }
            .bind(to: chatRooms)
            .disposed(by: disposeBag)
        
        input.itemSelected
            .withLatestFrom(chatRooms) { indexPath, chatRooms in
                chatRooms[indexPath.row]
            }
            .withUnretained(self)
            .subscribe(onNext: { owner, chatRoom in
                owner.coordinator?.showChatRoomDetailViewController(of: chatRoom)  // 임시
            })
            .disposed(by: disposeBag)
        
        input.leaveChatRoomTrigger
            .withLatestFrom(chatRooms) { indexPath, chatRooms in
                chatRooms[indexPath.row]
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
        
        return Output(chatRooms: chatRooms.asDriver(onErrorJustReturn: [ChatRoom.onError]))
    }
}

extension ChatRoomListViewModel {
    private func fetchChatRooms() -> Observable<[ChatRoom]> {
        return fetchChatRoomsUseCase.execute()
    }
}

// MARK: Data source
extension ChatRoomListViewModel {
    enum Section: CaseIterable {
        case main
    }
}
