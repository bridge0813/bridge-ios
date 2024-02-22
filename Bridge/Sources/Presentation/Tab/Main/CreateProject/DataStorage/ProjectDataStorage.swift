//
//  ProjectDataStorage.swift
//  Bridge
//
//  Created by 엄지호 on 2023/09/18.
//

import Foundation
import RxSwift
import RxCocoa

final class ProjectDataStorage {
    private var project = Project(
        id: 0, 
        title: "",
        description: "",
        dDays: 0,
        deadline: Date(),
        startDate: nil,
        endDate: nil,
        memberRequirements: [],
        applicantRestrictions: [],
        progressMethod: "",
        progressStep: "",
        userName: "",
        isBookmarked: false,
        isMyProject: false,
        totalRecruitNumber: 0
    )
}

extension ProjectDataStorage {
    var currentProject: Project {
        return project
    }
    
    // MARK: - MemberFieldSelection(모집하려는 팀원의 분야설정)
    func removeAllMemberRequirements() {
        project.memberRequirements.removeAll()
    }
    
    // MARK: - MemberRequirementInput(분야의 세부 요구사항)
    func updateMemberRequirements(with requirement: MemberRequirement) {
        if let index = project.memberRequirements.firstIndex(where: { $0.field == requirement.field }) {
            project.memberRequirements[index] = requirement
        } else {
            project.memberRequirements.append(requirement)
        }
    }
    
    // MARK: - ApplicantRestriction(지원제한)
    func updateApplicantRestriction(with restriction: [String]) {
        project.applicantRestrictions = restriction
    }
    
    // MARK: - ProjectDatePicker(날짜설정)
    func updateDeadline(with date: Date) {
        project.deadline = date
    }
    
    func updateStartDate(with date: Date?) {
        project.startDate = date
    }
    
    func updateEndDate(with date: Date?) {
        project.endDate = date
    }
    
    // MARK: - ProjectProgressStatus(진행방식 및 현황)
    func updateProgressMethod(with method: String) {
        project.progressMethod = method
    }
    
    func updateProgressStep(with step: String) {
        project.progressStep = step
    }
    
    // MARK: - ProjectDescriptionInput(제목 및 소개)
    func updateTitle(with text: String) {
        project.title = text
    }
    
    func updateDescription(with text: String) {
        project.description = text
    }
}

// MARK: - Update
extension ProjectDataStorage {
    /// 업데이트 할 프로젝트를 주입
    func updateProject(with newProject: Project) {
        project.id = newProject.id
        project.title = newProject.title
        project.description = newProject.description
        project.dDays = newProject.dDays
        project.deadline = newProject.deadline
        project.startDate = newProject.startDate
        project.endDate = newProject.endDate
        project.memberRequirements = newProject.memberRequirements.map { requirement -> MemberRequirement in
            MemberRequirement(
                field: requirement.field.convertToUpperCaseFormat(),
                recruitNumber: requirement.recruitNumber,
                requiredSkills: requirement.requiredSkills,
                requirementText: requirement.requirementText
            )
        }
        project.applicantRestrictions = newProject.applicantRestrictions
        project.progressMethod = newProject.progressMethod
        project.progressStep = newProject.progressStep
        project.userName = newProject.userName
        project.isBookmarked = newProject.isBookmarked
        project.isMyProject = newProject.isMyProject
        project.totalRecruitNumber = newProject.totalRecruitNumber
    }
    
    /// 해당 분야에 있는 MemberRequirement 제거
    func removeMemberRequirement(for field: String) {
        project.memberRequirements.removeAll { $0.field == field }
    }
}
