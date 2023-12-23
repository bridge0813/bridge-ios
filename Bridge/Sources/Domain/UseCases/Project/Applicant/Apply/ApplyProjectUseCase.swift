//
//  ApplyProjectUseCase.swift
//  Bridge
//
//  Created by 엄지호 on 12/17/23.
//

import RxSwift

/// 모집글 지원
protocol ApplyProjectUseCase {
    func apply(projectID: Int) -> Observable<Void>
}

final class DefaultApplyProjectUseCase: ApplyProjectUseCase {
    
    private let applicantRepository: ApplicantRepository
    
    init(applicantRepository: ApplicantRepository) {
        self.applicantRepository = applicantRepository
    }
    
    func apply(projectID: Int) -> Observable<Void> {
        applicantRepository.apply(projectID: projectID)
    }
}
