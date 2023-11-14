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
        let dropdownItemSelected: Observable<String>
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
            .observe(on: MainScheduler.instance)
            .catch { [weak self] _ in
                self?.coordinator?.showErrorAlert(configuration: .defaultError)
                return .just([])
            }
        
        input.profileButtonTapped
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.coordinator?.showProfileViewController(of: owner.channel.opponentID)
            })
            .disposed(by: disposeBag)
        
        input.dropdownItemSelected
            .withUnretained(self)
            .subscribe(onNext: { owner, item in
                switch item {
                case "채팅방 나가기":
                    owner.coordinator?.showAlert(configuration: .leaveChannel, primaryAction: {
                        owner.leaveChannel()
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
            messages: messages.asDriver(onErrorJustReturn: [])
        )
    }
}

// MARK: - Data source
extension ChannelViewModel {
    enum Section {
        case main
    }
}

// MARK: - Dropdown selected
private extension ChannelViewModel {
    func leaveChannel() {
        leaveChannelUseCase.leaveChannel(id: channel.id)
            .observe(on: MainScheduler.instance)
            .subscribe(
                with: self,
                onNext: { owner, _ in
                    owner.coordinator?.pop()
                },
                onError: { owner, _ in
                    owner.coordinator?.showErrorAlert(configuration: .defaultError) {
                        owner.coordinator?.pop()
                    }
                }
            )
            .disposed(by: disposeBag)
    }
}
