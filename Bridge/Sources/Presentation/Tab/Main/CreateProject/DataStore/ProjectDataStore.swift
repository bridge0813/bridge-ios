//
//  ProjectDataStore.swift
//  Bridge
//
//  Created by 엄지호 on 2023/09/18.
//

import Foundation
import RxSwift
import RxCocoa

final class ProjectDataStore {
    private var currentProject = Project(
            id: "",
            title: "",
            description: "",
            dDays: 0,
            recruitmentDeadline: Date(),
            startDate: nil,
            endDate: nil,
            memberRequirements: [],
            applicantRestrictions: [],
            progressMethod: "",
            progressStatus: "",
            userEmail: ""
        )
    
    // 현재 프로젝트 데이터 가져오기
    private func getCurrentProject() -> Project {
        return currentProject
    }
    
    // 프로젝트 데이터 업데이트
    private func updateProject(newProject: Project) {
        self.currentProject = newProject
    }
}

extension ProjectDataStore {
    // MARK: - MemberFieldSelection(모집하려는 팀원의 분야설정)
    func removeAllMemberRequirements() {
        var project = getCurrentProject()
        
        project.memberRequirements.removeAll()
        updateProject(newProject: project)
    }
    
    // MARK: - MemberRequirementInput(분야의 세부 요구사항)
    func updateMemberRequirements(with requirement: MemberRequirement) {
        var project = getCurrentProject()
        
        if let index = project.memberRequirements.firstIndex(where: { $0.field == requirement.field }) {
            project.memberRequirements[index] = requirement
        } else {
            project.memberRequirements.append(requirement)
        }
        
        updateProject(newProject: project)
    }
    
    // MARK: - ApplicantRestriction(지원제한)
    func updateApplicantRestriction(with restrictions: [ApplicantRestrictionViewModel.RestrictionTagType]) {
        var project = getCurrentProject()
        project.applicantRestrictions = restrictions.map { $0.rawValue }
        
        updateProject(newProject: project)
    }
    
    // MARK: - ProjectDatePicker(날짜설정)
    func updateRecruitmentDeadline(with date: Date) {
        var project = getCurrentProject()
        project.recruitmentDeadline = date
        
        updateProject(newProject: project)
    }
    
    func updateStartDate(with date: Date?) {
        var project = getCurrentProject()
        project.startDate = date
        
        updateProject(newProject: project)
    }
    
    func updateEndDate(with date: Date?) {
        var project = getCurrentProject()
        project.endDate = date
        
        updateProject(newProject: project)
    }
    
    // MARK: - ProjectProgressStatus(진행방식 및 현황)
    func updateProgressMethod(with method: String) {
        var project = getCurrentProject()
        project.progressMethod = method
        
        updateProject(newProject: project)
    }
    
    func updateProgressStatus(with status: String) {
        var project = getCurrentProject()
        project.progressStatus = status
        
        updateProject(newProject: project)
    }
    
    // MARK: - ProjectDescriptionInput(제목 및 소개)
    func updateTitle(with text: String) {
        var project = getCurrentProject()
        project.title = text
        
        updateProject(newProject: project)
    }
    
    func updateDescription(with text: String) {
        var project = getCurrentProject()
        project.description = text
        
        updateProject(newProject: project)
    }
}
