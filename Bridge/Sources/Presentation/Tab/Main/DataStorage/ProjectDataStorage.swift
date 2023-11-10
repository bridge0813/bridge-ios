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
    private var currentProject = Project(
            id: "",
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
            userEmail: ""
        )
}

extension ProjectDataStorage {
    // MARK: - MemberFieldSelection(모집하려는 팀원의 분야설정)
    func removeAllMemberRequirements() {
        currentProject.memberRequirements.removeAll()
    }
    
    // MARK: - MemberRequirementInput(분야의 세부 요구사항)
    func updateMemberRequirements(with requirement: MemberRequirement) {
        if let index = currentProject.memberRequirements.firstIndex(where: { $0.field == requirement.field }) {
            currentProject.memberRequirements[index] = requirement
        } else {
            currentProject.memberRequirements.append(requirement)
        }
    }
    
    // MARK: - ApplicantRestriction(지원제한)
    func updateApplicantRestriction(with restriction: [String]) {
        currentProject.applicantRestrictions = restriction
    }
    
    // MARK: - ProjectDatePicker(날짜설정)
    func updateDeadline(with date: Date) {
        currentProject.deadline = date
    }
    
    func updateStartDate(with date: Date?) {
        currentProject.startDate = date
    }
    
    func updateEndDate(with date: Date?) {
        currentProject.endDate = date
    }
    
    // MARK: - ProjectProgressStatus(진행방식 및 현황)
    func updateProgressMethod(with method: String) {
        currentProject.progressMethod = method
    }
    
    func updateProgressStep(with step: String) {
        currentProject.progressStep = step
    }
    
    // MARK: - ProjectDescriptionInput(제목 및 소개)
    func updateTitle(with text: String) {
        currentProject.title = text
    }
    
    func updateDescription(with text: String) {
        currentProject.description = text
    }
}
