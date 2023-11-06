//
//  MessageViewModel.swift
//  Bridge
//
//  Created by 정호윤 on 10/16/23.
//

import RxCocoa
import RxSwift

final class MessageViewModel: ViewModelType {
    // MARK: - Input & Output
    struct Input {
        let viewWillAppear: Observable<Bool>
        let profileButtonTapped: Observable<Void>
        let dropdownMenuItemSelected: Observable<String>
        let sendMessage: Observable<String>
    }
    
    struct Output {
        let chatRoom: Driver<ChatRoom>
        let messages: Driver<[Message]>
    }
    
    // MARK: - Property
    let disposeBag = DisposeBag()
    private weak var coordinator: ChatCoordinator?
    private let chatRoom: ChatRoom
    private let observeMessageUseCase: ObserveMessageUseCase
    
    // MARK: - Init
    init(
        coordinator: ChatCoordinator?,
        chatRoom: ChatRoom,
        observeMessageUseCase: ObserveMessageUseCase
    ) {
        self.coordinator = coordinator
        self.chatRoom = chatRoom
        self.observeMessageUseCase = observeMessageUseCase
    }
    
    // MARK: - Transformation
    func transform(input: Input) -> Output {
        let messages = input.viewWillAppear
            .withUnretained(self)
            .flatMap { owner, _ in
                owner.observeMessageUseCase.observe(chatRoomID: owner.chatRoom.id)
            }
        
        input.profileButtonTapped
            .withUnretained(self)
            .subscribe(onNext: { _, _ in
                print("profile button tapped")  // 프로필 뷰 show
            })
            .disposed(by: disposeBag)
        
        input.dropdownMenuItemSelected
            .withUnretained(self)
            .subscribe(onNext: { owner, itemTitle in
                switch itemTitle {
                case "채팅방 나가기":
                    owner.coordinator?.showAlert(configuration: .leaveChatRoom) { }
                    
                case "신고하기":
                    owner.coordinator?.showAlert(configuration: .report) { }
                    
                default:
                    break
                }
            })
            .disposed(by: disposeBag)
        
        input.sendMessage
            .withUnretained(self)
            .subscribe(onNext: { _, _ in
                
            })
            .disposed(by: disposeBag)
        
        return Output(
            chatRoom: Driver.just(chatRoom),
            messages: messages.asDriver(onErrorJustReturn: [.onError])
        )
    }
}

// MARK: - Data source
extension MessageViewModel {
    enum Section {
        case main
    }
}
