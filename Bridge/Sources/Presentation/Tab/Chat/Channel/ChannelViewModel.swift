//
//  ChannelViewModel.swift
//  Bridge
//
//  Created by 정호윤 on 10/16/23.
//

import UIKit
import RxCocoa
import RxSwift

final class ChannelViewModel: ViewModelType {
    // MARK: - Input & Output
    struct Input {
        let viewWillAppear: Observable<Bool>
        let profileButtonTapped: Observable<Void>
        let dropdownItemSelected: Observable<String>
        let sendMessage: Observable<String>
        let viewDidDisappear: Observable<Bool>
    }
    
    struct Output {
        let channel: Driver<Channel>
        let messages: Driver<[Message]>
    }
    
    // MARK: - Property
    let disposeBag = DisposeBag()
    private var activeDisposeBag = DisposeBag()
    private weak var coordinator: ChatCoordinator?
    
    private let channel: Channel
    private let leaveChannelUseCase: LeaveChannelUseCase
    private let channelSubscriptionUseCase: ChannelSubscriptionUseCase
    private let observeMessageUseCase: ObserveMessageUseCase
    private let fetchMessagesUseCase: FetchMessagesUseCase
    private let sendMessageUseCase: SendMessageUseCase
    
    // MARK: - Init
    init(
        coordinator: ChatCoordinator?,
        channel: Channel,
        leaveChannelUseCase: LeaveChannelUseCase,
        channelSubscriptionUseCase: ChannelSubscriptionUseCase,
        observeMessageUseCase: ObserveMessageUseCase,
        fetchMessagesUseCase: FetchMessagesUseCase,
        sendMessageUseCase: SendMessageUseCase
    ) {
        self.coordinator = coordinator
        self.channel = channel
        self.leaveChannelUseCase = leaveChannelUseCase
        self.channelSubscriptionUseCase = channelSubscriptionUseCase
        self.observeMessageUseCase = observeMessageUseCase
        self.fetchMessagesUseCase = fetchMessagesUseCase
        self.sendMessageUseCase = sendMessageUseCase
    }
    
    // MARK: - Transformation
    func transform(input: Input) -> Output {
        let messages = BehaviorRelay<[Message]>(value: [])
        let stompDidConnected = NotificationCenter.default.rx
            .notification(.stompDidConnectedNotification)
            .share()
        let didEnterBackground = NotificationCenter.default.rx
            .notification(UIApplication.didEnterBackgroundNotification)
            .share()
        
        // 채널 구독 (stomp 구독 및 읽음 상태 업데이트)
        channelSubscriptionUseCase.subscribe(id: channel.id)
            .take(until: didEnterBackground)
            .bind(to: messages)
            .disposed(by: disposeBag)
        
        // 메시지 구독 (새로운 메시지 실시간 반영)
        observeMessageUseCase.observeMessage()
            .take(until: didEnterBackground)
            .map { incomingMessage in
                var currentMessages = messages.value
                currentMessages.append(incomingMessage)
                return currentMessages
            }
            .bind(to: messages)
            .disposed(by: disposeBag)
        
        // 백그라운드 상태에서 포그라운드로 전환 시 재구독 (view did load 트리거 안되므로)
        stompDidConnected
            .withUnretained(self)
            .flatMapLatest { owner, _ in
                owner.channelSubscriptionUseCase.subscribe(id: owner.channel.id)
            }
            .bind(to: messages)
            .disposed(by: disposeBag)
        
        stompDidConnected
            .withUnretained(self)
            .flatMapLatest { owner, _ in
                owner.observeMessageUseCase.observeMessage()
            }
            .map { incomingMessage in
                var currentMessages = messages.value
                currentMessages.append(incomingMessage)
                return currentMessages
            }
            .bind(to: messages)
            .disposed(by: disposeBag)
        
        stompDidConnected
            .withUnretained(self)
            .flatMapLatest { owner, _ in
                owner.fetchMessagesUseCase.fetchMessages(channelId: owner.channel.id)
            }
            .observe(on: MainScheduler.instance)
            .catch { [weak self] _ in
                self?.coordinator?.showErrorAlert(configuration: .defaultError) {
                    self?.coordinator?.pop()
                }
                return .just([])
            }
            .bind(to: messages)
            .disposed(by: disposeBag)
        
        // 기존 메시지 불러옴
        input.viewWillAppear
            .withUnretained(self)
            .flatMap { owner, _ in
                owner.fetchMessagesUseCase.fetchMessages(channelId: owner.channel.id)
            }
            .observe(on: MainScheduler.instance)
            .catch { [weak self] _ in
                self?.coordinator?.showErrorAlert(configuration: .defaultError) {
                    self?.coordinator?.pop()
                }
                return .just([])
            }
            .bind(to: messages)
            .disposed(by: disposeBag)
        
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
            .subscribe(onNext: { owner, message in
                owner.sendMessageUseCase.sendMessage(message, to: owner.channel.id)
            })
            .disposed(by: disposeBag)
        
        input.viewDidDisappear
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                if let didFinish = owner.coordinator?.didFinishEventClosure {
                    didFinish()
                }
                owner.channelSubscriptionUseCase.unsubscribe(id: owner.channel.id)
            })
            .disposed(by: disposeBag)
        
        // 백그라운드로 전환 시 구독을 해제 (view did disappear 트리거 안되므로)
        didEnterBackground
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.channelSubscriptionUseCase.unsubscribe(id: owner.channel.id)
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
