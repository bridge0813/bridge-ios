//
//  UpdateProjectRequestDTO.swift
//  Bridge
//
//  Created by 엄지호 on 2/11/24.
//

struct UpdateProjectRequestDTO: Encodable {
    let title: String
    let description: String
    let deadline: String
    let startDate: String?
    let endDate: String?
    let memberRequirements: [MemberRequirementDTO]
    let applicantRestrictions: [String]
    let progressMethod: String
    let progressStep: String
    
    enum CodingKeys: String, CodingKey {
        case title, startDate, endDate
        case description = "overview"
        case deadline = "dueDate"
        case memberRequirements = "recruit"
        case applicantRestrictions = "tagLimit"
        case progressMethod = "meetingWay"
        case progressStep = "stage"
    }
}

extension UpdateProjectRequestDTO {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(title, forKey: .title)
        try container.encode(description, forKey: .description)
        try container.encode(deadline, forKey: .deadline)
        try container.encode(memberRequirements, forKey: .memberRequirements)
        try container.encode(applicantRestrictions, forKey: .applicantRestrictions)
        try container.encode(progressMethod, forKey: .progressMethod)
        try container.encode(progressStep, forKey: .progressStep)
        
        // startDate
        if let startDate = startDate {
            try container.encode(startDate, forKey: .startDate)
        } else {
            try container.encodeNil(forKey: .startDate)
        }
        
        // endDate
        if let endDate = endDate {
            try container.encode(endDate, forKey: .endDate)
        } else {
            try container.encodeNil(forKey: .endDate)
        }
    }
}
