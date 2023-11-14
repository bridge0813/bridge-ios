//
//  ChannelListViewModel.swift
//  Bridge
//
//  Created by 정호윤 on 2023/08/28.
//

import RxCocoa
import RxSwift

final class ChannelListViewModel: ViewModelType {
    // MARK: - Input & Output
    struct Input {
        let viewWillAppear: Observable<Bool>
        let itemSelected: Observable<Int>
        let leaveChannel: Observable<Int>
    }
    
    struct Output {
        let channels: Driver<[Channel]>
        let viewState: Driver<ViewState>
    }
    
    // MARK: - Property
    let disposeBag = DisposeBag()
    private weak var coordinator: ChatCoordinator?
    private let fetchChannelsUseCase: FetchChannelsUseCase
    private let leaveChannelUseCase: LeaveChannelUseCase
    
    // MARK: - Init
    init(
        coordinator: ChatCoordinator,
        fetchChannelsUseCase: FetchChannelsUseCase,
        leaveChannelUseCase: LeaveChannelUseCase
    ) {
        self.coordinator = coordinator
        self.fetchChannelsUseCase = fetchChannelsUseCase
        self.leaveChannelUseCase = leaveChannelUseCase
    }
    
    // MARK: - Transformation
    func transform(input: Input) -> Output {
        let channels = BehaviorRelay<[Channel]>(value: [])
        let viewState = BehaviorRelay<ViewState>(value: .general)
        
        input.viewWillAppear
            .withUnretained(self)
            .flatMap { owner, _ in
                owner.fetchChannelsUseCase.fetchChannels().toResult()
            }
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .success(let fetchedChannels):
                    viewState.accept(fetchedChannels.isEmpty ? .empty : .general)
                    channels.accept(fetchedChannels)
                    
                case .failure(let error):
                    owner.handleError(error, viewState: viewState)
                }
            })
            .disposed(by: disposeBag)
        
        input.itemSelected
            .withLatestFrom(channels) { index, currentChannels in
                currentChannels[index]
            }
            .withUnretained(self)
            .subscribe(onNext: { owner, selectedChannel in
                owner.coordinator?.showChannelViewController(of: selectedChannel)
            })
            .disposed(by: disposeBag)
        
        input.leaveChannel
            .withLatestFrom(channels) { index, currentChannels in
                currentChannels[index].id
            }
            .withUnretained(self)
            .flatMap { owner, channelID in
                owner.leaveChannelUseCase.leaveChannel(id: channelID)
            }
            .withUnretained(self)
            .flatMap { owner, _ in
                owner.fetchChannelsUseCase.fetchChannels()
            }
            .bind(to: channels)
            .disposed(by: disposeBag)
        
        return Output(
            channels: channels.asDriver(),
            viewState: viewState.asDriver()
        )
    }
}

// MARK: - View state handling
extension ChannelListViewModel {
    /// ChannelListViewController에서 보여줘야 하는 화면의 종류
    enum ViewState {
        case general
        case empty
        case signInNeeded
        case error
    }
    
    private func handleError(_ error: Error, viewState: BehaviorRelay<ViewState>) {
        switch error as? NetworkError {
        case .statusCode(let statusCode):
            viewState.accept(statusCode == 401 ? .signInNeeded : .error)
            
        default:
            viewState.accept(.error)
        }
    }
}

// MARK: - Data source
extension ChannelListViewModel {
    enum Section: CaseIterable {
        case main
    }
}
