//
//  ChannelViewModel.swift
//  Bridge
//
//  Created by 정호윤 on 10/16/23.
//

import RxCocoa
import RxSwift

final class ChannelViewModel: ViewModelType {
    // MARK: - Input & Output
    struct Input {
        let viewWillAppear: Observable<Bool>
        let profileButtonTapped: Observable<Void>
        let dropdownMenuItemSelected: Observable<String>
        let sendMessage: Observable<String>
    }
    
    struct Output {
        let channel: Driver<Channel>
        let messages: Driver<[Message]>
    }
    
    // MARK: - Property
    let disposeBag = DisposeBag()
    private weak var coordinator: ChatCoordinator?
    
    private let channel: Channel
    private let fetchMessagesUseCase: FetchMessagesUseCase
    private let leaveChannelUseCase: LeaveChannelUseCase
    
    // MARK: - Init
    init(
        coordinator: ChatCoordinator?,
        channel: Channel,
        fetchMessagesUseCase: FetchMessagesUseCase,
        leaveChannelUseCase: LeaveChannelUseCase
    ) {
        self.coordinator = coordinator
        self.channel = channel
        self.fetchMessagesUseCase = fetchMessagesUseCase
        self.leaveChannelUseCase = leaveChannelUseCase
    }
    
    // MARK: - Transformation
    func transform(input: Input) -> Output {
        let messages = input.viewWillAppear
            .withUnretained(self)
            .flatMap { owner, _ in
                owner.fetchMessagesUseCase.fetchMessages(channelId: owner.channel.id)
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
                    owner.coordinator?.showAlert(configuration: .leaveChannel, primaryAction: {
                        owner.coordinator?.pop()
                        //                        owner.leaveChannelUseCase.leaveChannel(id: owner.channel.id)
                        //                            .withUnretained(self)
                        //                            .subscribe(onNext: { owner, _ in
                        //                                owner.coordinator?.finish()
                        //                            })
                        //                            .disposed(by: disposeBag)
                    })
                    
                case "신고하기":
                    owner.coordinator?.showAlert(configuration: .report)
                    
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
            channel: Driver.just(channel),
            messages: messages.asDriver(onErrorJustReturn: [.onError])
        )
    }
}

// MARK: - Data source
extension ChannelViewModel {
    enum Section {
        case main
    }
}
