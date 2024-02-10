//
//  UpdateProjectCoordinator.swift
//  Bridge
//
//  Created by 엄지호 on 2/9/24.
//

import UIKit

final class UpdateProjectCoordinator: Coordinator {
    // MARK: - Property
    weak var delegate: CoordinatorDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator]

    private let projectDataStorage = ProjectDataStorage()
    private var updateProjectNavigationController: UINavigationController?

    private let projectRepository: ProjectRepository
   
    // MARK: - Init
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        childCoordinators = []

        let networkService = DefaultNetworkService()
        projectRepository = DefaultProjectRepository(networkService: networkService)
    }

    // MARK: - Methods
    func start() { }
    func start(with newProject: Project) {
        projectDataStorage.updateProject(with: newProject)
        
        let updateMemberFieldViewModel = UpdateMemberFieldViewModel(
            coordinator: self,
            dataStorage: projectDataStorage
        )
        
        let updateMemberFieldVC = UpdateMemberFieldViewController(viewModel: updateMemberFieldViewModel)
        updateProjectNavigationController = UINavigationController(rootViewController: updateMemberFieldVC)
        updateProjectNavigationController?.modalPresentationStyle = .fullScreen
        
        navigationController.present(
            updateProjectNavigationController ?? UINavigationController(),
            animated: true
        )
    }
}

// MARK: - Show
extension UpdateProjectCoordinator {
    /// 멤버 요구사항 정의 이동
    func showUpdateMemberRequirementViewController(selectedFields: [String]) {
         let updateMemberRequirementViewModel = UpdateMemberRequirementViewModel(
             coordinator: self,
             selectedFields: selectedFields,
             dataStorage: projectDataStorage
         )

         let updateMemberRequirementVC = UpdateMemberRequirementViewController(
             viewModel: updateMemberRequirementViewModel
         )
         updateProjectNavigationController?.pushViewController(updateMemberRequirementVC, animated: true)
     }
    
    /// 팀원 제한 정의 이동
    func showUpdateApplicantRestrictionViewController() {
        let updateApplicantRestrictionViewModel = UpdateApplicantRestrictionViewModel(
            coordinator: self,
            dataStorage: projectDataStorage
        )
        
        let updateApplicantRestrictionVC = UpdateApplicantRestrictionViewController(
            viewModel: updateApplicantRestrictionViewModel
        )
        updateProjectNavigationController?.pushViewController(updateApplicantRestrictionVC, animated: true)
    }
    
    /// 모집글 스케줄 관리 이동
    func showUpdateProjectScheduleViewController() {
        let updateProjectScheduleViewModel = UpdateProjectScheduleViewModel(
            coordinator: self,
            dataStorage: projectDataStorage
        )
        
        let updateProjectScheduleVC = UpdateProjectScheduleViewController(viewModel: updateProjectScheduleViewModel)
        updateProjectNavigationController?.pushViewController(updateProjectScheduleVC, animated: true)
    }
}

// MARK: - CoordinatorDelegate
extension UpdateProjectCoordinator: CoordinatorDelegate {
    func didFinish(childCoordinator: Coordinator) {
        navigationController.dismiss(animated: true)

        if let index = childCoordinators.firstIndex(where: { $0 === childCoordinator }) {
            childCoordinators.remove(at: index)
        }
    }
}
