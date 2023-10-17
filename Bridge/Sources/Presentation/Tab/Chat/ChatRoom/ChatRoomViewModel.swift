//
//  ChatRoomViewModel.swift
//  Bridge
//
//  Created by 정호윤 on 10/16/23.
//

import RxCocoa
import RxSwift

final class ChatRoomViewModel: ViewModelType {
    
    struct Input {
        let sendMessage: Observable<String>
    }
    
    struct Output {
        let messages: Driver<String>
    }
    
    let disposeBag = DisposeBag()
    
    private weak var coordinator: ChatCoordinator?
    private let chatRoom: ChatRoom
    
    init(coordinator: ChatCoordinator?, chatRoom: ChatRoom) {
        self.coordinator = coordinator
        self.chatRoom = chatRoom
    }
    
    // TODO: observe use case, message 타입 사용
    func transform(input: Input) -> Output {
        input.sendMessage
            .withUnretained(self)
            .subscribe(onNext: { _, _ in
                
            })
            .disposed(by: disposeBag)
        
        let message = input.sendMessage
        
        return Output(messages: message.asDriver(onErrorJustReturn: ""))
    }
}
