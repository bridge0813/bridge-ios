//
//  Project.swift
//  Bridge
//
//  Created by 엄지호 on 2023/08/30.
//

import Foundation

// TODO: - 데이터 구조에 따라 수정필요
struct Project {
    let id: String
    let title: String
    let totalRequiredMembersCount: Int // 모집 인원
    let fields: [RecruitmentField] // 모집 분야
    let dDayCount: Int // 공고 마감일까지 D-Day
    let requiredFieldTag: [String] // 모집 분야 tag
    let requiredStackTag: [String] // 기술 스택 tag
    let startDate: String // 프로젝트 시작일
    let endDate: String // 프로젝트 마감일
}

extension Project {
    static var onError: Self {
        Project(
            id: UUID().uuidString,
            title: "오류",
            totalRequiredMembersCount: 0,
            fields: [],
            dDayCount: 0,
            requiredFieldTag: [],
            requiredStackTag: [],
            startDate: "",
            endDate: ""
        )
    }
}

extension Project {
    // 프로젝트 총 모집인원을 계산
    func calculateTotalRequiredMembersCount() -> Int {
        return fields.reduce(0) { total, field in
            switch field {
            case .developer(let subField):
                return total + calculateDeveloperSubFieldCount(subField)
                
            case .designer(let subField):
                return total + calculateDesignerSubFieldCount(subField)
                
            case .planner(let subField):
                return total + calculatePlannerSubFieldCount(subField)
            }
        }
    }
    
    private func calculateDeveloperSubFieldCount(_ subField: DeveloperSubField) -> Int {
        switch subField {
        case .iOS(let count):
            return count
            
        case .android(let count):
            return count
            
        case .frontend(let count):
            return count
            
        case .backend(let count):
            return count
        }
    }
    
    private func calculateDesignerSubFieldCount(_ subField: DesignerSubField) -> Int {
        switch subField {
        case .uiux(let count):
            return count
            
        case .bibx(let count):
            return count
            
        case .videoMotion(let count):
            return count
        }
    }
    
    private func calculatePlannerSubFieldCount(_ subField: PlannerSubField) -> Int {
        switch subField {
        case .pm(let count): return count
        }
    }
}
