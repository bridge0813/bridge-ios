//
//  RejectApplicantUseCase.swift
//  Bridge
//
//  Created by 엄지호 on 12/12/23.
//

import RxSwift

/// 모집글의 지원을 거절하는 UseCase
protocol RejectApplicantUseCase {
    func reject(projectID: Int, applicantID: Int) -> Observable<Int>
}

final class DefaultRejectApplicantUseCase: RejectApplicantUseCase {
    
    private let applicantRepository: ApplicantRepository
    
    init(applicantRepository: ApplicantRepository) {
        self.applicantRepository = applicantRepository
    }
    
    func reject(projectID: Int, applicantID: Int) -> Observable<Int> {
        applicantRepository.reject(projectID: projectID, applicantID: applicantID)
    }
}
