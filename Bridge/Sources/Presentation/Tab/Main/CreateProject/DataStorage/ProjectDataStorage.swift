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
        isScrapped: false,
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
