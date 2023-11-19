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
    private var createProject = CreateProject(
        title: "",
        description: "",
        deadline: "",
        startDate: nil,
        endDate: nil,
        memberRequirements: [],
        applicantRestrictions: [],
        progressMethod: "",
        progressStep: ""
    )
}

extension ProjectDataStorage {
    // MARK: - MemberFieldSelection(모집하려는 팀원의 분야설정)
    func removeAllMemberRequirements() {
        createProject.memberRequirements.removeAll()
    }
    
    // MARK: - MemberRequirementInput(분야의 세부 요구사항)
    func updateMemberRequirements(with requirement: MemberRequirement) {
        if let index = createProject.memberRequirements.firstIndex(where: { $0.field == requirement.field }) {
            createProject.memberRequirements[index] = requirement
        } else {
            createProject.memberRequirements.append(requirement)
        }
    }
    
    // MARK: - ApplicantRestriction(지원제한)
    func updateApplicantRestriction(with restriction: [String]) {
        createProject.applicantRestrictions = restriction
    }
    
    // MARK: - ProjectDatePicker(날짜설정)
    func updateDeadline(with date: String) {
        createProject.deadline = date
    }
    
    func updateStartDate(with date: String?) {
        createProject.startDate = date
    }
    
    func updateEndDate(with date: String?) {
        createProject.endDate = date
    }
    
    // MARK: - ProjectProgressStatus(진행방식 및 현황)
    func updateProgressMethod(with method: String) {
        createProject.progressMethod = method
    }
    
    func updateProgressStep(with step: String) {
        createProject.progressStep = step
    }
    
    // MARK: - ProjectDescriptionInput(제목 및 소개)
    func updateTitle(with text: String) {
        createProject.title = text
    }
    
    func updateDescription(with text: String) {
        createProject.description = text
    }
}
