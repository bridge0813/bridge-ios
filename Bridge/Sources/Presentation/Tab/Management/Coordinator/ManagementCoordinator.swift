//
//  ManagementCoordinator.swift
//  Bridge
//
//  Created by 엄지호 on 12/6/23.
//

import UIKit

final class ManagementCoordinator: Coordinator {
    // MARK: - Property
    weak var delegate: CoordinatorDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator]
    
    private let projectRepository: ProjectRepository
    private let profileRepository: ProfileRepository
    private let channelRepository: ChannelRepository
    private let messageRepository: MessageRepository
    
    private let fetchAppliedProjectsUseCase: FetchAppliedProjectsUseCase
    private let fetchMyProjectsUseCase: FetchMyProjectsUseCase
    private let deleteProjectUseCase: DeleteProjectUseCase
    private let cancelApplicationUseCase: CancelApplicationUseCase
    
    private let fetchApplicantListUseCase: FetchApplicantListUseCase
    private let acceptApplicantUseCase: AcceptApplicantUseCase
    private let rejectApplicantUseCase: RejectApplicantUseCase
    
    private let createChannelUseCase: CreateChannelUseCase
    
    // MARK: - Init
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.childCoordinators = []

        // 네트워크 서비스
        let networkService = DefaultNetworkService()
        let stompService = DefaultStompService(webSocketService: DefaultWebSocketService.shared)
        
        // 리포지토리
        projectRepository = MockProjectRepository()
        profileRepository = MockProfileRepository()
        channelRepository = DefaultChannelRepository(networkService: networkService, stompService: stompService)
        messageRepository = DefaultMessageRepository(networkService: networkService, stompService: stompService)

        // 관리
        fetchAppliedProjectsUseCase = DefaultFetchAppliedProjectsUseCase(projectRepository: projectRepository)
        fetchMyProjectsUseCase = DefaultFetchMyProjectsUseCase(projectRepository: projectRepository)
        deleteProjectUseCase = DefaultDeleteProjectUseCase(projectRepository: projectRepository)
        cancelApplicationUseCase = DefaultCancelApplicationUseCase(projectRepository: projectRepository)
        
        // 지원자 목록(수락, 거절)
        fetchApplicantListUseCase = DefaultFetchApplicantListUseCase(profileRepository: profileRepository)
        acceptApplicantUseCase = DefaultAcceptApplicantUseCase(projectRepository: projectRepository)
        rejectApplicantUseCase = DefaultRejectApplicantUseCase(projectRepository: projectRepository)
        
        // 채팅방 개설
        createChannelUseCase = DefaultCreateChannelUseCase(channelRepository: channelRepository)
    }
    
    // MARK: - Methods
    func start() {
        showManagementViewController()
    }
}

extension ManagementCoordinator {
    // MARK: - Show
    func showManagementViewController() {
        let viewModel = ManagementViewModel(
            coordinator: self,
            fetchAppliedProjectsUseCase: fetchAppliedProjectsUseCase,
            fetchMyProjectsUseCase: fetchMyProjectsUseCase,
            deleteProjectUseCase: deleteProjectUseCase,
            cancelApplicationUseCase: cancelApplicationUseCase
        )
        
        let vc = ManagementViewController(viewModel: viewModel)
        navigationController.pushViewController(vc, animated: true)
    }
    
    // 지원자 목록 이동
    func showApplicantListViewController(with projectID: Int) {
        let viewModel = ApplicantListViewModel(
            coordinator: self,
            projectID: projectID, 
            fetchApplicantListUseCase: fetchApplicantListUseCase, 
            acceptApplicantUseCase: acceptApplicantUseCase,
            rejectApplicantUseCase: rejectApplicantUseCase,
            createChannelUseCase: createChannelUseCase
        )
        
        let vc = ApplicantListViewController(viewModel: viewModel)
        navigationController.pushViewController(vc, animated: true)
    }
    
    // 채팅방 이동
    func showChannelViewController(of channel: Channel) {
        delegate?.showChannelViewController(of: channel, navigationController: navigationController)
    }
    
    // MARK: - Connect
    func connectToProjectDetailFlow(with projectID: Int) {
        let detailCoordinator = ProjectDetailCoordinator(navigationController: navigationController)
        detailCoordinator.start()
        detailCoordinator.didFinishEventClosure = { [weak self] in
            guard let self else { return }
            if let index = self.childCoordinators.firstIndex(where: { $0 === detailCoordinator }) {
                self.childCoordinators.remove(at: index)
            }
        }
        childCoordinators.append(detailCoordinator)
    }
}

// MARK: - CoordinatorDelegate
extension ManagementCoordinator: CoordinatorDelegate {
    func didFinish(childCoordinator: Coordinator) {
        navigationController.dismiss(animated: true)
        
        if let index = childCoordinators.firstIndex(where: { $0 === childCoordinator }) {
            childCoordinators.remove(at: index)
        }
    }
}
