//
//  CreateProjectDTO.swift
//  Bridge
//
//  Created by 엄지호 on 2023/11/19.
//

struct CreateProjectDTO: Encodable {
    let title: String
    let description: String
    let deadline: String
    let startDate: String?
    let endDate: String?
    let memberRequirements: [MemberRequirementDTO]
    let applicantRestrictions: [String]
    let progressMethod: String
    let progressStep: String
    let userId: Int?
    
    enum CodingKeys: String, CodingKey {
        case title, startDate, endDate, userId
        case description = "overview"
        case deadline = "dueDate"
        case memberRequirements = "recruit"
        case applicantRestrictions = "tagLimit"
        case progressMethod = "meetingWay"
        case progressStep = "stage"
    }
}

struct CreateProjectResponseDTO: Decodable {
    let projectId: Int
}
