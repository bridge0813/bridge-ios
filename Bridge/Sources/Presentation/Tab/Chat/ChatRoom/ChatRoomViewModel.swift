//
//  ChatRoomViewModel.swift
//  Bridge
//
//  Created by 정호윤 on 10/16/23.
//

import RxSwift

final class ChatRoomViewModel: ViewModelType {
    
    struct Input {
        let sendMessage: Observable<String>
    }
    
    struct Output { }
    
    let disposeBag = DisposeBag()
    
    private weak var coordinator: ChatCoordinator?
    private let chatRoom: ChatRoom
    
    init(coordinator: ChatCoordinator?, chatRoom: ChatRoom) {
        self.coordinator = coordinator
        self.chatRoom = chatRoom
    }
    
    func transform(input: Input) -> Output {
        input.sendMessage
            .withUnretained(self)
            .subscribe(onNext: { _, message in
                print(message)
            })
            .disposed(by: disposeBag)
        
        return Output()
    }
}
