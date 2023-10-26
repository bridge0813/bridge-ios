//
//  MessageViewModel.swift
//  Bridge
//
//  Created by 정호윤 on 10/16/23.
//

import RxCocoa
import RxSwift

final class MessageViewModel: ViewModelType {
    
    struct Input {
        let viewWillAppear: Observable<Bool>
        let menuDropdownItemSelected: Observable<String>
        let sendMessage: Observable<String>
    }
    
    struct Output {
        let messages: Driver<[Message]>
    }
    
    let disposeBag = DisposeBag()
    
    private weak var coordinator: ChatCoordinator?
    private let chatRoom: ChatRoom
    private let observeMessageUseCase: ObserveMessageUseCase
    
    init(
        coordinator: ChatCoordinator?,
        chatRoom: ChatRoom,
        observeMessageUseCase: ObserveMessageUseCase
    ) {
        self.coordinator = coordinator
        self.chatRoom = chatRoom
        self.observeMessageUseCase = observeMessageUseCase
    }
    
    func transform(input: Input) -> Output {
        let messages = input.viewWillAppear
            .withUnretained(self)
            .flatMap { owner, _ in
                owner.observeMessageUseCase.observe(chatRoomID: owner.chatRoom.id)
            }
        
        input.menuDropdownItemSelected
            .withUnretained(self)
            .subscribe(onNext: { owner, item in
                print(item)
            })
            .disposed(by: disposeBag)
        
        input.sendMessage
            .withUnretained(self)
            .subscribe(onNext: { _, _ in
                
            })
            .disposed(by: disposeBag)
        
        return Output(messages: messages.asDriver(onErrorJustReturn: [.onError]))
    }
}

extension MessageViewModel {
    enum Section {
        case main
    }
}
